const jwt = require("jsonwebtoken");

function authMiddleware(req, res, next) {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({ message: "No token provided" });
    }

    const token = authHeader.split("Bearer ")[1];

    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // ── phone is the unique user identifier in your Firestore ──
    req.user = {
      phone: decoded.phone,
      role: decoded.role,
    };

    next();
  } catch (error) {
    return res.status(401).json({ message: "Invalid or expired token" });
  }
}

function verifySupervisor(req, res, next) {
  try {
    if (!req.user || req.user.role !== "SUPERVISOR") {
      return res.status(403).json({ message: "Access denied" });
    }
    next();
  } catch (err) {
    res.status(500).json({ message: "Auth error" });
  }
}


module.exports = { authMiddleware, verifySupervisor };