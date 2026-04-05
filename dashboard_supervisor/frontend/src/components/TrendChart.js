import { AreaChart, Area, XAxis, YAxis, Tooltip, CartesianGrid } from "recharts";

function TrendChart({ data }) {
  const chartData = data || [];

  return (
    <AreaChart width={600} height={250} data={chartData} margin={{ top: 10, right: 30, left: 0, bottom: 0 }}>
      <defs>
        <linearGradient id="colorHigh" x1="0" y1="0" x2="0" y2="1">
          <stop offset="5%" stopColor="#ef5350" stopOpacity={0.8}/>
          <stop offset="95%" stopColor="#ef5350" stopOpacity={0}/>
        </linearGradient>
      </defs>
      <XAxis dataKey="month" axisLine={false} tickLine={false} tick={{fill: '#888'}} />
      <YAxis axisLine={false} tickLine={false} tick={{fill: '#888'}} />
      <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#eee" />
      <Tooltip contentStyle={{ borderRadius: '8px', border: 'none', boxShadow: '0 4px 15px rgba(0,0,0,0.1)' }} />
      <Area type="monotone" dataKey="highRiskCases" stroke="#ef5350" fillOpacity={1} fill="url(#colorHigh)" />
    </AreaChart>
  );
}

export default TrendChart;