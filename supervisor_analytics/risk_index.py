import pandas as pd
import numpy as np

def risk_index(data):

    df = pd.DataFrame(data)

    if "riskTag" not in df.columns:
        return []

    risk_scores = {
        "high": 3,
        "medium": 2,
        "low": 1
    }

    df["riskScore"] = df["riskTag"].str.lower().map(risk_scores)

    index = (
        df.groupby("wardNo")["riskScore"]
        .mean()
        .reset_index(name="riskIndex")
    )

    index["riskIndex"] = index["riskIndex"].fillna(0)

    index["riskIndex"] = index["riskIndex"].round(2)

    return index.to_dict(orient="records")