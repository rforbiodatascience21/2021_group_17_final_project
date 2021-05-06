# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
data_clean <- read_tsv(file = "data/02_data_clean.tsv")


# Wrangle data ------------------------------------------------------------
data_clean_aug <- data_clean %>% mutate(Casesper100kpp = round((Cases / Population * 100000), digits = 2)) %>% 
  mutate(Deathsper100kpp = round((Deaths / Population * 100000), digits = 2)) %>%
  mutate(FatalityRate = round((Deaths / Cases * 100), digits = 2)) %>%
  mutate(PopDens)



# Write data --------------------------------------------------------------
write_tsv(x = data_clean_aug,
          file = "data/03_data_clean_aug.tsv")
