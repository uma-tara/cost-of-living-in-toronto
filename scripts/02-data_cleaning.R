#### Preamble ####
# Purpose: Cleans and filters raw data related to food insecurity in Toronto to ensure accuracy and uniformity for further analysis.
# Author: Uma Sadhwani
# Date: 24 September 2024
# Contact: uma.sadhwani@mail.utoronto.ca
# License: MIT 
# Pre-requisites: tidyverse and janitor packages installed. This script assumes the raw data includes measurements of household incomes and expenses that may require formatting corrections and error checks.
# Any other information needed? This script is part of a larger project analyzing food insecurity, as of 2023, in Toronto.

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(dplyr)

# Load the raw data from the previous section
raw_data <- read_csv("/home/rstudio/cost of living toronto/starter_folder/cost-of-living-in-toronto/data/raw_data/raw_data.csv")
print(names(raw_data))

analysis_data <- raw_data %>%
  remove_empty(c("rows", "cols")) %>%
  clean_names()
print(names(analysis_data))

# Ensure the data loads correctly
print("Raw data loaded successfully")
print(head(raw_data))  # Preview the first few rows

#### Data cleaning ####
# Start the data cleaning process
analysis_data <- raw_data %>%
  # Remove empty rows and columns
  remove_empty(c("rows", "cols")) %>%
  
  # Clean column names (remove special characters, spaces, convert to snake_case)
  clean_names() %>%
  
  # Filter out rows with missing or NA values in critical columns (adjust column names accordingly)
  filter(!is.na(amount), !is.na(category), !is.na(item), !is.na(scenario))


  # Trim whitespace from character fields to ensure consistency
  mutate(across(where(is.character), str_trim)) %>%
  
  # Convert factors to characters before applying `tolower()`
  mutate(across(where(is.factor), as.character)) %>%
  
  # Convert to lowercase
  mutate(across(where(is.character), tolower)) %>%
  
  # Ensure that values in specific columns are of the correct type
  mutate(
    value = as.numeric(value),
    category = as.factor(category),
    item = as.factor(item),
    scenario = as.factor(scenario)
  ) %>%
  
  # Replace any unreasonable values (e.g., negative income, percentages over 100) with NA or appropriate values
  mutate(
    value = case_when(
      category == "income" & value < 0 ~ NA_real_,  # No negative income values
      item == "percentage_of_income_required_for_rent" & value > 100 ~ NA_real_,  # Cap rent percentage at 100
      item == "percentage_of_income_required_to_purchase_healthy_food" & value > 100 ~ NA_real_,  # Cap food percentage at 100
      TRUE ~ value
    )
  )

# Check if the analysis_data was created successfully
print("Analysis data created successfully")
print(head(analysis_data))  # Preview the first few rows

#### Remove duplicates ####
analysis_data <- analysis_data %>%
  distinct()

print("Duplicates removed from analysis_data")
print(head(analysis_data))  # Preview the first few rows after removing duplicates





