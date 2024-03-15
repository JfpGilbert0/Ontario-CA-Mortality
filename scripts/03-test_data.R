#### Preamble ####
# Purpose: Tests many aspects of the final cleaned data sets.
# Author: Jacob Gilbert and Liam Wall
# Date: today
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



types_of_age <- cleaned_data |>
  count(age)

count_of_years <- cleaned_data |>
  count(year)

count_of_causes <- cleaned_data |>
  count(cause)

cleaned_data |>
  count(characteristics)

covid_data <- cleaned_data |>
  select(year, age, sex, cause, characteristics, value) |>
  filter(year > 2016, 
         cause == "COVID-19 [U07.1, U07.2, U10.9]",
         characteristics == "Rank of leading causes of death" | characteristics == "Number of deaths",
         age == "Age at time of death, all ages"
         )

rank_data <- cleaned_data |>
  select(year, age, sex, cause, characteristics, value) |>
  filter(characteristics == "Rank of leading causes of death",
         age == "Age at time of death, all ages",
         sex == "Both sexes",
         value > 0)

rank_data |>
  filter(value < 11) |>
  ggplot(aes(x = year, y = value)) +
  geom_point(aes(color = cause)) +
  theme(legend.position = "none")

death_data <- cleaned_data |>
  select(year, age, sex, cause, characteristics, value) |>
  filter(characteristics == "Number of deaths",
         age == "Age at time of death, all ages",
         sex == "Both sexes",
         cause != "Total, all causes of death [A00-Y89]")

death_data |>
  ggplot(aes(x = year, y = value)) +
  geom_point(aes(color = cause)) +
  theme(legend.position = "none")

#Total annual death data for both sexes and all causes
total_yearly_death_data <- cleaned_data |>
  filter(characteristics == "Number of deaths",
         cause == "Total, all causes of death [A00-Y89]",
         age == "Age at time of death, all ages",
         sex == "Both sexes") |>
  mutate(number_of_deaths = value) |>
  select(year, age, sex, cause, number_of_deaths) |>
  ggplot(aes(x = year, y = number_of_deaths)) +
  geom_point()

cleaned_data |>
  filter(characteristics == "Number of deaths",
         cause != "Total, all causes of death [A00-Y89]",
         age == "Age at time of death, all ages",
         sex == "Both sexes") |>
  mutate(number_of_deaths = value) |>
  select(year, age, sex, cause, number_of_deaths) |>
  count(year) |> arrange(-n)

cleaned_data |>
  filter(characteristics == "Rank of leading causes of death",
         cause != "Total, all causes of death [A00-Y89]",
         age == "Age at time of death, all ages",
         sex == "Both sexes") |>
  mutate(rank = value) |>
  select(year, age, sex, cause, rank)


#rank as a column, 99,605 rows
cleaned_data |>
  filter(characteristics == "Rank of leading causes of death") |>
  mutate(rank = value) |>
  select(year, age, sex, cause, rank)


joint_data |>
  ggplot(aes(x = year, y = value)) +
  geom_point(aes(color = cause), alpha = 0.5) +
  theme(legend.position = "bottom") +
  geom_smooth(aes(color = cause), method = "glm", formula = "y ~ x") +
  geom_smooth(
    method = "lm",
    formula = "y ~ x",
    color = "black"
  ) +
  theme_minimal() +
  scale_color_brewer(palette = "Set1")  +
  theme(legend.position = "bottom")

cause_of_death_ontario_neg_binomial <-
  stan_glm(
    value ~ cause,
    data = joint_data,
    family = neg_binomial_2(link = "log"),
    seed = 853
  )

joint_data |>
  filter(str_detect(cause, "COVID"))

summary(cause_of_death_ontario_neg_binomial)


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
