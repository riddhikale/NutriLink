from risk_distribution import risk_distribution
from ward_summary import ward_summary
from heatmap import heatmap_data
from trend_analysis import monthly_trend


def run_all_analytics(data):

    results = {
        "riskDistribution": risk_distribution(data),
        "wardSummary": ward_summary(data),
        "heatmap": heatmap_data(data),
        "trend": monthly_trend(data)
    }

    return results

#TESTING
# if __name__ == "__main__":
#
#     sample_data = [
#         {"wardNo":1,"riskTag":"High","screeningDate":"2026-01-10"},
#         {"wardNo":1,"riskTag":"Medium","screeningDate":"2026-01-15"},
#         {"wardNo":2,"riskTag":"High","screeningDate":"2026-02-02"},
#         {"wardNo":2,"riskTag":"Low","screeningDate":"2026-02-10"},
#         {"wardNo":3,"riskTag":"High","screeningDate":"2026-03-05"}
#     ]
#
#     print(run_all_analytics(sample_data))