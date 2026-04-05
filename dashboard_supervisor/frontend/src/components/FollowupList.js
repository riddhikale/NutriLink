import { useEffect, useState } from "react";
import { getFollowups } from "../services/api";

function FollowupList({ data = [] }) {
  return (
    <>
      <h3>Followups</h3>
      {/* Scrollable list that roughly keeps the first 5 visible (~350px) */}
      <div className="followup-list" style={{ marginTop: '15px', maxHeight: '350px', overflowY: 'auto', paddingRight: '5px' }}>
        {data.length === 0 && <p style={{ color: '#888' }}>No pending followups...</p>}
        {data.map((f, i) => (
          <div key={i} className="follow-item" style={{ 
            padding: "12px 15px", 
            borderLeft: f.risk === "high" ? "4px solid #ef5350" : f.risk === "medium" ? "4px solid #ffa726" : "4px solid #66bb6a", 
            marginBottom: "10px", 
            background: "#f9fcf9",
            borderRadius: "0 8px 8px 0",
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center"
          }}>
            <div>
              <strong style={{ color: "#333", display: "block" }}>{f.name}</strong>
              <small style={{ color: "#888" }}>{f.date ? new Date(f.date).toLocaleDateString() : 'N/A'}</small>
            </div>
            <span style={{
              background: f.risk === "high" ? "#ef5350" : f.risk === "medium" ? "#ffa726" : "#66bb6a",
              color: "white",
              padding: "4px 10px",
              borderRadius: "20px",
              fontSize: "12px",
              fontWeight: "bold",
              textTransform: "capitalize"
            }}>
              {f.risk} Risk
            </span>
          </div>
        ))}
      </div>
    </>
  );
}

export default FollowupList;