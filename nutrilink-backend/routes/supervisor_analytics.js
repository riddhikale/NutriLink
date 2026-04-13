const express = require("express");
const router = express.Router();
const { spawn } = require("child_process");
const admin = require("firebase-admin");

router.post("/supervisor-analytics", async (req, res) => {

    try {

        const db = admin.firestore();

        let screeningData = [];
        const beneficiariesSnapshot = await db.collection("beneficiaries").get();

        for (const doc of beneficiariesSnapshot.docs) {

            const screeningsSnapshot = await doc.ref.collection("screenings").get();

            screeningsSnapshot.forEach(s => {

                const data = s.data();

                screeningData.push({
                    wardNo: Number(data.wardNo),
                    riskTag: data.riskLevel,
                    screeningDate: data.createdAt
                        ? data.createdAt.toDate().toISOString()
                        : null,
                    type: data.type || "unknown"
                });

            });

        }

        const pythonProcess = spawn("python", ["../supervisor_analytics/main.py"]);

        let result = "";
        let error = "";

        pythonProcess.stdin.write(JSON.stringify(screeningData));
        pythonProcess.stdin.end();

        pythonProcess.stdout.on("data", (data) => {
            const text = data.toString();
            console.log("PYTHON OUTPUT:", text);
            result += text;
        });

        pythonProcess.stderr.on("data", (data) => {
            console.error("Python stderr:", data.toString());
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