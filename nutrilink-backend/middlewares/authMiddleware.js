// //const { admin } = require("../config/firebaseConfig")

// async function verifyToken(req, res, next) {
//     try{
//         const authHeader = req.headers.authorization;

//         if(!authHeader){
//             return res.status(401).json({message: "No token provided"});
//         }

//         const token = authHeader.split(" ")[1];
//         const decodeToken = await admin.auth().verifyIdToken(token)

//         req.user = decodeToken;
//         next();
        
//     } catch(error) {
//         res.status(401).send({message:'Invalid token'});
//     }
// }

// module.exports = { verifyToken }

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

module.exports = { authMiddleware };