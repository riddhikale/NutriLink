function getMuacRisk(ageMonths, muac) {
    const ageYears = ageMonths / 12;

    // 6–59 months
    if (ageMonths >= 6 && ageMonths <= 59) {
        if (muac < 11) return "high";
        else if (muac < 13) return "medium";
        else return "low";
    }

    // 5–9 years
    if (ageYears >= 5 && ageYears <= 9) {
        if (muac < 13.5) return "high";
        else if (muac < 14.5) return "medium";
        else return "low";
    }

    // 10–14 years
    if (ageYears >= 10 && ageYears <= 14) {
        if (muac < 16) return "high";
        else if (muac < 18) return "medium";
        else return "low";
    }

    return "low";
}


function calculateChildRisk(data) {
    let risks = [];

    risks.push(getMuacRisk(data.ageMonths, data.muac));

    if (data.ageMonths <= 24) {
        if (data.weight < 6) risks.push("high");
        else if (data.weight < 8) risks.push("medium");
        else risks.push("low");
    } else {
        if (data.weight < 8) risks.push("high");
        else if (data.weight < 10) risks.push("medium");
        else risks.push("low");
    }

    if (data.ageMonths <= 24) {
        if (data.height < 70) risks.push("high");
        else if (data.height < 80) risks.push("medium");
        else risks.push("low");
    } else {
        if (data.height < 80) risks.push("high");
        else if (data.height < 90) risks.push("medium");
        else risks.push("low");
    }

    if (risks.includes("high")) return { level: "high" };
    if (risks.includes("medium")) return { level: "medium" };

    return { level: "low" };
}

function calculateWomenRisk(data) {
    let risks = [];

    if (data.hemoglobin < 7) risks.push("high");
    else if (data.hemoglobin < 10) risks.push("medium");
    else risks.push("low");

    if (data.systolicBP > 140 || data.diastolicBP > 90) {
        risks.push("high");
    } else if (data.systolicBP > 130 || data.diastolicBP > 85) {
        risks.push("medium");
    } else {
        risks.push("low");
    }

    if (data.weight < 45) risks.push("high");
    else if (data.weight < 50) risks.push("medium");
    else risks.push("low");

    if (risks.includes("high")) return { level: "high" };
    if (risks.includes("medium")) return { level: "medium" };

    return { level: "low" };
}

module.exports = {
    calculateChildRisk,
    calculateWomenRisk
};