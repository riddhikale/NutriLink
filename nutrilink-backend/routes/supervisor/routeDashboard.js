const express = require("express");
const router = express.Router();

const {
  getDashboardSummary,
  getAreaSummary,
  getFollowupsDue,
  getRiskHeatmap,
  getTrendAnalysis
} = require("../../controllers/supervisor/controllerDashboard");

const { authMiddleware, verifySupervisor } = require("../../middlewares/authMiddleware");

router.get("/summary", authMiddleware, verifySupervisor, getDashboardSummary);
router.get("/area-summary", authMiddleware, verifySupervisor, getAreaSummary);
router.get("/followups-due", authMiddleware, verifySupervisor, getFollowupsDue);
router.get("/risk-heatmap", getRiskHeatmap);
router.get("/trend-analysis", getTrendAnalysis);

module.exports = router;