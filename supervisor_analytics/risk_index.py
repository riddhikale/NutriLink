import pandas as pd

def risk_index(data):

    df = pd.DataFrame(data)

    # Assign risk scores
    risk_scores = {
        "High": 3,
        "Medium": 2,
        "Low": 1
    }

    df["riskScore"] = df["riskTag"].map(risk_scores)

    # Calculate average risk score per ward
    index = (
        df.groupby("wardNo")["riskScore"]
        .mean()
        .reset_index(name="riskIndex")
    )

    # Round values for cleaner dashboard display
    index["riskIndex"] = index["riskIndex"].round(2)

    return index.to_dict(orient="records")