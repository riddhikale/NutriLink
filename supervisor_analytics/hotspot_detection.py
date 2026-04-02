#Find top high-risk wards

import pandas as pd

def hotspot_detection(data):

    df = pd.DataFrame(data)

    # Filter only high risk cases
    high_risk = df[df["riskTag"] == "High"]

    # Count high risk cases per ward
    hotspots = (
        high_risk.groupby("wardNo")
        .size()
        .reset_index(name="highRiskCases")
        .sort_values(by="highRiskCases", ascending=False)
    )

    return hotspots.to_dict(orient="records")