#### Preamble ####
# Purpose: Downloads and saves the data from [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(arrow)
library(downloader)
#### Download data ####
download(url="https://www150.statcan.gc.ca/n1/tbl/csv/13100394-eng.zip", dest="data/raw_data/dataset.zip", mode="wb") 
unzip("data/raw_data/dataset.zip", exdir = "data/raw_data/")
file.remove("data/raw_data/dataset.zip")
raw_data <- read_csv("data/raw_data/13100394.csv")

#### Save data ####
# saves raw data as a parquet
write_parquet(x = raw_data, sink = "data/raw_data/raw_mortality_data.parquet")
