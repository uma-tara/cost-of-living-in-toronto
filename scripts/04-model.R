#### Preamble ####
# Purpose: Models the relationship between household characteristics (such as income and expenses) and key outcomes (such as percentage of income spent on rent or food).
# Author: Uma Sadhwani
# Date: 26 September 2024
# Contact: uma.sadhwani@mail.utoronto.ca
# License: MIT
# Pre-requisites: The cleaned and filtered data from previous steps must be available, and the tidyverse and rstanarm packages must be installed.
# Any other information needed? This is part of a larger project that analyzes food insecurity based on household characteristics.

#### Workspace setup ####
library(tidyverse)
library(rstanarm)

#### Read data ####
analysis_data <- read_csv("/home/rstudio/cost of living toronto/starter_folder/cost-of-living-in-toronto/data/analysis_data/analysis_data.csv")

# Print structure of data to understand types
print("Structure of analysis_data:")
str(analysis_data)

# Convert relevant scenario columns from character (currency) to numeric
scenario_cols <- grep("scenario", names(analysis_data), value = TRUE)

for (col in scenario_cols) {
  # Remove dollar signs and convert to numeric, handling potential non-numeric values
  analysis_data[[col]] <- as.numeric(gsub("\\$", "", analysis_data[[col]]))
  
  # Check for NAs introduced during conversion
  if (any(is.na(analysis_data[[col]]))) {
    warning(paste("Some values in column", col, "could not be converted to numeric and were set to NA."))
  }
}

# Check the structure again after conversion
print("Structure of analysis_data after conversion:")
str(analysis_data)

### Model data ####
# Adjust the formula based on your available variables (example: income as predictor, percentage of rent as outcome)
first_model <-
  stan_glm(
    formula = scenario_1_family_of_four_ontario_works ~ category + item,  # Replace with appropriate outcome variable
    data = analysis_data,
    family = gaussian(),  # Assuming you're modeling a continuous outcome like percentage of income or expenses
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_aux = exponential(rate = 1, autoscale = TRUE),
    seed = 853
  )

#### Save model ####
saveRDS(
  first_model,
  file = "/home/rstudio/cost of living toronto/starter_folder/cost-of-living-in-toronto/models/first_model.rds"
)

print("Modeling completed and model saved.")
