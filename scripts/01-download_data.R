#### Preamble ####
# Purpose: Downloads and saves demographic data related to food security from the City of Toronto Open Data portal.
# Author: Uma Sadhwani
# Date: 24 September 2024
# Contact: uma.sadhwani@mail.utoronto.ca
# License: MIT
# Pre-requisites: opendatatoronto, readr, and dplyr packages installed.
# Any other information needed? This script downloads the latest available data on food security, as part of a series of analyses on household characteristics and food insecurity in Toronto.

#### Workspace setup ####
library(tidyverse)

library(opendatatoronto)
library(dplyr)

# get package
package <- show_package("52182614-1f0b-42be-aca4-3f86dc8e004c")
package

raw_data <- read_csv("/home/rstudio/cost of living toronto/starter_folder/cost-of-living-in-toronto/data/raw_data/raw_data.csv") 

#### Filter data for specific scenarios and categories ####
selected_scenarios <- c("Scenario 2: Family of Four, Full-Time Minimum Wage Earner",
                        "Scenario 3: Family of Four, Median Income",
                        "Scenario 4: Single Parent Household with 2 Children, Ontario Works",
                        "Scenario 5: One person Household, Ontario Works")

selected_categories <- c("Income", "Selected Expenses", "Other")

selected_items <- c("Total", "Funds Remaining", "Percentage of income required for rent", 
                    "Percentage of income required to purchase healthy food")

# Subset the data based on the selected scenarios, categories, and items
filtered_data <- raw_data %>%
  filter(Scenario %in% selected_scenarios, Category %in% selected_categories, Item %in% selected_items)

#### Save the filtered data ####
write_csv(filtered_data, "/home/rstudio/cost of living toronto/starter_folder/cost-of-living-in-toronto/data/analysis_data/analysis_data.csv")

print("Filtered data download and save complete.")
