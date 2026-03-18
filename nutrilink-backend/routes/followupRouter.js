// const express = require("express");
// const router = express.Router();

// const {
//   createFollowUp,
//   getDueFollowups,
//   completeFollowup
// } = require("../controllers/followupController");

// router.post("/followup", createFollowUp);
// router.get("/followups/due", getDueFollowups);
// router.patch("/followup/complete/:id", completeFollowup);

// module.exports = router;

const express = require("express");
const router = express.Router();

const {
  createFollowUp,
  getDueFollowups,
  completeFollowup
} = require("../controllers/followupController");

router.post("/followup", createFollowUp);
router.get("/followups/due", getDueFollowups);
router.patch("/followup/complete/:id", completeFollowup);

module.exports = router;