import { useEffect, useState } from "react";
import { getFollowups } from "../services/api";

function FollowupList() {
  const [data, setData] = useState([]);

  useEffect(() => {
    getFollowups().then(setData);
  }, []);

  return (
    <div className="box">
      <h3>Followups</h3>

      {data.map((f, i) => (
        <div key={i} className="follow-item">
          <strong>{f.name}</strong><br />
          Risk: {f.risk}<br />
          Date: {f.date}
        </div>
      ))}
    </div>
  );
}

export default FollowupList;