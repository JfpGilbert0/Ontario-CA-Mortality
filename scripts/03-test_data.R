#### Preamble ####
# Purpose: Tests many aspects of the final cleaned data sets.
# Author: Jacob Gilbert and Liam Wall
# Date: 2024-03-15
# Contact: liam.wall@mail.utoronto.ca, jacob.gilbert@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
library(testthat)

#### Test data ####

#1
test_that("Testing 'year' column values", {
  expect_true("year" %in% names(joint_data), "Data should have a 'year' column.")
  
  expect_true(is.numeric(joint_data$year),
              "Values in 'year' column should be numeric.")
  
  expect_true(all(joint_data$year >= 2000 & joint_data$year <= 2022),
              "Values in 'year' column should be within the range 2000 through 2022.")
})

#2
test_that("Testing 'cause' column values", {
  expect_true("cause" %in% names(joint_data), "Data should have a 'cause' column.")
  
  expect_true(is.character(joint_data$cause),
              "Values in 'cause' column should be characters.")
})

#3
test_that("Testing 'value' column values", {
  expect_true("value" %in% names(joint_data), "Data should have a 'value' column.")
  
  expect_true(is.double(joint_data$value),
              "Values in 'value' column should be numeric.")
  
  expect_true(all(joint_data$value >= 0 & joint_data$year <= 100000),
              "Values in 'value' column are expected to be within the range 0 through 100,000.")
})

#4
test_that("Testing 'year_rank' column values", {
  expect_true("year_rank" %in% names(joint_data), "Data should have a 'year_rank' column.")
  
  expect_true(is.double(joint_data$year_rank),
              "Values in 'year_rank' column should be numeric.")
  
  expect_true(all(joint_data$year_rank >= 0 & joint_data$year_rank <= 10),
              "Values in 'year_rank' column are expected to be within the range 1 through 10.")
})

#5
test_that("Testing 'total_deaths' column values", {
  expect_true("total_deaths" %in% names(joint_data), "Data should have a 'total_deaths' column.")
  
  expect_true(is.double(joint_data$total_deaths),
              "Values in 'year_rank' column should be numeric.")
  
  expect_true(all(joint_data$total_deaths >= 100000 & joint_data$total_deaths <= 400000),
              "Values in 'total_deaths' column are expected to be within the range 100,000 through 400,000.")
})

