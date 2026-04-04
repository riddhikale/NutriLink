// const BASE_URL = process.env.REACT_APP_API_BASE;

// async function fetchData(endpoint){
//   try {
//     const token = localStorage.getItem("token");

//     const res = await fetch(`${BASE_URL}${endpoint}`, {
//         headers: {
//         Authorization: `Bearer ${token}`,
//         },
//     });

//     if (!res.ok) throw new Error("API error");

//     return res.json();
//   } catch (error) { 
//     console.error("Fetch error:", error);
//     return []; 
//   }
// };

// export const getSummary = () => fetchData("/summary");
// export const getAreaSummary = () => fetchData("/area-summary");
// export const getFollowups = () => fetchData("/followups-due");
// export const getHeatmap = () => fetchData("/risk-heatmap");
// export const getTrends = () => fetchData("/trend-analysis");

const BASE_URL = process.env.REACT_APP_API_BASE;

function getToken() {
  return localStorage.getItem("token");
}

async function request(endpoint) {
  const res = await fetch(`${BASE_URL}${endpoint}`, {
    headers: {
      Authorization: `Bearer ${getToken()}`,
    },
  });

  return res.json();
}

export const getSummary = () => request("/summary");
export const getAreaSummary = () => request("/area-summary");
export const getFollowups = () => request("/followups-due");
export const getHeatmap = () => request("/risk-heatmap");
export const getTrends = () => request("/trend-analysis");
