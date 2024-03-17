#### Preamble ####
# Purpose: Simulate a clean Ontario mortality data set and graph our data in a meaningful way
# Author: Jacob Gilbert and Liam Wall
# Date: 2024-03-15
# Contact: liam.wall@mail.utoronto.ca, jacob.gilbert@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)

#### Simulate data ####
ontario_death_simulation <-
  tibble(
    cause = rep(x = c("Heart", "Stroke", "Diabetes"), times = 10),
    year = rep(x = 2016:2018, times = 10),
    deaths = rnbinom(n = 30, size = 20, prob = 0.1)
  )

ontario_death_simulation


