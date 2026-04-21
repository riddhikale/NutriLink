const { db } = require("../config/firebaseConfig");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

async function registerTest(req, res) {
  try {
    const { name, phone, pin, role } = req.body;
    const allowedRoles = ["FIELD_WORKER", "SUPERVISOR"];
    const cleanPhone = phone.trim();

    if (!name || !phone || !pin || !role) {
      return res.status(400).json({ success: false, message: "Missing required fields" });
    }

    if (!allowedRoles.includes(role)) {
      return res.status(400).json({ success: false, message: "Invalid role" });
    }

    const existingUser = await db.collection("users").doc(cleanPhone).get();

    if (existingUser.exists) {
      return res.status(400).json({ success: false, message: "Phone number already registered" });
    }

    const saltRounds = 10;
    const pinHash = await bcrypt.hash(pin, saltRounds);

    const safeName = name.trim().toLowerCase().replace(/\s+/g, "_");
    const userId = `${safeName}_${Date.now().toString().slice(-4)}`;

    await db.collection("users").doc(userId).set({
      name,
      phone: cleanPhone,
      pinHash,
      role,
      createdAt: new Date()
    });

    res.status(201).json({ success: true, message: "User registered successfully" });

  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: "Registration failed" });
  }
}

async function loginTest(req, res) {
  try {
    const { phone, pin } = req.body;

    if (!phone || !pin) {
      return res.status(400).json({ success: false, message: "Phone and Pin required" });
    }

    const cleanPhone = phone.trim();

    const snapshot = await db
      .collection("users")
      .where("phone", "==", cleanPhone)
      .limit(1)
      .get();

    if (snapshot.empty) {
      return res.status(404).json({ success: false, message: "User not found" });
    }

    const userDoc = snapshot.docs[0];
    const userData = userDoc.data();

    if (!userDoc.exists) {
      return res.status(404).json({ success: false, message: "User not found" });
    }

    const isMatch = await bcrypt.compare(pin, userData.pinHash);

    if (!isMatch) {
      return res.status(401).json({ success: false, message: "Invalid PIN" });
    }

    if (!["FIELD_WORKER", "SUPERVISOR"].includes(userData.role)) {
      return res.status(403).json({ success: false, message: "Unauthorized role" });
    }

    const token = jwt.sign(
      { phone: userData.phone, role: userData.role },
      process.env.JWT_SECRET,
      { expiresIn: "1d" }
    );

    res.status(200).json({
      success: true,
      message: "Login successful",
      token,
      user: {
        name: userData.name,
        role: userData.role,
      }
    });

  } catch (error) {
      console.error("LOGIN ERROR:", error);
      res.status(500).json({ success: false, message: error.message });
    }
}

async function deleteAccount(req, res) {
  try {
    const phone = req.user.phone;

    const snapshot = await db
      .collection("users")
      .where("phone", "==", phone)
      .get();

    if (snapshot.empty) {
      return res.status(404).json({ success: false, message: "User not found" });
    }

    const userDoc = snapshot.docs[0];
    await db.collection("users").doc(userDoc.id).delete();

    res.json({ success: true, message: "Account deleted successfully" });

  } catch (error) {
    console.error("❌ Error:", error);
    res.status(500).json({ success: false, message: "Failed to delete account" });
  }
}
module.exports = { loginTest, registerTest, deleteAccount };