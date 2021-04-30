# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
cases_data_raw <- read_csv(file = "data/_raw/time_series_covid19_confirmed_global.csv")
deaths_data_raw <- read_csv(file = "data/_raw/time_series_covid19_deaths_global.csv")
regions_data_raw <- read_csv(file = "data/_raw/UID_ISO_FIPS_LookUp_Table.csv")


# Wrangle data ------------------------------------------------------------
#get number of cases/deaths from last day (29th of April)
cases_data_raw <- cases_data_raw %>%
  select('Province/State', 'Country/Region', '4/29/21') %>% 
  rename('Cases' = '4/29/21')

deaths_data_raw <- deaths_data_raw %>%
  select('Province/State', 'Country/Region', '4/29/21') %>% 
  rename('Deaths' = '4/29/21')

#get countries, combined key and population (combined key used for cleaning)
regions_data_raw <- regions_data_raw %>% 
  select('Combined_Key', 'Country_Region', 'Population')


# Write data --------------------------------------------------------------
write_tsv(x = cases_data_raw, file = "data/01_cases.tsv")
write_tsv(x = deaths_data_raw, file = "data/01_deaths.tsv")
write_tsv(x = regions_data_raw, file = "data/01_regions.tsv")
