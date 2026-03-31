const { db } = require("../config/firebaseConfig");

async function getDashboardSummary(req, res) {
  try {
    const snapshot = await db.collectionGroup("screenings").get();

    let total = 0;
    let high = 0;
    let medium = 0;
    let low = 0;

    snapshot.forEach(doc => {
      const data = doc.data();
      total++;

      if (data.riskLevel === "high") high++;
      else if (data.riskLevel === "medium") medium++;
      else low++;
    });

    res.json({
      totalScreenings: total,
      highRisk: high,
      mediumRisk: medium,
      lowRisk: low
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error fetching dashboard summary" });
  }
}

async function getAreaSummary(req, res) {
  try {
    const snapshot = await db.collectionGroup("screenings").get();

    const areaMap = {};

    snapshot.forEach(doc => {
      const data = doc.data();
      const area = data.address || "Unknown";

      if (!areaMap[area]) {
        areaMap[area] = {
          high: 0,
          medium: 0,
          low: 0,
          total: 0
        };
      }

      areaMap[area].total++;

      if (data.riskLevel === "high") areaMap[area].high++;
      else if (data.riskLevel === "medium") areaMap[area].medium++;
      else areaMap[area].low++;
    });

    res.json(areaMap);

  } catch (error) {
    res.status(500).json({ message: "Error fetching area summary" });
  }
}

async function getDueFollowups(req, res) {
  try {
    const today = new Date();

    const snapshot = await db
      .collection("followups")
      .where("status", "==", "pending")
      .get();

    const result = [];

    snapshot.forEach(doc => {
      const data = doc.data();

      // if (new Date(data.followupDate) <= today) {
      if (new Date(data.followupDate) <= today) {
        result.push({
          name: data.name,
          risk: data.riskLevel,
          followupDate: data.followupDate
        });
      }
    });

    res.json(result);

  } catch (error) {
    res.status(500).json({ message: "Error fetching followups" });
  }
}

module.exports = {
  getDashboardSummary,
  getAreaSummary,
  getDueFollowups
};