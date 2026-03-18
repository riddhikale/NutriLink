const {db} = require("../config/firebaseConfig");

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
      notes
    } = req.body

    const beneficiaryRef = db.collection("beneficiaries").doc();
    const beneficiaryId = beneficiaryRef.id;

    await beneficiaryRef.set({
      name,
      type: "child",
      createdAt: new Date()
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
      createdAt: new Date()
    };

    const screeningRef = await db
    .collection("beneficiaries")
    .doc(beneficiaryId)
    .collection("screenings")
    .add(screeningData);
    
    res.status(200).json({
      success: true,
      message: "Screening saved successfully!",
      screeningId : screeningRef.id
    });

  } catch(error){
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
      notes
    } = req.body;

    const beneficiaryRef = db.collection("beneficiaries").doc();
    const beneficiaryId = beneficiaryRef.id;

    await beneficiaryRef.set({
      name,
      type: "pregnant",
      createdAt: new Date()
    });

    const screeningData = {
      type: "pregnantWomen",
      beneficiaryId, name, husbandName, age, trimester,weight,hemoglobin,systolicBP,diastolicBP, dizziness,fatigue,swelling,lowAppetite,pastAnemia,notes: notes || "", createdAt: new Date()
    }

    const screeningRef = await db.collection("beneficiaries").doc(beneficiaryId).collection("screenings").add(screeningData);

    res.status(200).json({
      success: true,
      message: "Saved Successfully",
      screeningId: screeningRef.id
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