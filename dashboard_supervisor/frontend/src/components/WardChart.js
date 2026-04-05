import { BarChart, Bar, XAxis, YAxis, Tooltip } from "recharts";

function WardChart({ data }) {
  return (
    <BarChart width={400} height={300} data={data}>
      <XAxis dataKey="ward" />
      <YAxis />
      <Tooltip />
      <Bar dataKey="high" fill="#d32f2f" />
      <Bar dataKey="medium" fill="#f9a825" />
      <Bar dataKey="low" fill="#388e3c" />
    </BarChart>
  );
}

export default WardChart;