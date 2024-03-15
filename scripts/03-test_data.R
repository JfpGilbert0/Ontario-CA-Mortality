#### Preamble ####
# Purpose: Tests many aspects of the final cleaned data sets.
# Author: Jacob Gilbert and Liam Wall
# Date: 2024-03-15
# Contact: liam.wall@mail.utoronto.ca, jacob.gilbert@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
library(testthat)
library(rstanarm)

#### Test data ####

test_that("Testing 'year' column values", {
  expect_true("year" %in% names(joint_data), "Data should have a 'year' column")
  
  expect_true(all(joint_data$year >= 2000 & joint_data$year <= 2022),
              "Values in 'year' column should be within the range 2000 through 2022")
})

test_that("Testing 'year_rank' has only values 1-10.", {
  expect_true("year_rank" %in% names(joint_data), "Data should have a 'year_rank' column")
  
  
})


# Test 1: Validate 'year' column
assert_that(all(is.numeric(joint_data$year)))
assert_that(all(joint_data$year >= 2000))
assert_that(all(joint_data$year <= 2022))

# Test 2: Validate 'cause' column format
assert_that(all(sapply(joint_data$cause, is.character)))

# Test 3: Validate 'value' column
assert_that(all(is.numeric(joint_data$value)))
assert_that(all(joint_data$value >= 0))

# Test 4: Validate 'year_rank' column
assert_that(all(is.integer(df$year_rank)))
assert_that(all(df$year_rank >= 1))
df %>%
  group_by(year) %>%
  summarise(max_rank = max(year_rank)) %>%
  assert_that(all(max_rank <= 10)) # replace 10 with the actual max rank

# Test 5: Validate 'total_deaths' column
assert_that(all(is.numeric(df$total_deaths)))
df %>%
  group_by(year) %>%
  summarise(unique_total_deaths = n_distinct(total_deaths)) %>%
  assert_that(all(unique_total_deaths == 1))

# Test 6: Check for duplicates
assert_that(nrow(df) == nrow(df %>%
                               distinct(year, cause, .keep_all = TRUE)))

# If all assertions pass, it will continue, otherwise, it will throw an error
print("All tests passed.")
