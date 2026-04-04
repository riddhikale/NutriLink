import { LineChart, Line, XAxis, YAxis, Tooltip } from "recharts";

function TrendChart({ data }) {
  return (
    <LineChart width={500} height={300} data={data}>
      <XAxis dataKey="month" />
      <YAxis />
      <Tooltip />
      <Line type="monotone" dataKey="highRisk" stroke="#2e7d32" />
    </LineChart>
  );
}

export default TrendChart;