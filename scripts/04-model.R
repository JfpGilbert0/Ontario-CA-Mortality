#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(modelsummary)

#### Read data ####
analysis_data <- read_csv("data/analysis_data/analysis_data.csv")

### Model data ####
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

summary(cause_of_death_ontario_neg_binomial)

pp_check(cause_of_death_ontario_neg_binomial)



rank_ontario_neg_binomial <-
  stan_glm(
    year_rank ~ value,
    data = joint_data,
    family = neg_binomial_2(link = "log"),
    seed = 853
  )

pp_check(rank_ontario_neg_binomial)

summary(rank_ontario_neg_binomial)

#### Save model ####
# saveRDS(first_model, file = "models/first_model.rds")


