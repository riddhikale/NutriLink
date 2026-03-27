const {db} = require("../config/firebaseConfig");
const {calculateChildRisk, calculateWomenRisk} = require("../utils/riskCalculator");

async function childScreening(req, res){
  try{
    const {name,
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
      notes
    } = req.body

    const beneficiaryRef = db.collection("beneficiaries").doc();
    const beneficiaryId = beneficiaryRef.id;

    await beneficiaryRef.set({
      name,
      address,
      type: "child",
      createdAt: new Date()
    });

    const result = calculateChildRisk({
      ageMonths,
      weight,
      height,
      muac,
      weakness,
      lowAppetite,
      frequentIllness,
      diarrhea
    });

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
      address,
      createdAt: new Date()
    };

    const screeningRef = await db
    .collection("beneficiaries")
    .doc(beneficiaryId)
    .collection("screenings")
    .add(screeningData);

    let followupType = "normal";
    let followupDate = new Date();

    if (result.level === "high") {
      followupType = "urgent";
    } else if (result.level === "medium") {
      followupType = "soon";
    } else {
      followupType = "routine";
    }

    if (result.level === "high") {
      followupDate.setDate(followupDate.getDate() + 1)
    } else if (result.level === "medium") {
      followupDate.setDate(followupDate.getDate() + 3);
    } else {
      followupDate.setDate(followupDate.getDate() + 7);
    }

    await db.collection("followups").add({
    beneficiaryId,
    screeningId,
    name,        // ✅ add this
    address,     // ✅ add this
    type: followupType,
    riskLevel: result.level,
    followupDate,
    status: "pending",
    createdAt: new Date()
    });
    if (result.level === "high") {
      await db.collection("alerts")
      .add({
        beneficiaryId,
        screeningId: screeningRef.id,
        message: "High risk detected",
        status: "pending",
        createdAt: new Date()
      });
    }
    
    res.status(200).json({
      success: true,
      message: "Screening saved successfully!",
      screeningId: screeningRef.id,
      level: result.level
    });
  }catch(error){
    console.error(error);
    res.status(500).json({
      success: false,
      message: "Screening failed!"
    })
  }
};


async function pregWomenScreening(req,res){
  try{
    const {name, 
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
      notes
    } = req.body;

    const beneficiaryRef = db.collection("beneficiaries").doc();
    const beneficiaryId = beneficiaryRef.id;

    await beneficiaryRef.set({
      name,
      address,
      type: "pregnant",
      createdAt: new Date()
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
      pastAnemia
    });


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
      address,
      notes: notes || "", 
      riskLevel: result.level,
      createdAt: new Date()
    }

    const screeningRef = await db
    .collection("beneficiaries")
    .doc(beneficiaryId)
    .collection("screenings")
    .add(screeningData);

    let followupType = "normal";
    let followupDate = new Date();

    if (result.level === "high") {
      followupType = "urgent";
    } else if (result.level === "medium") {
      followupType = "soon";
    } else {
      followupType = "routine";
    }

    if (result.level === "high") {
      followupDate.setDate(followupDate.getDate() + 1); // next day
    } else if (result.level === "medium") {
      followupDate.setDate(followupDate.getDate() + 3);
    } else {
      followupDate.setDate(followupDate.getDate() + 7);
    }

    await db.collection("followups").add({
      beneficiaryId,
      screeningId,
      name,
      address,
      type: followupType,
      riskLevel: result.level,
      followupDate,
      status: "pending",
      createdAt: new Date()
    });

    if (result.level === "high") {
      await db.collection("alerts").add({
        beneficiaryId,
        screeningId: screeningRef.id,
        message: "High risk detected",
        status: "pending",
        createdAt: new Date()
      });
    }

    res.status(200).json({
      success: true,
      message: "Saved Successfully",
      screeningId: screeningRef.id,
      level: result.level
    })

  } catch(error){
    console.error(error);

    res.status(500).json({
      success: false, 
      message: "Screening failed!"
    })
  }
}

module.exports = { childScreening, pregWomenScreening }