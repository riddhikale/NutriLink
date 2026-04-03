const express = require("express");
const router = express.Router();

const {
  getDashboardSummary,
  getAreaSummary,
  getFollowupsDue
} = require("../../controllers/supervisor/controllerDashboard");

const { authMiddleware, verifySupervisor } = require("../../middlewares/authMiddleware");

router.get("/summary", authMiddleware, verifySupervisor, getDashboardSummary);
router.get("/area-summary", authMiddleware, verifySupervisor, getAreaSummary);
router.get("/followups-due", authMiddleware, verifySupervisor, getFollowupsDue);

module.exports = router;