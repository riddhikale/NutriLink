import { useEffect, useState } from "react";
import { getAreaSummary } from "../services/api";

function AreaTable() {
  const [data, setData] = useState({});

  useEffect(() => {
    getAreaSummary().then(setData);
  }, []);

  return (
    <div className="box">
      <h3>Area Summary</h3>

      {Object.entries(data).map(([area, val]) => (
        <div key={area}>
          <strong>{area}</strong><br />
          High: {val.high} | Medium: {val.medium} | Low: {val.low}
        </div>
      ))}
    </div>
  );
}

export default AreaTable;