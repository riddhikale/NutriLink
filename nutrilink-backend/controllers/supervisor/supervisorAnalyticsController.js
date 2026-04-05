// const { db } = require("../../config/firebaseConfig");
// const { spawn } = require("child_process");
// const path = require("path");


// async function getSupervisorAnalytics(req, res) {
//   try {
//     const snapshot = await db.collectionGroup("screenings").get();

//     const data = snapshot.docs.map(doc => doc.data());


//     const formatted = data.map(d => ({
//       wardNo: d.wardNo || "Unknown",

//       riskTag: d.riskLevel,

//       screeningDate: d.createdAt
//         ? (d.createdAt.toDate
//             ? d.createdAt.toDate().toISOString()
//             : d.createdAt)
//         : null,

//       type: d.beneficiaryType || "unknown"
//     }));

//     console.log("Sending to Python:", formatted);

//     const python = spawn("python", [
//       path.join(__dirname, "../../../supervisor_analytics/main.py")
//     ]);

//     let result = "";
//     let error = "";

//     python.stdin.write(JSON.stringify(formatted));
//     python.stdin.end();


//     python.stdout.on("data", (data) => {
//       console.log("PYTHON OUTPUT:", data.toString());
//       result += data.toString();
//     });

//     python.stderr.on("data", (data) => {
//       error += data.toString();
//     });

//     console.log("DATA FROM FIRESTORE:", data);
//     console.log("FORMATTED:", formatted);

//     python.on("close", () => {
//       if (error) {
//         console.error("PYTHON ERROR:", error);
//         return res.status(500).json({ error });
//       }

//       if (!result) {
//         return res.status(500).json({
//           error: "No response from Python"
//         });
//       }

//       try {
//         const parsed = JSON.parse(result);

//         res.json({
//           analytics: parsed
//         });

//       } catch (e) {
//         console.error("JSON ERROR:", e);
//         res.status(500).json({
//           error: "Invalid JSON from Python"
//         });
//       }
//     });

//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ error: err.message });
//   }
// }

// module.exports = { getSupervisorAnalytics };

const { db } = require("../../config/firebaseConfig");
const { spawn } = require("child_process");
const path = require("path");

async function getSupervisorAnalytics(req, res) {
  try {
    // ✅ GET ALL SCREENINGS (IMPORTANT FIX)
    const snapshot = await db.collectionGroup("screenings").get();

    const data = snapshot.docs.map(doc => doc.data());

    console.log("DATA FROM FIRESTORE =", data);

    // ✅ FORMAT FOR PYTHON
    const formatted = data.map(d => ({
      wardNo: d.wardNo || "Unknown",
      riskTag: d.riskLevel,
      screeningDate: d.createdAt
        ? (d.createdAt.toDate
            ? d.createdAt.toDate().toISOString()
            : d.createdAt)
        : null,
      type: d.type || "unknown"
    }));

    console.log("FORMATTED =", formatted);

    // ✅ FIX PATH (VERY IMPORTANT)
    const pythonPath = path.join(__dirname, "../../../supervisor_analytics/main.py");

    const python = spawn("python", [pythonPath]);

    let result = "";
    let error = "";

    python.stdin.write(JSON.stringify(formatted));
    python.stdin.end();

    python.stdout.on("data", (data) => {
      result += data.toString();
    });

    python.stderr.on("data", (data) => {
      error += data.toString();
    });

    python.on("close", () => {
      if (error) {
        console.error("PYTHON ERROR:", error);
        return res.status(500).json({ error });
      }

      try {
        const parsed = JSON.parse(result);

        res.json({
          analytics: parsed
        });

      } catch (e) {
        console.error("JSON ERROR:", e);
        res.status(500).json({
          error: "Invalid JSON from Python"
        });
      }
    });

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
}

module.exports = { getSupervisorAnalytics };