const express = require("express");
const router = express.Router();

const {
  createFollowUp,
  getDueFollowups,
  completeFollowup,
} = require("../controllers/followupController");

const { authMiddleware } = require("../middlewares/authMiddleware");

router.post("/followup", authMiddleware, createFollowUp);
router.get("/followups/due", authMiddleware, getDueFollowups);
router.patch("/followup/complete/:id", authMiddleware, completeFollowup);

module.exports = router;