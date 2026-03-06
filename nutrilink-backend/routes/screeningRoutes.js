const express = require("express");
const router = express.Router();

const { childScreening, pregWomenScreening } = require("../controllers/screeningController");

router.post("/screening/child", childScreening);
router.post("/screening/pregWomen", pregWomenScreening);

module.exports = router