import requests

url = "http://localhost:5000/predict-child-meal"

data = {
 "ageMonths": 24,
 "weight": 8.5,
 "height": 76,
 "muac": 11.2,
 "weakness": 1,
 "lowAppetite": 0,
 "frequentIllness": 1,
 "diarrhea": 0,
 "pastRiskScore": 1,
 "visitGapDays": 30,
 "areaRiskIndex": 0.5
}

response = requests.post(url, json=data)

print(response.json())