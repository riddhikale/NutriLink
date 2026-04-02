const express = require("express");
const router = express.Router();
const { spawn } = require("child_process");

router.post("/supervisor-analytics", async (req, res) => {

    try {

        const screeningData = req.body;

        // Run Python analytics script
        const pythonProcess = spawn("python", ["../supervisor_analytics/main.py"]);

        let result = "";
        let error = "";

        // Send JSON data to Python
        pythonProcess.stdin.write(JSON.stringify(screeningData));
        pythonProcess.stdin.end();

        // Receive analytics output
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