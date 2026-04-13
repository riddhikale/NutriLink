function getMuacRisk(ageMonths, muac) {
    const ageYears = ageMonths / 12;

    if (ageMonths >= 6 && ageMonths <= 59) {
        if (muac < 11) return "high";
        else if (muac < 13) return "medium";
        else return "low";
    }
    if (ageYears >= 5 && ageYears <= 9) {
        if (muac < 13.5) return "high";
        else if (muac < 14.5) return "medium";
        else return "low";
    }
    if (ageYears >= 10 && ageYears <= 14) {
        if (muac < 16) return "high";
        else if (muac < 18) return "medium";
        else return "low";
    }
    return "low";
}

function riskScore(level) {
    if (level === "high")   return 3;
    if (level === "medium") return 2;
    return 1;
}

function scoreToRisk(score) {
    if (score >= 2.5) return "high";
    if (score >= 1.5) return "medium";
    return "low";
}

function calculateChildRisk(data) {
    const scores = [];

    scores.push({ score: riskScore(getMuacRisk(data.ageMonths, data.muac)), weight: 2 });

    let weightRisk;
    if (data.ageMonths <= 24) {
        if (data.weight < 6)       weightRisk = "high";
        else if (data.weight < 8)  weightRisk = "medium";
        else                       weightRisk = "low";
    } else {
        if (data.weight < 8)       weightRisk = "high";
        else if (data.weight < 10) weightRisk = "medium";
        else                       weightRisk = "low";
    }
    scores.push({ score: riskScore(weightRisk), weight: 2 });

    let heightRisk;
    if (data.ageMonths <= 24) {
        if (data.height < 70)      heightRisk = "high";
        else if (data.height < 80) heightRisk = "medium";
        else                       heightRisk = "low";
    } else {
        if (data.height < 80)      heightRisk = "high";
        else if (data.height < 90) heightRisk = "medium";
        else                       heightRisk = "low";
    }
    scores.push({ score: riskScore(heightRisk), weight: 2 });

    const symptomCount = [
        data.weakness,
        data.lowAppetite,
        data.frequentIllness,
        data.diarrhea,
    ].filter(Boolean).length;

    if (symptomCount >= 3)      scores.push({ score: riskScore("high"),   weight: 1 });
    else if (symptomCount >= 1) scores.push({ score: riskScore("medium"), weight: 1 });
    else                        scores.push({ score: riskScore("low"),    weight: 1 });

    const totalWeight = scores.reduce((sum, s) => sum + s.weight, 0);
    const weightedSum  = scores.reduce((sum, s) => sum + s.score * s.weight, 0);
    const avg = weightedSum / totalWeight;

    return {
        level: scoreToRisk(avg),
        detail: {
            muac:        getMuacRisk(data.ageMonths, data.muac),
            weight:      weightRisk,
            height:      heightRisk,
            symptomCount,
        }
    };
}

function calculateWomenRisk(data) {
    const scores = [];

    let hbRisk;
    if (data.hemoglobin < 7)       hbRisk = "high";
    else if (data.hemoglobin < 10) hbRisk = "medium";
    else                           hbRisk = "low";
    scores.push({ score: riskScore(hbRisk), weight: 2 });

    let bpRisk;
    if (data.systolicBP > 140 || data.diastolicBP > 90)       bpRisk = "high";
    else if (data.systolicBP > 130 || data.diastolicBP > 85)  bpRisk = "medium";
    else                                                        bpRisk = "low";
    scores.push({ score: riskScore(bpRisk), weight: 2 });

    let weightRisk;
    if (data.weight < 45)      weightRisk = "high";
    else if (data.weight < 50) weightRisk = "medium";
    else                       weightRisk = "low";
    scores.push({ score: riskScore(weightRisk), weight: 2 });

    const symptomCount = [
        data.dizziness,
        data.fatigue,
        data.swelling,
        data.lowAppetite,
        data.pastAnemia,
    ].filter(Boolean).length;

    if (symptomCount >= 3)      scores.push({ score: riskScore("high"),   weight: 1 });
    else if (symptomCount >= 1) scores.push({ score: riskScore("medium"), weight: 1 });
    else                        scores.push({ score: riskScore("low"),    weight: 1 });

    const totalWeight = scores.reduce((sum, s) => sum + s.weight, 0);
    const weightedSum  = scores.reduce((sum, s) => sum + s.score * s.weight, 0);
    const avg = weightedSum / totalWeight;

    return {
        level: scoreToRisk(avg),
        detail: {
            hemoglobin:  hbRisk,
            bloodPressure: bpRisk,
            weight:      weightRisk,
            symptomCount,
        }
    };
}

module.exports = {
    calculateChildRisk,
    calculateWomenRisk
};