async function syncScreening(req, res){
  const data = req.body;

  console.log("Received screenings:", data);

  res.json({
    message: "Sync endpoint working (mock)",
    receivedCount: data.length
  });
};

module.exports = { syncScreening }