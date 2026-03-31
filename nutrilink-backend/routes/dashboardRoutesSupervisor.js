const express = require("express");
const router = express.Router();

const {
  getDashboardSummary,
  getAreaSummary,
  getDueFollowups
} = require("../controllers/dashboardControllerSupervisor");

router.get("/summary", getDashboardSummary);
router.get("/area-summary", getAreaSummary);
router.get("/followups-due", getDueFollowups);

module.exports = router;