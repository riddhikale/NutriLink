const express = require("express");
const router = express.Router();

const { createBeneficiary } = require("../controllers/beneficiaryController");

router.post("/beneficiary", createBeneficiary);

module.exports = router