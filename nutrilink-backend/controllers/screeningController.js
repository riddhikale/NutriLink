const { db } = require("../config/firebaseConfig");
const { calculateChildRisk, calculateWomenRisk } = require("../utils/riskCalculator");
const { getChildNutrition, getWomenNutrition } = require("../utils/nutritionCalculator");

async function childScreening(req, res) {
  try {
    const {
      name,
      ageMonths,
      gender,
      parentName,
      weight,
      height,
      muac,
      weakness,
      lowAppetite,
      frequentIllness,
      diarrhea,
      address,
      notes,
    } = req.body;

    const workerId = req.user?.phone || null;

    const safeName = name.trim().toLowerCase().replace(/\s+/g, "_");
    const beneficiaryId = `${safeName}_${Date.now()}`;

    const beneficiaryRef = db.collection("beneficiaries").doc(beneficiaryId);
    // const beneficiaryRef = db.collection("beneficiaries").doc();
    // const beneficiaryId = beneficiaryRef.id;

    await beneficiaryRef.set({
      name,
      address: address || "",   // ← fix: fallback to "" if not sent
      type: "child",
      createdAt: new Date(),
    });

    const result = calculateChildRisk({
      ageMonths,
      weight,
      height,
      muac,
      weakness,
      lowAppetite,
      frequentIllness,
      diarrhea,
    });

    const nutritionNeed = getChildNutrition({
      muac,
      weakness,
      frequentIllness,
      lowAppetite
    });

    const mealDoc = await db
      .collection("meal_plans")
      .doc(nutritionNeed)
      .get();

    // const mealPlan = mealDoc.data();
    const mealPlan = mealDoc.exists ? mealDoc.data() : (await db.collection("meal_plans").doc("balanced").get()).data();

    const screeningData = {
      beneficiaryId,
      name,
      ageMonths,
      gender,
      parentName,
      weight,
      height,
      muac,
      weakness,
      lowAppetite,
      frequentIllness,
      diarrhea,
      notes: notes || "",
      riskLevel: result.level,
      nutritionNeed,
      mealPlan,
      address: address || "", 
      createdAt: new Date(),
    };

    const screeningRef = await db
      .collection("beneficiaries")
      .doc(beneficiaryId)
      .collection("screenings")
      .add(screeningData);

    let followupType = "routine";
    let followupDate = new Date();

    if (result.level === "high") {
      followupType = "urgent";
      followupDate.setDate(followupDate.getDate() + 1);
    } else if (result.level === "medium") {
      followupType = "soon";
      followupDate.setDate(followupDate.getDate() + 3);
    } else {
      followupDate.setDate(followupDate.getDate() + 7);
    }

    await db.collection("followups").add({
      beneficiaryId,
      screeningId: screeningRef.id,   // ← fix: was undefined before
      workerId,                        // ← fix: attach worker so filtering works
      name,
      address: address || "",
      type: followupType,
      beneficiaryType: "child",
      riskLevel: result.level,
      followupDate,
      status: "pending",
      createdAt: new Date(),
    });

    if (result.level === "high") {
      await db.collection("alerts").add({
        beneficiaryId,
        screeningId: screeningRef.id,
        message: "High risk detected",
        status: "pending",
        createdAt: new Date(),
      });
    }

    res.status(200).json({
      success: true,
      message: "Screening saved successfully!",
      screeningId: screeningRef.id,
      level: result.level,
      nutritionNeed,
      mealPlan
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: "Screening failed!",
    });
  }
}

async function pregWomenScreening(req, res) {
  try {
    const {
      name,
      husbandName,
      age,
      trimester,
      weight,
      hemoglobin,
      systolicBP,
      diastolicBP,
      dizziness,
      fatigue,
      swelling,
      lowAppetite,
      pastAnemia,
      address,
      notes,
    } = req.body;

    const workerId = req.user?.phone || null;

    const safeName = name.trim().toLowerCase().replace(/\s+/g, "_");
    const beneficiaryId = `${safeName}_${Date.now()}`;

    const beneficiaryRef = db.collection("beneficiaries").doc(beneficiaryId);
    // const beneficiaryId = beneficiaryRef.id;

    // const beneficiaryRef = db.collection("beneficiaries").doc();
    

    await beneficiaryRef.set({
      name,
      address: address || "",   // ← fix: fallback to ""
      type: "pregnant",
      createdAt: new Date(),
    });

    const result = calculateWomenRisk({
      age,
      weight,
      hemoglobin,
      systolicBP,
      diastolicBP,
      dizziness,
      fatigue,
      swelling,
      lowAppetite,
      pastAnemia,
    });

    const nutritionNeed = getWomenNutrition({
      hemoglobin,
      fatigue,
      swelling
    });

    const mealDoc = await db
      .collection("meal_plans")
      .doc(nutritionNeed)
      .get();

    // const mealPlan = mealDoc.data();
      const mealPlan = mealDoc.exists ? mealDoc.data() : (await db.collection("meal_plans").doc("balanced").get()).data();


    const screeningData = {
      type: "pregnantWomen",
      beneficiaryId,
      name,
      husbandName,
      age,
      trimester,
      weight,
      hemoglobin,
      systolicBP,
      diastolicBP,
      dizziness,
      fatigue,
      swelling,
      lowAppetite,
      pastAnemia,
      nutritionNeed,
      mealPlan,
      address: address || "",
      notes: notes || "",
      riskLevel: result.level,
      createdAt: new Date(),
    };

    const screeningRef = await db
      .collection("beneficiaries")
      .doc(beneficiaryId)
      .collection("screenings")
      .add(screeningData);

    let followupType = "routine";
    let followupDate = new Date();

    if (result.level === "high") {
      followupType = "urgent";
      followupDate.setDate(followupDate.getDate() + 1);
    } else if (result.level === "medium") {
      followupType = "soon";
      followupDate.setDate(followupDate.getDate() + 3);
    } else {
      followupDate.setDate(followupDate.getDate() + 7);
    }

    await db.collection("followups").add({
      beneficiaryId,
      screeningId: screeningRef.id,  
      workerId,                      
      name,
      address: address || "",
      type: followupType,
      beneficiaryType: "pregnant",
      riskLevel: result.level,
      nutritionNeed,
      followupDate,
      status: "pending",
      createdAt: new Date(),
    });

    if (result.level === "high") {
      await db.collection("alerts").add({
        beneficiaryId,
        screeningId: screeningRef.id,
        message: "High risk detected",
        status: "pending",
        createdAt: new Date(),
      });
    }

    res.status(200).json({
      success: true,
      message: "Saved Successfully",
      screeningId: screeningRef.id,
      level: result.level,
      nutritionNeed,
      mealPlan
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: "Screening failed!",
    });
  }
}

module.exports = { childScreening, pregWomenScreening };