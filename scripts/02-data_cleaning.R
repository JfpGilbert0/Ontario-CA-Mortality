#### Preamble ####
# Purpose: Clean the names and select columns of interest from the raw data.
# Author: Jacob Gilbert and Liam Wall
# Date: 2024-03-15
# Contact: liam.wall@mail.utoronto.ca, jacob.gilbert@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(dplyr)

#### Clean data ####
raw_data <- read_parquet("data/raw_data/raw_mortality_data.parquet")
head(cleaned_data)

cleaned_data <-
  raw_data |>
  janitor::clean_names() %>%
  rename("year" = ref_date,
         "cause" = leading_causes_of_death_icd_10,
         "age" = age_at_time_of_death) %>%
  mutate(value = ifelse(is.na(value), 0, value))

colnames(cleaned_data)
filtered_data <- cleaned_data %>%
  filter(age == "Age at time of death, all ages" &
         characteristics == "Number of deaths" &
         sex == "Both sexes" &
         uom == "Number")

# Total mortaliies per year
total_only <- filtered_data |>
  select(year, cause, value) %>%
  filter(cause == "Total, all causes of death [A00-Y89]") %>%
  select(-cause) %>%
  rename("total_deaths" = value)

# Seperating by cause of death
by_cause <- filtered_data |>
  select(year, cause, value) %>%
  filter(cause != "Total, all causes of death [A00-Y89]") 

# Restricts to only top 10 causes
by_cause <- by_cause %>%
  group_by(year) %>%
  mutate(year_rank = rank(-value)) %>%
  filter(year_rank <= 10)

# Add column for total deaths grouped by year
joint_data <- 
  left_join(by_cause, total_only, by = "year", relationship = "many-to-many")

#### Save data ####
# write_csv(x = cleaned_data, file = "data/analysis_data/cleaned_data.csv")

# write_csv(x = joint_data, file = "data/analysis_data/joint_data.csv")
