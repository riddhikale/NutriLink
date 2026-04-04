const express = require('express');
const router = express.Router();

const { registerTest, loginTest, deleteAccount } = require("../controllers/authController");
const { authMiddleware } = require("../middlewares/authMiddleware"); // ← was verifyToken

router.delete("/user/account", authMiddleware, deleteAccount);
router.post("/register", registerTest);
router.post("/login-test", loginTest);

module.exports = router;