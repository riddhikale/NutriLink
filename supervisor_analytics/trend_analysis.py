#tracks risk cases over time used for line charts

import pandas as pd
def monthly_trend(data):

    df = pd.DataFrame(data)

    if "screeningDate" not in df.columns or "riskTag" not in df.columns:
        return []

    # Convert screeningDate to datetime
    df["screeningDate"] = pd.to_datetime(df["screeningDate"], errors='coerce')
    df["screeningDate"] = df["screeningDate"].dt.tz_localize(None)

    # Extract month
    df["month"] = df["screeningDate"].dt.to_period("M")


    trend = (
        df.groupby("month")["riskTag"]
        .apply(lambda x: (x.astype(str).str.lower() == "high").sum())
        .reset_index(name="highRiskCases")
    )

    trend["month"] = trend["month"].astype(str)

    return trend.to_dict(orient="records")