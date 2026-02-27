async function createBeneficiary(req, res){
  const data = req.body;

  res.json({
    message: "Beneficiary endpoint working (mock)",
    data
  });
};

module.exports = { createBeneficiary }