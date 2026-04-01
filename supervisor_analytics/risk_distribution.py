#calculates risk (hig/medium/low) for pie charts

import pandas as pd

def risk_distribution(data):

    # Convert input data into dataframe
    df = pd.DataFrame(data)

    # Count each risk category
    distribution = (
        df["riskTag"]
        .value_counts()
        .reset_index()
    )

    # Rename columns
    distribution.columns = ["riskLevel", "count"]

    # Convert result back to JSON format
    return distribution.to_dict(orient="records")

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