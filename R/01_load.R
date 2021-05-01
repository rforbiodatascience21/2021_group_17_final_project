# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
data04_raw <- read.csv(file = "data/_raw/04_urban_population_percent_of_total.csv")
data05_raw <- read.csv(file = "data/_raw/05_life_expectancy_years.csv")
data06_raw <- read.csv(file = "data/_raw/06_smoking_adults_percent_of_population_over_age_15.csv")
data07_raw <- read.csv(file = "data/_raw/07_alcohol_consumption_per_adult_15plus_litres.csv")
data08_raw <- read.csv(file = "data/_raw/08_body_mass_index_bmi_men_kgperm2.csv")
data09_raw <- read.csv(file = "data/_raw/09_body_mass_index_bmi_women_kgperm2.csv")
data10_raw <- read.csv(file = "data/_raw/10_blood_pressure_sbp_men_mmhg.csv")
data11_raw <- read.csv(file = "data/_raw/11_blood_pressure_sbp_women_mmhg.csv")
data12_raw <- read.csv(file = "data/_raw/12_cholesterol_fat_in_blood_men_mmolperl.csv")
data13_raw <- read.csv(file = "data/_raw/13_cholesterol_fat_in_blood_women_mmolperl.csv")

# Wrangle data ------------------------------------------------------------
data04_raw <- data04_raw  %>% 
  select(country, X2019) %>% 
  rename(UrbanPop = X2019)
data05_raw <- data05_raw  %>% 
  select(country, X2017) %>% 
  rename(LifeExp = X2017)


# Write data --------------------------------------------------------------
write_tsv(x = data04_raw, 
          file = "data/01_data04_UrbanPop.tsv")
write_tsv(x = data05_raw, 
          file = "data/01_data05_LifeExp.tsv")