const express = require("express");
const router = express.Router();
const { db } = require("../config/firebaseConfig"); 
const { childScreening, pregWomenScreening } = require("../controllers/screeningController");
const { authMiddleware } = require("../middlewares/authMiddleware");

router.post("/screening/child", authMiddleware, childScreening);
router.post("/screening/pregWomen", authMiddleware, pregWomenScreening);

router.get(
  "/beneficiaries/:beneficiaryId/screenings/:screeningId",
  authMiddleware,
  async (req, res) => {
    try {
      const { beneficiaryId, screeningId } = req.params;
      const doc = await db
        .collection("beneficiaries")
        .doc(beneficiaryId)
        .collection("screenings")
        .doc(screeningId)
        .get();

      if (!doc.exists) return res.status(404).json({ message: "Not found" });
      res.status(200).json(doc.data());
    } catch (err) {
      console.error("Screening fetch error:", err);
      res.status(500).json({ message: "Failed to fetch screening", error: err.message });
    }
  }
);

module.exports = router;