#Find top high-risk wards

import pandas as pd

def hotspot_detection(data):

    df = pd.DataFrame(data)

    if "riskTag" not in df.columns or "wardNo" not in df.columns:
        return []

    # Filter only high risk cases (case insensitive)
    high_risk = df[df["riskTag"].astype(str).str.lower() == "high"]

    # Count high risk cases per ward
    hotspots = (
        high_risk.groupby("wardNo")
        .size()
        .reset_index(name="highRiskCases")
        .sort_values(by="highRiskCases", ascending=False)
    )

    return hotspots.to_dict(orient="records")