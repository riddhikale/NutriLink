#total screenings per ward for bar charts

import pandas as pd

def coverage_analysis(data):

    df = pd.DataFrame(data)

    # Count screenings per ward
    coverage = (
        df.groupby("wardNo")
        .size()
        .reset_index(name="screenings")
    )

    return coverage.to_dict(orient="records")