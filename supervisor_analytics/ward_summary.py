#calculates ward wise risk counts for bar chart and tables

import pandas as pd

def ward_summary(data):

    df = pd.DataFrame(data)

    # Group by ward and risk level
    summary = (
        df.groupby("wardNo")["riskTag"]
        .value_counts()
        .unstack(fill_value=0)
        .reset_index()
    )

    # Convert to JSON format
    return summary.to_dict(orient="records")

#TESTING
if __name__ == "__main__":

    sample_data = [
        {"wardNo":1,"riskTag":"High"},
        {"wardNo":1,"riskTag":"Medium"},
        {"wardNo":1,"riskTag":"High"},
        {"wardNo":2,"riskTag":"Low"},
        {"wardNo":2,"riskTag":"Medium"},
        {"wardNo":3,"riskTag":"High"}
    ]

    print(ward_summary(sample_data))