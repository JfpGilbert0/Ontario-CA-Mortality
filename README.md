# Starter folder

## Overview

This repo contains the paper and code to produce the paper on Ontario mortality from 2000 to 2022. We analyze Ontario mortality data and create a model in order to offer predictions on leading causes of death for the next five years. The model was built using R and rstanarm package and is saved on this repo.


## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from X.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted models. 
-   `other` contains relevant literature, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.


## Statement on LLM usage

Aspects of this paper were completed with the help on ChatGPT-4. The entire conversation is in the 'other' -> 'llm usage' folder contained in a txt file. ChatGPT-4 was consulted for help with code cleaning and creating simple bits of code like a simulation data frame for example. The main use of ChatGPT-4 in this paper was for the use of understanding different aspects of the model I created. I created the model and fed ChatGPT-4 some information outputted and it helped me understand the parts of the model that were good and not-so-good.