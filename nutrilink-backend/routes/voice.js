const express = require("express");
const multer = require("multer");
const fs = require("fs");

const router = express.Router();

const upload = multer({ dest: "uploads/" });

router.post("/voice", upload.single("audio"), async (req, res) => {
  try {

    const buffer = fs.readFileSync(req.file.path);

    const file = new File(
      [buffer],
      req.file.originalname,
      { type: "audio/wav" }
    );

    const formData = new FormData();
    formData.append("file", file);

    const response = await fetch("http://127.0.0.1:8001/transcribe", {
      method: "POST",
      body: formData
    });

    const data = await response.json();

    res.json(data);

  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Voice processing failed" });
  }
});

module.exports = router;