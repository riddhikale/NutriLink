const { db } = require("../config/firebaseConfig");

async function createFollowUp(req, res) {
  try {
    const {
      beneficiaryId,
      screeningId,
      type,
      followUpDate,
      riskLevel,
    } = req.body;

    const workerId = req.user.phone;

    const followupData = {
      beneficiaryId,
      screeningId,
      type,
      followUpDate,
      workerId,
      riskLevel: riskLevel || null,
      status: "pending",
      createdAt: new Date(),
      completedAt: null,
    };

    const docRef = await db.collection("followups").add(followupData);

    res.json({
      success: true,
      followupId: docRef.id,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: "Followup creation failed",
    });
  }
}

async function getDueFollowups(req, res) {
  try {
    const workerId = req.user.phone;

    const snapshot = await db
      .collection("followups")
      .where("status", "==", "pending")
      .where("workerId", "==", workerId)
      .get();

    const followups = [];

    for (const doc of snapshot.docs) {
      const data = doc.data();

      const beneficiaryDoc = await db
        .collection("beneficiaries")
        .doc(data.beneficiaryId)
        .get();

      const beneficiaryData = beneficiaryDoc.data();

      followups.push({
        id: doc.id,
        name: beneficiaryData?.name || "Unknown",
        ...data,
      });
    }

    res.json(followups);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Failed to fetch followups" });
  }
}

async function getCompletedFollowups(req, res) {
  try {
    const workerId = req.user.phone;

    const snapshot = await db
      .collection("followups")
      .where("status", "==", "completed")
      .where("workerId", "==", workerId)
      .get();

    const followups = [];

    for (const doc of snapshot.docs) {
      const data = doc.data();

      const beneficiaryDoc = await db
        .collection("beneficiaries")
        .doc(data.beneficiaryId)
        .get();

      const beneficiaryData = beneficiaryDoc.data();

      followups.push({
        id: doc.id,
        name: beneficiaryData?.name || "Unknown",
        ...data,
      });
    }

    res.json(followups);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Failed to fetch completed followups" });
  }
}

async function completeFollowup(req, res) {
  try {
    const followupId = req.params.id;

    await db.collection("followups").doc(followupId).update({
      status: "completed",
      completedAt: new Date(),
    });

    res.json({
      success: true,
      message: "Followup completed",
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Followup update failed" });
  }
}

module.exports = {
  createFollowUp,
  getDueFollowups,
  getCompletedFollowups, 
  completeFollowup,
};