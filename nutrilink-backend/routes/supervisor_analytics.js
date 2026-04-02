const express = require("express");
const router = express.Router();
const { spawn } = require("child_process");
const admin = require("firebase-admin");

router.post("/supervisor-analytics", async (req, res) => {

    try {

        const db = admin.firestore();

        // Fetch screening records from Firestore
        const snapshot = await db.collection("screenings").get();

        let screeningData = [];

        snapshot.forEach(doc => {
            const data = doc.data();

            // Only push fields needed for analytics
            screeningData.push({
                wardNo: data.wardNo,
                riskTag: data.riskTag,
                screeningDate: data.screeningDate
            });
        });

        // Run Python analytics script
        const pythonProcess = spawn("python", ["../supervisor_analytics/main.py"]);

        let result = "";
        let error = "";

        // Send data to Python
        pythonProcess.stdin.write(JSON.stringify(screeningData));
        pythonProcess.stdin.end();

        // Receive Python output
        pythonProcess.stdout.on("data", (data) => {
            result += data.toString();
        });

        pythonProcess.stderr.on("data", (data) => {
            error += data.toString();
        });

        pythonProcess.on("close", () => {

            if (error) {
                return res.status(500).json({
                    success: false,
                    error: error
                });
            }

            try {

                const parsedResult = JSON.parse(result);

                res.json({
                    success: true,
                    analytics: parsedResult
                });

            } catch (parseError) {

                res.status(500).json({
                    success: false,
                    error: "Invalid JSON returned from analytics engine"
                });

            }

        });

    } catch (err) {

        res.status(500).json({
            success: false,
            error: err.message
        });

    }

});

module.exports = router;