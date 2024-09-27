#### Preamble ####
# Purpose: Tests the cleaned and filtered data related to food insecurity in Toronto to ensure accuracy, completeness, and validity of transformations performed in the previous data cleaning steps.
# Author: Uma Sadhwani
# Date: 26 September 2024
# Contact: uma.sadhwani@mail.utoronto.ca
# License: MIT
# Pre-requisites: tidyverse and testthat packages installed. The cleaned data CSV file must exist in the specified location.
# Any other information needed? This script is part of a larger project analyzing food insecurity in Toronto. It assumes that the cleaned data has been saved as a CSV file in the previous step.

#### Workspace setup ####
library(tidyverse)
library(testthat)

# Load the cleaned data
analysis_data <- read_csv("/home/rstudio/cost of living toronto/starter_folder/cost-of-living-in-toronto/data/analysis_data/analysis_data.csv")

print("Column names in analysis_data:")
print(names(analysis_data))

#### Test data ####

test_that("Cleaned data loaded successfully", {
  expect_true(exists("analysis_data"), "analysis_data does not exist")
  expect_s3_class(analysis_data, "data.frame", "analysis_data is not a data frame")
})

test_that("Cleaned data has correct structure", {
  expected_columns <- c("category", "item")
  expect_true(all(expected_columns %in% names(analysis_data)), 
              paste("Missing expected columns:", paste(setdiff(expected_columns, names(analysis_data)), collapse = ", ")))
  expect_true(any(grepl("scenario", names(analysis_data))), "No scenario columns found")
})

test_that("No missing values in key columns", {
  key_columns <- c("category", "item")
  for (col in key_columns) {
    expect_false(any(is.na(analysis_data[[col]])), 
                 info = paste("Missing values found in column:", col))
  }
})

test_that("Scenario columns have valid values", {
  scenario_cols <- grep("scenario", names(analysis_data), value = TRUE)
  for (col in scenario_cols) {
    column_data <- analysis_data[[col]]
    print(paste("Column:", col, "Class:", class(column_data), "Sample values:", paste(head(column_data), collapse = ", ")))
    
    # Check if values are either NA, valid currency strings, or percentages
    valid_values <- sapply(column_data, function(x) {
      is.na(x) || 
        grepl("^\\$[0-9]+(\\.[0-9]{2})?$", x) || 
        grepl("^[0-9]+(\\.[0-9]+)?%$", x)
    })
    
    if (!all(valid_values)) {
      invalid_indices <- which(!valid_values)
      invalid_values <- column_data[invalid_indices]
      print(paste("Invalid values in", col, ":", paste(head(invalid_values), collapse = ", ")))
    }
    
    expect_true(all(valid_values), 
                info = paste("Invalid values found in column:", col))
  }
})

test_that("No duplicate rows in the cleaned data", {
  expect_equal(nrow(analysis_data), nrow(distinct(analysis_data)), 
               info = "Duplicate rows found in the data")
})

test_that("Columns have expected data types", {
  expect_type(analysis_data$category, "character", info = "Category column is not character type")
  expect_type(analysis_data$item, "character", info = "Item column is not character type")
  
  scenario_cols <- grep("scenario", names(analysis_data), value = TRUE)
  for (col in scenario_cols) {
    expect_type(analysis_data[[col]], "character", 
                info = paste("Column", col, "is not character type"))
  }
})

test_that("Character columns are in lowercase", {
  char_cols <- c("category", "item")
  for (col in char_cols) {
    expect_true(all(analysis_data[[col]] == tolower(analysis_data[[col]])),
                info = paste("Column", col, "contains uppercase characters"))
  }
})

print("All tests completed.")

# Print a sample of the data
print("Sample of the data:")
print(head(analysis_data))
