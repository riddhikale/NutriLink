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

async function verifyToken(req, res, next){
  const authHeader = req.headers.authorization;

  if (!authHeader) {
    return res.status(401).json({ message: "No token provided" });
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    res.status(401).json({ message: "Invalid token" });
  }
};

module.exports = verifyToken;