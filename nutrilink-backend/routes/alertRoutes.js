const express = require("express");
const router = express.Router();

const {
  getAlerts,
  getPendingAlerts,
  resolveAlert
} = require("../controllers/alertController");

router.get("/", getAlerts);
router.get("/pending", getPendingAlerts);
router.put("/:id/resolve", resolveAlert);

module.exports = router;