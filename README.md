# Patient Survival Analysis Data Preprocessing

This repository contains an R script for analyzing patient survival data. The goal of the script is to explore, clean, and visualize the dataset for any insights.

## Libraries Used

- `stringr`: For string manipulations.
- `data.table`: Data manipulation operations.
- `dplyr`: Data wrangling and transformation.
- `ggplot2`: Visualization.
- `reshape2`: Data reshaping.
- `plotly`: Interactive visualizations.
- `hrbrthemes`: Additional themes for ggplot2.
- `tidyverse`: Suite of packages for data science.
- `heatmaply`: Generation of interactive heatmaps.
- `factoextra`: Extraction and visualization of the results of multivariate data analyses.

## Dataset Overview

The dataset "Patient Survival.csv" contains information about various patients. The primary analysis is focused on:

- Understanding the data structure
- Cleaning the data (handling missing values and irrelevant columns)
- Grouping and summarizing data
- Visualization to gain insights into patient deaths by age and gender
- Diagnosis results of the patients
- Correlation heatmap of numeric features
- Applying Principal Component Analysis (PCA) for dimensionality reduction

## Script Description

Here's a breakdown of the key sections in the script:

1. **Data Loading**: The data is loaded using the `read.csv` function. After loading, the structure of the data is visualized using the `str()` function.

2. **Data Cleaning**: This section is focused on:
   - Identifying and handling missing values.
   - Removing irrelevant columns.
   - Converting character columns to factors.
   - Replacing missing values with appropriate imputations.

3. **Data Visualization**: Multiple plots are generated using `ggplot2` to visualize:
   - Deaths by age and its distribution based on gender.
   - Patient diagnosis results based on different body system classifications.
   - Correlation heatmaps of numeric features.
   
4. **PCA Analysis**: The PCA technique is applied to numeric features in the dataset to reduce its dimensions. The Scree plot helps in identifying the significant principal components.

## Execution

To execute the script, make sure you have the necessary libraries installed. You can install these libraries using the `install.packages()` function in R. Once installed, source the script in R and it will process the dataset and generate the visualizations.

## Future Work

Further analysis can be done on this dataset by:
- Implementing machine learning models to predict patient survival based on features.
- Diving deeper into patient diagnosis results to understand patterns.
- Segmenting patients based on their medical history or demographics for targeted analysis.

## Contributing

If you have any suggestions or find any bugs, please feel free to create an issue or a pull request.

Made with ❤️ in R.
