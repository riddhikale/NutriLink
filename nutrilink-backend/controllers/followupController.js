const { db } = require("../config/firebaseConfig");

async function createFollowUp(req,res){

  try{

    const { beneficiaryId, screeningId, type, followUpDate, workerId } = req.body;

    const followupData = {
      beneficiaryId,
      screeningId,
      type,
      followUpDate,
      workerId,
      status: "pending",
      createdAt: new Date(),
      completedAt: null
    };


    const docRef = await db
      .collection("beneficiaries")
      .doc(beneficiaryId)
      .collection("followups")
      .add(followupData);


    res.json({
      success:true,
      followupId: docRef.id
    });

  }
  catch(error){

    console.error(error);

    res.status(500).json({
      success:false,
      message:"Followup creation failed"
    });

  }

}

async function getDueFollowups(req,res){

  try{

    const beneficiariesSnapshot = await db.collection("beneficiaries").get();

    const followups = [];

    for(const beneficiaryDoc of beneficiariesSnapshot.docs){

      const followupSnapshot = await db
        .collection("beneficiaries")
        .doc(beneficiaryDoc.id)
        .collection("followups")
        .where("status","==","pending")
        .get();

      followupSnapshot.forEach(doc => {

        followups.push({
          id: doc.id,
          ...doc.data()
        });

      });

    }

    res.json(followups);

  }
  catch(error){

    console.error(error);

    res.status(500).json({
      message:"Failed to fetch followups"
    });

  }

}

async function completeFollowup(req,res){

  try{

    const followupId = req.params.id;
    const { beneficiaryId } = req.body;

    await db
      .collection("beneficiaries")
      .doc(beneficiaryId)
      .collection("followups")
      .doc(followupId)
      .update({
        status:"completed",
        completedAt:new Date()
      });

    res.json({
      success:true,
      message:"Followup completed"
    });

  }
  catch(error){

    console.error(error);

    res.status(500).json({
      message:"Followup update failed"
    });

  }

}

module.exports = {
  createFollowUp,
  getDueFollowups,
  completeFollowup
};