const { db } = require("../../config/firebaseConfig");

async function getDashboardSummary(req, res) {
  try {
    const snapshot = await db.collectionGroup("screenings").get();

    let total = 0, high = 0, medium = 0, low = 0;

    snapshot.forEach(doc => {
      const data = doc.data();
      total++;

      if (data.riskLevel === "high") high++;
      else if (data.riskLevel === "medium") medium++;
      else low++;
    });

    res.json({ total, high, medium, low });

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error fetching summary" });
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
        areaMap[area] = { high: 0, medium: 0, low: 0, total: 0 };
      }

      areaMap[area].total++;

      if (data.riskLevel === "high") areaMap[area].high++;
      else if (data.riskLevel === "medium") areaMap[area].medium++;
      else areaMap[area].low++;
    });

    res.json(areaMap);

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error fetching area summary" });
  }
}


async function getFollowupsDue(req, res) {
  try {
    const snapshot = await db
      .collection("followups")
      .where("status", "==", "pending")
      .get();

    const today = new Date();
    const result = [];

    snapshot.forEach(doc => {
      const data = doc.data();

      //const followupDate = new Date(data.followupDate);
      const rawDate = data.followUpDate;
      const followUpDate = rawDate?.toDate ? rawDate.toDate() : new Date(rawDate);

      //if (followupDate <= today || data.riskLevel === "high") {
      if (true) {
        result.push({
          name: data.name,
          risk: data.riskLevel,
          date: followUpDate,
          address: data.address
        });
      }
    });

    res.json(result);

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error fetching followups" });
  }
}
async function getRiskHeatmap(req, res) {
  try {
    const snapshot = await db.collection("followups").get();

    const areaMap = {};

    snapshot.forEach(doc => {
      const data = doc.data();

      const area = data.address || "Unknown";

      if (!areaMap[area]) {
        areaMap[area] = {
          count: 0
        };
      }

      if (data.riskLevel === "high") {
        areaMap[area].count += 2; // high weight
      } else if (data.riskLevel === "medium") {
        areaMap[area].count += 1;
      }
    });

    const result = Object.keys(areaMap).map(area => ({
      area,
      lat: 19.0,   // temporary
      lng: 72.8,   // temporary
      riskScore: areaMap[area].count
    }));

    res.json(result);

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

async function getTrendAnalysis(req, res) {
  try {
    const snapshot = await db.collection("followups").get();

    const monthMap = {};

    snapshot.forEach(doc => {
      const data = doc.data();

      if (!data.followUpDate || data.riskLevel !== "high") return;

      //const date = new Date(data.followUpDate);
      const rawDate = data.followUpDate;
      const date = rawDate.toDate ? rawDate.toDate() : new Date(rawDate);
      const month = date.toLocaleString("default", { month: "short" });

      if (!monthMap[month]) {
        monthMap[month] = 0;
      }

      monthMap[month]++;
    });

    const result = Object.keys(monthMap).map(month => ({
      month,
      highRisk: monthMap[month]
    }));

    res.json(result);

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

module.exports = {
  getDashboardSummary,
  getAreaSummary,
  getFollowupsDue,
  getRiskHeatmap,
  getTrendAnalysis
};