const express = require('express');
const router = express.Router();

const { registerTest, loginTest } = require("../controllers/authController");
// const { verifyToken } = require("../middlewares/authMiddleware");

router.post("/register", registerTest);
router.post("/login-test", loginTest);

module.exports = router;