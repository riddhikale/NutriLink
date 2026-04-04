import { useEffect, useState } from "react";
import { getSummary, getTrends } from "../services/api";
import DashboardCard from "../components/DashboardCard";
import TrendChart from "../components/TrendChart";
import AreaTable from "../components/AreaTable";
import FollowupList from "../components/FollowupList";
import Heatmap from "../components/Heatmap";
import "../styles/dashboard.css";

function Dashboard() {
  const [summary, setSummary] = useState({});
  const [trend, setTrend] = useState([]);
  const [user, setUser] = useState({});
  const [collapsed, setCollapsed] = useState(false);

  useEffect(() => {
    const token = localStorage.getItem("token");
    const userData = JSON.parse(localStorage.getItem("user"));

    if (!token) {
      window.location.href = "/";
    } else {
      setUser(userData || {});
      loadData();
    }
  }, []);

  async function loadData() {
    const s = await getSummary();
    const t = await getTrends();
    setSummary(s);
    setTrend(t);
  }

  function logout() {
    localStorage.clear();
    window.location.href = "/";
  }

  return (
    <div className="layout">

      {/* SIDEBAR */}
      <div className={`sidebar ${collapsed ? "collapsed" : ""}`}>

        {/* COLLAPSE BUTTON */}
        <button 
          className="collapse-btn"
          onClick={() => setCollapsed(!collapsed)}
        >
          ☰
        </button>

        {/* TITLE */}
        <h2>NutriLink</h2>
        <p>Supervisor Panel</p>

        {/* PROFILE (BOTTOM) */}
        <div className="profile-box">
          <h4>{user?.name || "Supervisor"}</h4>
          <p>{user?.role || "SUPERVISOR"}</p>
        </div>

      </div>

      {/* MAIN */}
      <div className={`main ${collapsed ? "expanded" : ""}`}>

        {/* HEADER */}
        <div className="header">
          <h2>Dashboard</h2>

          <div className="profile">
            <span>{user?.name || "Supervisor"}</span>
            <button onClick={logout}>Logout</button>
          </div>
        </div>

        {/* CARDS */}
        <div className="cards">
          <DashboardCard title="Total" value={summary.total} />
          <DashboardCard title="High Risk" value={summary.high} type="high" />
          <DashboardCard title="Medium Risk" value={summary.medium} type="medium" />
          <DashboardCard title="Low Risk" value={summary.low} type="low" />
        </div>

        {/* TREND */}
        <div className="section">
          <h3>Trend Analysis</h3>
          <TrendChart data={trend} />
        </div>

        {/* GRID */}
        <div className="grid">
          <AreaTable />
          <FollowupList />
        </div>

        {/* HEATMAP */}
        <div className="section">
          <h3>Risk Heatmap</h3>
          <Heatmap />
        </div>

      </div>
    </div>
  );
}

export default Dashboard;