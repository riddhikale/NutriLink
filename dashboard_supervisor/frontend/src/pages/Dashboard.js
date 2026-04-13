import { useEffect, useState } from "react";
import { getAnalytics, getFollowups } from "../services/api";

import DashboardCard from "../components/DashboardCard";
import TrendChart from "../components/TrendChart";
import RiskPieChart from "../components/RiskPieChart";
import WardChart from "../components/WardChart";
import AreaTable from "../components/AreaTable";
import FollowupList from "../components/FollowupList";

import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer } from "recharts";
import "../styles/dashboard.css";

function Dashboard() {
  const [analytics, setAnalytics] = useState(null);
  const [followups, setFollowups] = useState([]);
  const [error, setError] = useState(null);
  const [user, setUser] = useState({});

  useEffect(() => {
    const storedUser = localStorage.getItem("user");
    if (storedUser) {
      try {
        setUser(JSON.parse(storedUser));
      } catch (e) {
        console.error("Failed to parse user from local storage");
      }
    }
    loadData();
  }, []);

  async function loadData() {
    try {
      const res = await getAnalytics();
      const flips = await getFollowups() || [];
      if (res && res.analytics) {
        setAnalytics(res.analytics);
      } else {
        setError("Invalid response from backend");
      }
      setFollowups(flips);
    } catch (err) {
      console.error(err);
      setError("Server not reachable");
    }
  }

  function handleSignOut() {
    localStorage.removeItem("token");
    localStorage.removeItem("user");
    window.location.href = "/";
  }

  if (error) {
    return (
      <div style={{ padding: "20px", color: "red" }}>
        ❌ {error}
      </div>
    );
  }

  if (!analytics) {
    return (
      <div style={{ padding: "20px" }}>
        <h3>Loading Dynamic Dashboard...</h3>
      </div>
    );
  }

  const riskDist = analytics?.riskDistribution || [];

  const high = riskDist.find(r => r.riskLevel === "high" || r.riskLevel === "High")?.count || 0;
  const medium = riskDist.find(r => r.riskLevel === "medium" || r.riskLevel === "Medium")?.count || 0;
  const low = riskDist.find(r => r.riskLevel === "low" || r.riskLevel === "Low")?.count || 0;

  const total = high + medium + low;

  const highRiskFollowupsByWard = {};
  followups.forEach(f => {
    if ((f.risk || "").toLowerCase() === "high") {
       const w = f.address || "Unknown Ward";
       if(!highRiskFollowupsByWard[w]) highRiskFollowupsByWard[w] = [];
       highRiskFollowupsByWard[w].push(f);
    }
  });

  return (
    <div className="layout">
      <div className="sidebar">
        <h2>🍁 NutriLink</h2>
        <ul className="nav-links">
          <li className="active">📊 Dashboard</li>
        </ul>
        <div className="profile-box">
          <p>{user.name || "Dr. Supervisor"}</p>
          <small>{user.role ? user.role.replace("_", " ").toLowerCase() : "Admin Role"}</small>
          <button className="sign-out-btn" onClick={handleSignOut}>Sign Out</button>
        </div>
      </div>

      <div className="main">
        <div className="header">
          <h2>Dashboard Overview</h2>
        </div>

        <div className="cards">
          <DashboardCard title="Total Screened" value={total} type="total" />
          <DashboardCard title="High Risk" value={high} type="high" />
          <DashboardCard title="Medium Risk" value={medium} type="medium" />
          <DashboardCard title="Low Risk" value={low} type="low" />
        </div>

        <div className="grid">
          <div className="section">
            <h3>Risk Distribution</h3>
            <ResponsiveContainer width="100%" height={250}>
              <RiskPieChart data={riskDist} />
            </ResponsiveContainer>
          </div>

          <div className="section">
            <h3>Trend Analysis</h3>
            <ResponsiveContainer width="100%" height={250}>
              <TrendChart data={analytics?.trend || []} />
            </ResponsiveContainer>
          </div>
        </div>

        <div className="grid">
          <div className="section">
            <h3>Screening Coverage</h3>
            <ResponsiveContainer width="100%" height={250}>
              <BarChart data={analytics?.coverage || []}>
                <XAxis dataKey="wardNo" />
                <YAxis />
                <Tooltip cursor={{ fill: 'rgba(0,0,0,0.05)' }} />
                <Bar dataKey="screenings" fill="#388e3c" radius={[4, 4, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>

          <div className="section">
            <h3>Ward Comparison</h3>
            <ResponsiveContainer width="100%" height={250}>
              <WardChart data={analytics?.wardSummary || []} />
            </ResponsiveContainer>
          </div>
        </div>

        <div className="grid">
          <div className="section">
            <AreaTable />
          </div>

          <div className="section">
            <FollowupList data={followups} />
          </div>
        </div>

        <div className="section">
          <h3>High Risk Hotspots (By Ward)</h3>
          <div className="hotspots-list" style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', gap: '15px' }}>
            {Object.keys(highRiskFollowupsByWard).length === 0 ? (
              <p>No high-risk hotspot data</p>
            ) : (
              Object.entries(highRiskFollowupsByWard).map(([ward, items]) => (
                <div key={ward} className="hotspot-item" style={{ flexDirection: 'column', alignItems: 'flex-start', background: '#ffebee', padding: '15px', borderRadius: '8px', borderLeft: '4px solid #d32f2f' }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', width: '100%', marginBottom: '10px' }}>
                    <span className="hotspot-name" style={{ fontSize: '16px' }}>{ward}</span>
                    <span className="hotspot-val" style={{ background: '#d32f2f' }}>{items.length} Followups</span>
                  </div>
                  <ul style={{ margin: 0, paddingLeft: '20px', color: '#555', fontSize: '14px', width: '100%' }}>
                    {items.map((f, i) => (
                      <li key={i} style={{ marginBottom: '5px' }}>{f.name} <small>({f.date ? new Date(f.date).toLocaleDateString() : 'N/A'})</small></li>
                    ))}
                  </ul>
                </div>
              ))
            )}
          </div>
        </div>
      </div>
    </div>
  );
}

export default Dashboard;