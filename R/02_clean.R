# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
cases <- read_tsv(file = "data/01_cases.tsv")
deaths <- read_tsv(file = "data/01_deaths.tsv")
regions <- read_tsv(file = "data/01_regions.tsv")


# Wrangle data ------------------------------------------------------------
#only include countries not cities/districts
#remove missing values


# Write data --------------------------------------------------------------
write_tsv(x = my_data_clean,
          file = "data/02_my_data_clean.tsv")