import { BarChart, Bar, XAxis, YAxis, Tooltip, Legend } from "recharts";

function WardChart({ data }) {
  return (
    <BarChart width={500} height={300} data={data}>
      <XAxis dataKey="wardNo" />
      <YAxis />
      <Tooltip />
      <Legend />
      <Bar dataKey="high" fill="#ef5350" />
      <Bar dataKey="medium" fill="#ffa726" />
      <Bar dataKey="low" fill="#66bb6a" />
    </BarChart>
  );
}

export default WardChart;