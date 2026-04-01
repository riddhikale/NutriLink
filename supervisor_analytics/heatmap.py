#finds high-risk clusters by ward used for map visualization

import pandas as pd

def heatmap_data(data):

    df = pd.DataFrame(data)

    # Filter only High Risk cases
    high_risk = df[df["riskTag"] == "High"]

    # Count high risk cases per ward
    heatmap = (
        high_risk.groupby("wardNo")
        .size()
        .reset_index(name="highRiskCount")
    )

    # Convert result to JSON format
    return heatmap.to_dict(orient="records")

#TESTING
# if __name__ == "__main__":
#
#     sample_data = [
#         {"wardNo":1,"riskTag":"High"},
#         {"wardNo":1,"riskTag":"Medium"},
#         {"wardNo":1,"riskTag":"High"},
#         {"wardNo":2,"riskTag":"Low"},
#         {"wardNo":3,"riskTag":"High"}
#     ]
#
#     print(heatmap_data(sample_data))