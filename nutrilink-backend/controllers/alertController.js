const { db } = require("../config/firebaseConfig");

async function getAlerts(req, res) {
  try {
    const snapshot = await db.collection("alerts").get();

    const alerts = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    }));

    res.json(alerts);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getPendingAlerts(req, res) {
  try {
    const snapshot = await db
      .collection("alerts")
      .where("status", "==", "pending")
      .get();

    const alerts = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    }));

    res.json(alerts);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function resolveAlert(req, res) {
  try {
    const { id } = req.params;

    await db.collection("alerts").doc(id).update({
      status: "resolved"
    });

    res.json({ message: "Alert resolved" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

module.exports = { getAlerts, getPendingAlerts, resolveAlert };