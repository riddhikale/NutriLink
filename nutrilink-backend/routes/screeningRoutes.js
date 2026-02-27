const express = require("express");
const router = express.Router();

const { syncScreening } = require("../controllers/screeningController");

router.post("/sync-screening", syncScreening);

module.exports = router