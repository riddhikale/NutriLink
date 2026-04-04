import { MapContainer, TileLayer, CircleMarker } from "react-leaflet";
import { useEffect, useState } from "react";
import { getHeatmap } from "../services/api";
import "leaflet/dist/leaflet.css";

function Heatmap() {
  const [data, setData] = useState([]);

  useEffect(() => {
    getHeatmap().then(setData);
  }, []);

  return (
    <MapContainer center={[19, 72]} zoom={11} style={{ height: "300px" }}>
      <TileLayer url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png" />

      {data.map((d, i) => (
        <CircleMarker key={i} center={[d.lat, d.lng]} radius={d.riskScore * 5} />
      ))}
    </MapContainer>
  );
}

export default Heatmap;