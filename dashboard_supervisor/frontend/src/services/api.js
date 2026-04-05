const BASE_URL = process.env.REACT_APP_API_BASE;

function getToken() {
  return localStorage.getItem("token");
}

async function request(endpoint, method = "GET", body = null) {
  const options = {
    method,
    headers: {
      Authorization: `Bearer ${getToken()}`,
    },
  };
  if (body) {
    options.headers["Content-Type"] = "application/json";
    options.body = JSON.stringify(body);
  }

  const res = await fetch(`${BASE_URL}${endpoint}`, options);
  if (!res.ok) {
    console.error(`API Error on ${endpoint}:`, res.statusText);
    return null;
  }
  return res.json();
}

export const getSummary = () => request("/summary");
export const getAreaSummary = () => request("/area-summary");
export const getFollowups = () => request("/followups-due");
export const getHeatmap = () => request("/risk-heatmap");
export const getTrends = () => request("/trend-analysis");

export async function getAnalytics() {
  return request("/analytics", "POST");
}
