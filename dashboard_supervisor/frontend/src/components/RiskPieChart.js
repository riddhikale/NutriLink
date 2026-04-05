import { PieChart, Pie, Cell } from "recharts";

function RiskPieChart({ data }){
    return(
      <PieChart width={300} height={300}>
        <Pie data={data} dataKey="count" nameKey="riskLevel" outerRadius={100} />
      </PieChart>
    )
}

export default RiskPieChart;
