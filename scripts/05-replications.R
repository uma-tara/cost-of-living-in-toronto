#### Preamble ####
# Purpose: Replicated graphs from the analysis of food insecurity based on household characteristics and their relationship to key outcomes.
# Author: Uma Sadhwani
# Date: 27 September 2024
# Contact: uma.sadhwani@mail.utoronto.ca
# License: MIT
# Pre-requisites: The cleaned and filtered data from previous steps must be available, and the tidyverse package must be installed.
# Any other information needed? This script is part of a larger project that analyzes food insecurity based on household characteristics.

#### Workspace setup ####
library(tidyverse)
library(ggplot2)  # Load ggplot2 foinstall.packages("ggplot2")


#### Load data ####
# Load the cleaned analysis data
analysis_data <- read_csv("/home/rstudio/cost of living toronto/starter_folder/cost-of-living-in-toronto/data/analysis_data/analysis_data.csv")

# Print the structure of the loaded data to confirm it loaded correctly
print("Structure of analysis_data:")
str(analysis_data)

# Optionally, preview the first few rows of the dataset
print("Preview of analysis_data:")
print(head(analysis_data))


