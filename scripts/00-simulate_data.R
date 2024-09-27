#### Preamble ####
# Purpose: Simulates household income and expenses data for various scenarios related to food insecurity.
# Author: Uma Sadhwani
# Date: 24 September 2024
# Contact: uma.sadhwani@mail.utoronto.ca
# License: MIT
# Pre-requisites: Knowledge of income and expense categories for different household scenarios related to food insecurity.
# Any other information needed? This is the first step in a series of scripts that will analyze the impact of household characteristics on food insecurity.

library(tidyverse)
library(testthat)

# Function to simulate data
simulate_data <- function() {
  scenarios <- c(
    "scenario_2_family_of_four_full_time_minimum_wage_earner",
    "scenario_3_family_of_four_median_income",
    "scenario_4_single_parent_household_with_2_children_ontario_works",
    "scenario_5_one_person_household_ontario_works"
  )
  
  categories <- c("Income", "Selected Expenses", "Other")
  
  items <- c(
    "Total", 
    "Funds Remaining",
    "Percentage of income required for rent",
    "Percentage of income required to purchase healthy food"
  )
  
  simulated_data <- expand_grid(Category = categories, Item = items, Scenario = scenarios) %>%
    mutate(Value = case_when(
      Category == "Income" & Item == "Total" ~ runif(nrow(.), 2000, 10000),
      Category == "Selected Expenses" & Item == "Total" ~ runif(nrow(.), 2000, 8000),
      Category == "Other" & Item == "Funds Remaining" ~ runif(nrow(.), -4000, 2000),
      Category == "Other" & Item == "Percentage of income required for rent" ~ runif(nrow(.), 40, 250),
      Category == "Other" & Item == "Percentage of income required to purchase healthy food" ~ runif(nrow(.), 10, 50),
      TRUE ~ NA_real_
    )) %>%
    filter(!is.na(Value)) %>%
    arrange(Scenario, Category, Item)
  
  return(simulated_data)
}

set.seed(123)  # for reproducibility
simulated_data <- simulate_data()

write.csv(simulated_data, "data/simulated_data.csv", row.names = FALSE)

test_that("Simulated data has correct structure", {
  expect_equal(ncol(simulated_data), 4)
  expect_true(all(c("Category", "Item", "Scenario", "Value") %in% names(simulated_data)))
})

test_that("Simulated data contains expected scenarios", {
  expected_scenarios <- c(
    "scenario_2_family_of_four_full_time_minimum_wage_earner",
    "scenario_3_family_of_four_median_income",
    "scenario_4_single_parent_household_with_2_children_ontario_works",
    "scenario_5_one_person_household_ontario_works"
  )
  expect_true(all(expected_scenarios %in% unique(simulated_data$Scenario)))
})

test_that("Simulated data values are within expected ranges", {
  expect_true(all(simulated_data$Value[simulated_data$Category == "Income" & simulated_data$Item == "Total"] >= 2000 & 
                    simulated_data$Value[simulated_data$Category == "Income" & simulated_data$Item == "Total"] <= 10000))
  expect_true(all(simulated_data$Value[simulated_data$Category == "Selected Expenses" & simulated_data$Item == "Total"] >= 2000 & 
                    simulated_data$Value[simulated_data$Category == "Selected Expenses" & simulated_data$Item == "Total"] <= 8000))
  expect_true(all(simulated_data$Value[simulated_data$Category == "Other" & simulated_data$Item == "Funds Remaining"] >= -4000 & 
                    simulated_data$Value[simulated_data$Category == "Other" & simulated_data$Item == "Funds Remaining"] <= 2000))
  expect_true(all(simulated_data$Value[simulated_data$Category == "Other" & simulated_data$Item == "Percentage of income required for rent"] >= 40 & 
                    simulated_data$Value[simulated_data$Category == "Other" & simulated_data$Item == "Percentage of income required for rent"] <= 250))
  expect_true(all(simulated_data$Value[simulated_data$Category == "Other" & simulated_data$Item == "Percentage of income required to purchase healthy food"] >= 10 & 
                    simulated_data$Value[simulated_data$Category == "Other" & simulated_data$Item == "Percentage of income required to purchase healthy food"] <= 50))
})

print("Simulation and tests completed successfully.")

