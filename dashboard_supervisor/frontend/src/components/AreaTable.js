import { useEffect, useState } from "react";
import { getAreaSummary } from "../services/api";

function AreaTable() {
  const [data, setData] = useState({});

  useEffect(() => {
    getAreaSummary().then(res => {
      if(res) setData(res);
    });
  }, []);

  return (
    <>
      <h3>Area Summary</h3>
      <div className="area-list" style={{ marginTop: '15px' }}>
        {Object.entries(data).length === 0 && <p style={{ color: '#888' }}>No area data...</p>}
        {Object.entries(data).map(([area, val]) => (
          <div key={area} style={{ padding: "12px 15px", borderBottom: "1px solid #eee", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
            <strong style={{ color: "#333" }}>{area}</strong>
            <span style={{ fontSize: "14px", color: "#666" }}>
              <span style={{ color: "#ef5350", fontWeight: "bold" }}>{val.high} High</span> | 
              <span style={{ color: "#ffa726", fontWeight: "bold", marginLeft: "5px" }}>{val.medium} Med</span> | 
              <span style={{ color: "#66bb6a", fontWeight: "bold", marginLeft: "5px" }}>{val.low} Low</span>
            </span>
          </div>
        ))}
      </div>
    </>
  );
}

export default AreaTable;