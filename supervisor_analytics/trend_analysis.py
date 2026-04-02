#tracks risk cases over time used for line charts

import pandas as pd
def monthly_trend(data):

    df = pd.DataFrame(data)

    if "screeningDate" not in df.columns:
        return []

    # Convert screeningDate to datetime
    df["screeningDate"] = pd.to_datetime(df["screeningDate"], errors='coerce')
    df["screeningDate"] = df["screeningDate"].dt.tz_localize(None)

    # Extract month
    df["month"] = df["screeningDate"].dt.to_period("M")

    # Count high risk cases per month
    trend = (
        df.groupby("month")["riskTag"]
        .apply(lambda x: (x == "High").sum())
        .reset_index(name="highRiskCases")
    )

    trend["month"] = trend["month"].astype(str)

    return trend.to_dict(orient="records")

#TESTING
# if __name__ == "__main__":
#
#     sample_data = [
#         {"riskTag":"High","screeningDate":"2026-01-10"},
#         {"riskTag":"Medium","screeningDate":"2026-01-15"},
#         {"riskTag":"High","screeningDate":"2026-02-02"},
#         {"riskTag":"Low","screeningDate":"2026-02-10"},
#         {"riskTag":"High","screeningDate":"2026-03-05"}
#     ]
#
#     print(monthly_trend(sample_data))