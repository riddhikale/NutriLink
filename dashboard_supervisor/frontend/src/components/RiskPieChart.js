import { PieChart, Pie, Cell, Tooltip } from "recharts";

const COLORS = ["#ff4d4f", "#faad14", "#52c41a"];

function RiskPieChart({ data }) {
  return (
    <PieChart width={300} height={300}>
      <Pie data={data} dataKey="count" nameKey="riskLevel">
        {data.map((_, i) => (
          <Cell key={i} fill={COLORS[i]} />
        ))}
      </Pie>
      <Tooltip />
    </PieChart>
  );
}

export default RiskPieChart;