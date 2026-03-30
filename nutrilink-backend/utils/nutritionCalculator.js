function getChildNutrition(data) {

  if (data.muac < 11.5) return "energy_dense";
  if (data.weakness) return "iron_rich";
  if (data.frequentIllness) return "immunity_boost";
  if (data.lowAppetite) return "light_meals";
  return "balanced";
}

function getWomenNutrition(data) {

  if (data.hemoglobin < 10) return "iron_rich";
  if (data.fatigue) return "protein_rich";
  if (data.swelling) return "low_sodium";
  return "balanced";
}

module.exports = {
  getChildNutrition,
  getWomenNutrition
};