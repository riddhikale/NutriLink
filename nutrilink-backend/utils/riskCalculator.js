function calculateChildRisk(data) {
    let score = 0;

    if (data.muac < 11.5) score += 5; 
    else if (data.muac < 12.5) score += 3;

    if (data.diarrhea) score += 2;
    if (data.frequentIllness) score += 2;
    if (data.weakness) score += 2;
    if (data.lowAppetite) score += 1;

    if (data.weight < 5) score += 2;

    let level = "low";
    if (score >= 7) level = "high";
    else if (score >= 4) level = "medium";

    return { score, level };
}

function calculateWomenRisk(data) {
    let score = 0;

    if (data.hemoglobin < 7) score += 5;
    else if (data.hemoglobin < 10) score += 3;

    if (data.systolicBP > 140 || data.diastolicBP > 90) score += 3;

    if (data.dizziness) score += 2;
    if (data.fatigue) score += 1;
    if (data.swelling) score += 2;
    if (data.lowAppetite) score += 1;

    if (data.pastAnemia) score += 2;

    let level = "low";
    if (score >= 7) level = "high";
    else if (score >= 4) level = "medium";

    return { score, level };
}

module.exports = {calculateChildRisk, calculateWomenRisk}