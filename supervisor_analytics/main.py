import sys
import json
import pandas as pd

from risk_distribution import risk_distribution, risk_distribution_by_type
from ward_summary import ward_summary
from heatmap import heatmap_data
from trend_analysis import monthly_trend
from coverage_analysis import coverage_analysis
from hotspot_detection import hotspot_detection
from risk_index import risk_index


def run_all_analytics(data):

    # Convert incoming JSON to DataFrame
    df = pd.DataFrame(data)

    # If required columns are missing, return empty analytics
    required_columns = ["wardNo", "riskTag", "screeningDate"]

    for col in required_columns:
        if col not in df.columns:
            return {
                "message": f"Missing column: {col}"
            }

    cleaned_data = df.to_dict(orient="records")

    results = {
        "riskDistribution": risk_distribution(cleaned_data),
        "riskDistributionByType": risk_distribution_by_type(cleaned_data),
        "wardSummary": ward_summary(cleaned_data),
        "heatmap": heatmap_data(cleaned_data),
        "trend": monthly_trend(cleaned_data),
        "coverage": coverage_analysis(cleaned_data),
        "hotspots": hotspot_detection(cleaned_data),
        "riskIndex": risk_index(cleaned_data)
    }

    return results


if __name__ == "__main__":

    try:

        input_data = json.loads(sys.stdin.read())

        result = run_all_analytics(input_data)

        print(json.dumps(result))

    except Exception as e:

        print(json.dumps({
            "error": str(e)
        }))