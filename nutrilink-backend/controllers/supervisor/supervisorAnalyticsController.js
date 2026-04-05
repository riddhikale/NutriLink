// const { db } = require("../../config/firebaseConfig");

// async function getSupervisorAnalytics(req, res) {
//   try {
//     const snapshot = await db.collection("followups").get();

//     const data = snapshot.docs.map(doc => doc.data());

//     const riskDistribution = [
//       { riskLevel: "high", count: 0 },
//       { riskLevel: "medium", count: 0 },
//       { riskLevel: "low", count: 0 }
//     ];

//     data.forEach(d => {
//       const r = riskDistribution.find(x => x.riskLevel === d.riskLevel);
//       if (r) r.count++;
//     });

//     const wardMap = {};

//     data.forEach(d => {
//       const ward = d.wardNo || "Unknown";

//       if (!wardMap[ward]) {
//         wardMap[ward] = { high: 0, medium: 0, low: 0 };
//       }

//       wardMap[ward][d.riskLevel]++;
//     });

//     const wardSummary = Object.keys(wardMap).map(w => ({
//       ward: w,
//       ...wardMap[w]
//     }));

//     const trendMap = {};

//     data.forEach(d => {
//       if (!d.followUpDate || d.riskLevel !== "high") return;

//       const date = d.followUpDate.toDate
//         ? d.followUpDate.toDate()
//         : new Date(d.followUpDate);

//       const month = date.toISOString().slice(0, 7);

//       if (!trendMap[month]) trendMap[month] = 0;
//       trendMap[month]++;
//     });

//     const trend = Object.keys(trendMap).map(m => ({
//       month: m,
//       highRiskCases: trendMap[m]
//     }));

//     const heatmap = data.map(d => ({
//       lat: 19.0,
//       lng: 72.8,
//       riskCount: d.riskLevel === "high" ? 3 : d.riskLevel === "medium" ? 2 : 1
//     }));

//     const coverageMap = {};

//     data.forEach(d => {
//       const ward = d.wardNo || "Unknown";
//       if (!coverageMap[ward]) coverageMap[ward] = 0;
//       coverageMap[ward]++;
//     });

//     const coverage = Object.keys(coverageMap).map(w => ({
//       ward: w,
//       count: coverageMap[w]
//     }));

//     const hotspots = wardSummary
//       .map(w => ({ ward: w.ward, high: w.high }))
//       .sort((a, b) => b.high - a.high)
//       .slice(0, 5);

//     const riskIndex = wardSummary.map(w => ({
//       ward: w.ward,
//       score: w.high * 3 + w.medium * 2 + w.low * 1
//     }));

//     res.json({
//       analytics: {
//         riskDistribution,
//         wardSummary,
//         trend,
//         heatmap,
//         coverage,
//         hotspots,
//         riskIndex
//       }
//     });

//   } catch (err) {
//     res.status(500).json({ error: err.message });
//   }
// }

// module.exports = { getSupervisorAnalytics };

const { db } = require("../../config/firebaseConfig");
const { spawn } = require("child_process");
const path = require("path");


async function getSupervisorAnalytics(req, res) {
  try {
    const snapshot = await db.collectionGroup("screenings").get();

    const data = snapshot.docs.map(doc => doc.data());

    // 🔹 STEP 3.1: Prepare data for Python
    // const formatted = data.map(d => ({
    //   wardNo: d.wardNo || "Unknown",
    //   riskLevel: d.riskLevel,
    //   followUpDate: d.followUpDate
    //     ? (d.followUpDate.toDate
    //         ? d.followUpDate.toDate().toISOString()
    //         : d.followUpDate)
    //     : null,
    //   type: d.beneficiaryType || "unknown"
    // }));

    const formatted = data.map(d => ({
      wardNo: d.wardNo || "Unknown",

      riskTag: d.riskLevel,

      screeningDate: d.createdAt
        ? (d.createdAt.toDate
            ? d.createdAt.toDate().toISOString()
            : d.createdAt)
        : null,

      type: d.beneficiaryType || "unknown"
    }));

    console.log("Sending to Python:", formatted);

    // 🔹 STEP 3.2: Call Python
    //const python = spawn("python", ["../../supervisor_analytics/main.py"]);
    const python = spawn("python", [
      path.join(__dirname, "../../../supervisor_analytics/main.py")
    ]);

    let result = "";
    let error = "";

    python.stdin.write(JSON.stringify(formatted));
    python.stdin.end();

    // python.stdout.on("data", (data) => {
    //   result += data.toString();
    // });

    python.stdout.on("data", (data) => {
      console.log("PYTHON OUTPUT:", data.toString());
      result += data.toString();
    });

    python.stderr.on("data", (data) => {
      error += data.toString();
    });

    console.log("DATA FROM FIRESTORE:", data);
    console.log("FORMATTED:", formatted);

    // python.on("close", () => {
    //   if (error) {
    //     console.error("PYTHON ERROR:", error);
    //     return res.status(500).json({ error });
    //   }

    //   try {
    //     const parsed = JSON.parse(result);

    //     res.json({
    //       analytics: parsed
    //     });

    //   } catch (e) {
    //     console.error("JSON ERROR:", e);
    //     res.status(500).json({
    //       error: "Invalid JSON from Python"
    //     });
    //   }
    // });
    python.on("close", () => {
      if (error) {
        console.error("PYTHON ERROR:", error);
        return res.status(500).json({ error });
      }

      if (!result) {
        return res.status(500).json({
          error: "No response from Python"
        });
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