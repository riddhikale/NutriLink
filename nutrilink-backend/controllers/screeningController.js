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
      wardNo, 
      notes,
    } = req.body;

    const workerId = req.user?.phone || null;

    const safeName = name.trim().toLowerCase().replace(/\s+/g, "_");
    const beneficiaryId = `${safeName}_${Date.now()}`;

    const beneficiaryRef = db.collection("beneficiaries").doc(beneficiaryId);

    await beneficiaryRef.set({
      name,
      address: address || "",
      wardNo: wardNo || "",   // ← NEW
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
      lowAppetite,
    });

    const mealDoc = await db
      .collection("meal_plans")
      .doc(nutritionNeed)
      .get();

    const mealPlan = mealDoc.exists
      ? mealDoc.data()
      : (await db.collection("meal_plans").doc("balanced").get()).data();

    const uniqueIds = Date.now().toString().slice(-4);
    const screeningId = `${safeName}_${uniqueIds}`;

    const screeningData = {
      screeningId,
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
      wardNo: wardNo || "",   
      createdAt: new Date(),
    };


    const screeningRef = db
      .collection("beneficiaries")
      .doc(beneficiaryId)
      .collection("screenings")
      .doc(screeningId);

    await screeningRef.set(screeningData);

    let followupType = "routine";
    let followUpDate = new Date();

    if (result.level === "high") {
      followupType = "urgent";
      followUpDate.setDate(followUpDate.getDate() + 1);
    } else if (result.level === "medium") {
      followupType = "soon";
      followUpDate.setDate(followUpDate.getDate() + 3);
    } else {
      followUpDate.setDate(followUpDate.getDate() + 7);
    }

    const uniqueId = Date.now().toString().slice(-4);
    const followupId = `${safeName}_${uniqueId}`;
    
    await db.collection("followups")
    .doc(followupId)
    .set({
      beneficiaryId,
      screeningId: screeningRef.id,
      workerId: workerId || null,
      name,
      address: address || "",
      wardNo: wardNo || "", 
      type: followupType,
      beneficiaryType: "child",
      riskLevel: result.level,
      followUpDate,
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
      mealPlan,
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
      wardNo,  
      notes,
    } = req.body;

    const workerId = req.user?.phone || null;

    const safeName = name.trim().toLowerCase().replace(/\s+/g, "_");
    const beneficiaryId = `${safeName}_${Date.now()}`;

    const beneficiaryRef = db.collection("beneficiaries").doc(beneficiaryId);

    await beneficiaryRef.set({
      name,
      address: address || "",
      wardNo: wardNo || "",  
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
      swelling,
    });

    const mealDoc = await db
      .collection("meal_plans")
      .doc(nutritionNeed)
      .get();

    const mealPlan = mealDoc.exists
      ? mealDoc.data()
      : (await db.collection("meal_plans").doc("balanced").get()).data();

    const uniqueIds = Date.now().toString().slice(-4);
    const screeningId = `${safeName}_${uniqueIds}`;

    const screeningData = {
      screeningId,
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
      wardNo: wardNo || "",   
      notes: notes || "",
      riskLevel: result.level,
      createdAt: new Date(),
    };

    const screeningRef = db
      .collection("beneficiaries")
      .doc(beneficiaryId)
      .collection("screenings")
      .doc(screeningId);

    await screeningRef.set(screeningData);

    let followupType = "routine";
    let followUpDate = new Date();

    if (result.level === "high") {
      followupType = "urgent";
      followUpDate.setDate(followUpDate.getDate() + 1);
    } else if (result.level === "medium") {
      followupType = "soon";
      followUpDate.setDate(followUpDate.getDate() + 3);
    } else {
      followUpDate.setDate(followUpDate.getDate() + 7);
    }

    const uniqueId = Date.now().toString().slice(-4);
    const followupId = `${safeName}_${uniqueId}`;

    await db.collection("followups")
    .doc(followupId)
    .set({
      beneficiaryId,
      screeningId: screeningRef.id,
      workerId,
      name,
      address: address || "",
      wardNo: wardNo || "",   // ← NEW
      type: followupType,
      beneficiaryType: "pregnant",
      riskLevel: result.level,
      nutritionNeed,
      followUpDate,
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
      mealPlan,
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