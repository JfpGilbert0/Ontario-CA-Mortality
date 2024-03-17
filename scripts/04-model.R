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
library(shinystan)

#### Read data ####
analysis_data <- read_csv("data/analysis_data/analysis_data.csv")

joint_data |> 
  mutate(cause = str_remove(cause, "\\s*\\[.*\\]")) |>
  ggplot(aes(x = year, y = value)) +
  geom_point(aes(color = cause), alpha = 0.8) +
  theme_minimal() +
  theme(legend.position = "bottom")
#  facet_wrap(vars(cause), dir = "v", ncol = 3) +

joint_data |>
  mutate(cause = str_remove(cause, "\\s*\\[.*\\]")) |>
  ggplot(aes(x = cause, y = value)) +
  geom_point(aes(color = year), alpha = 0.6) +
  theme_minimal() +
  theme(legend.position = "bottom", axis.text.x = element_text(angle=90, hjust=1)) +
  labs()

joint_data |>
  mutate(cause = str_remove(cause, "\\s*\\[.*\\]")) |>
  summarise(avg_rank = mean(year_rank),
            number_years_present = n(),
            .by = cause) |>
  arrange(avg_rank) |>
  mutate()

### Model data ####
cause_of_death_ontario_neg_binomial <-
  stan_glm(
    value ~ cause*year,
    data = joint_data,
    family = neg_binomial_2(link = "log"),
    seed = 853,
    cores = 2
  )

summary(cause_of_death_ontario_neg_binomial)

# launch_shinystan(cause_of_death_ontario_neg_binomial)

pp_check(cause_of_death_ontario_neg_binomial)

loo_neg_binomial <- loo(cause_of_death_ontario_neg_binomial, cores = 2, k_threshold = 0.7)

residuals_df <- data.frame(residuals = residuals(cause_of_death_ontario_neg_binomial))
ggplot(residuals_df, aes(x = residuals)) +
  geom_histogram(bins = 30, fill = "blue", color = "black") +
  theme_minimal() +
  labs(title = "Histogram of Residuals", x = "Residuals", y = "Count")

mcmc_rhat(cause_of_death_ontario_neg_binomial)

# Create Predictions for the next years
recent_causes <- joint_data |>
  filter(year == 2022)
unique_causes <- distinct(recent_causes, cause)

future_years <- rep(2023:2028, each = 10)
future_years <- data.frame(year = 2023:2028)

future_data <- expand.grid(year = future_years$year, cause = unique_causes$cause) |>
  arrange(year)

predicted_counts <- posterior_predict(cause_of_death_ontario_neg_binomial, newdata = future_data)
mean_predicted_counts <- apply(predicted_counts, 2, mean)
future_data$predicted_counts <- mean_predicted_counts

future_data |>
  arrange(cause)

colnames(future_data)[3] <- "value"

future_data |>
  mutate(cause = str_remove(cause, "\\s*\\[.*\\]")) |>
  ggplot(aes(x = year, y = value)) +
  geom_point(aes(color = cause), alpha = 0.8) +
  theme_minimal() +
  theme(legend.position = "bottom")

joint_data |>
  filter(cause == "COVID-19 [U07.1, U07.2, U10.9]")

data_to_combine <- joint_data |>
  select(-year_rank) |>
  select(-total_deaths)

combined_future_data <- rbind(data_to_combine, future_data)

combined_future_data |>
  tail()

combined_future_data |>
  mutate(cause = str_remove(cause, "\\s*\\[.*\\]")) |>
  ggplot(aes(x = year, y = value)) +
  geom_point(aes(color = cause), alpha = 0.8) +
  theme_minimal() +
  theme(legend.position = "bottom")

#Can compare to fitting this data with a Poisson distribution 
cause_of_death_ontario_poisson <-
  stan_glm(
    total_deaths ~ cause,
    data = joint_data,
    family = poisson(link = "log"),
    seed = 853
  )

summary(cause_of_death_ontario_poisson)

pp_check(cause_of_death_ontario_poisson)

loo_poisson <- kfold(cause_of_death_ontario_poisson, cores = 2, K = 10)

loo_compare(loo_poisson, loo_neg_binomial)

residuals_df <- data.frame(residuals = residuals(cause_of_death_ontario_poisson))
ggplot(residuals_df, aes(x = residuals)) +
  geom_histogram(bins = 30, fill = "blue", color = "black") +
  theme_minimal() +
  labs(title = "Histogram of Residuals", x = "Residuals", y = "Count")

#### Save model ####
saveRDS(cause_of_death_ontario_neg_binomial, file = "models/cod_ontario_neg_binomial_two.rds")


max(joint_data$total_deaths)



joint_data |>
  summarise(
    min = min(value),
    mean = mean(value),
    max = max(value),
    sd = sd(value),
    var = sd^2,
    n = n()
    )

joint_data |>
  filter(cause == "Accidents (unintentional injuries) [V01-X59, Y85-Y86]") |>
  arrange(-value)
