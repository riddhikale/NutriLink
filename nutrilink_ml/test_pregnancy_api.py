import requests

url = "http://localhost:5000/predict-pregnancy-meal"

data = {
 "trimester": 2,
 "weight": 54,
 "hemoglobin": 9.5,
 "systolicBP": 120,
 "diastolicBP": 80,
 "dizziness": 1,
 "fatigue": 1,
 "swelling": 0,
 "lowAppetite": 0,
 "pastAnemia": 1,
 "missedFollowups": 1,
 "areaRiskIndex": 0.6
}

response = requests.post(url, json=data)

print(response.json())