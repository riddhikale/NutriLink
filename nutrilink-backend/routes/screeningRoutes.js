const express = require("express");
const router = express.Router();
const { childScreening, pregWomenScreening } = require("../controllers/screeningController");

const { authMiddleware } = require("../middlewares/authMiddleware"); // ← add

router.post("/screening/child", authMiddleware, childScreening);       // ← add middleware
router.post("/screening/pregWomen", authMiddleware, pregWomenScreening); // ← add middleware

module.exports = router;