const { messaging } = require("firebase-admin");
const {db} = require("../config/firebaseConfig");
async function childScreening(req, res){
  try{
    const {beneficiaryId,name,ageMonths,gender,parentName,weight,height,muac,weakness,lowAppetite,frequentIllness,diarrhea,notes} = req.body
    if(!beneficiaryId ){
      return res.status(400).json({
        success: false, 
        message: "Missing beneficiaryID fields"
      });
    }

    const screeningData = {
      beneficiaryId, name, ageMonths, gender, parentName, weight, height, muac, weakness, lowAppetite, frequentIllness, diarrhea, notes: notes || "", createdAt: new Date()
    };

    const docRef = await db.collection("beneficiaries").doc("beneficiaryId").collection("screenings").add(screeningData);
    
    res.status(200).json({
      success: true,
      message: "Screening saved successfully!",
      screeningId : docRef.id
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
    const { beneficiaryId, name, husbandName, age, trimester, weight, hemoglobin, systolicBP, diastolicBP, dizziness, fatigue, swelling, lowAppetite, pastAnemia,notes} = req.body;

    if(!beneficiaryId) {
      return res.json({
        success: false,
        message: "Missing required fields"
      });
    }

    const screeningData = {
      type: "pregnantWomen",
      beneficiaryId, name, husbandName, age, trimester,weight,hemoglobin,systolicBP,diastolicBP, dizziness,fatigue,swelling,lowAppetite,pastAnemia,notes: notes || "", createdAt: new Date()
    }

    const docRef = await db.collection("beneficiaries").doc("beneficiaryId").collection("screenings").add(screeningData);

    res.status(200).json({
      success: true,
      message: "Saved Successfully",
      screeningId: docRef.id
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