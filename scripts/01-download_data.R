#### Preamble ####
# Purpose: Download the raw data set from statcan.gc.ca and save it locally
# Author: Jacob Gilbert and Liam Wall
# Date: 2024-03-15
# Contact: liam.wall@mail.utoronto.ca, jacob.gilbert@mail.utoronto.ca
# License: MIT


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

