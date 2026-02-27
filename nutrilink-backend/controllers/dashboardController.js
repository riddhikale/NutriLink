async function getAreaSummary(req, res){
  res.json({
    areaId: "A1",
    totalScreenings: 25,
    highRisk: 5,
    mediumRisk: 8
  });
};

async function getRiskHeatmap(req, res){
  res.json([
    { areaId: "A1", high: 5 },
    { areaId: "A2", high: 3 }
  ]);
};

async function getTrends(req, res){
  res.json({
    month: "February",
    improvementRate: "12%"
  });
};

module.exports = { getAreaSummary, getRiskHeatmap, getTrends }