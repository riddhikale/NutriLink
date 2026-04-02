#calculates risk (hig/medium/low) with child and pregnant women comparison used for stacked bar chart

import pandas as pd

import pandas as pd

def risk_distribution(data):

    df = pd.DataFrame(data)

    if "riskTag" not in df.columns:
        return []

    distribution = (
        df["riskTag"]
        .value_counts()
        .reset_index()
    )

    distribution.columns = ["riskLevel","count"]

    return distribution.to_dict(orient="records")


def risk_distribution_by_type(data):

    df = pd.DataFrame(data)

    if "type" not in df.columns or "riskTag" not in df.columns:
        return []

    summary = (
        df.groupby("type")["riskTag"]
        .value_counts()
        .unstack(fill_value=0)
        .reset_index()
    )

    return summary.to_dict(orient="records")



#TESTING
# if __name__ == "__main__":
#
#     sample_data = [
#         {"riskTag":"High"},
#         {"riskTag":"Medium"},
#         {"riskTag":"High"},
#         {"riskTag":"Low"},
#         {"riskTag":"Medium"}
#     ]
#
#     print(risk_distribution(sample_data))