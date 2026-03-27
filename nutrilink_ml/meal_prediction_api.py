from flask import Flask, request, jsonify
import joblib
import numpy as np

app = Flask(__name__)

child_model = joblib.load("child_meal_model.pkl")
preg_model = joblib.load("pregnancy_meal_model.pkl")

#child meal prediction endpoint
@app.route("/predict-child-meal", methods=["POST"])
def predict_child_meal():

    data = request.json

    features = np.array([[
        data["ageMonths"],
        data["weight"],
        data["height"],
        data["muac"],
        data["weakness"],
        data["lowAppetite"],
        data["frequentIllness"],
        data["diarrhea"],
        data["pastRiskScore"],
        data["visitGapDays"],
        data["areaRiskIndex"]
    ]])

    prediction = child_model.predict(features)[0]

    return jsonify({
        "nutritionNeed": prediction
    })

#pregnancy meal prediction endpoint
@app.route("/predict-pregnancy-meal", methods=["POST"])
def predict_pregnancy_meal():

    data = request.json

    features = np.array([[
        data["trimester"],
        data["weight"],
        data["hemoglobin"],
        data["systolicBP"],
        data["diastolicBP"],
        data["dizziness"],
        data["fatigue"],
        data["swelling"],
        data["lowAppetite"],
        data["pastAnemia"],
        data["missedFollowups"],
        data["areaRiskIndex"]
    ]])

    prediction = preg_model.predict(features)[0]

    return jsonify({
        "nutritionNeed": prediction
    })

if __name__ == "__main__":
    app.run(port=5000, debug=True)