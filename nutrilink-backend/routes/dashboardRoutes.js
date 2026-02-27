const express = require("express");
const router = express.Router();

const { getAreaSummary, getRiskHeatmap, getTrends } = require("../controllers/dashboardController");

router.get("/area-summary", getAreaSummary);
router.get("/risk-heatMap", getRiskHeatmap);
router.get("/trends", getTrends);

module.exports = router