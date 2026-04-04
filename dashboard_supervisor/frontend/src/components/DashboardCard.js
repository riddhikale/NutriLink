function DashboardCard({ title, value, type }) {
  return (
    <div className={`card ${type || ""}`}>
      <h4>{title}</h4>
      <p>{value || 0}</p>
    </div>
  );
}

export default DashboardCard;