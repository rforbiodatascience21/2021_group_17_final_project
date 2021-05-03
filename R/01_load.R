# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
cases_data_raw <- read_csv(file = "data/_raw/01_time_series_covid19_confirmed_global.csv")
deaths_data_raw <- read_csv(file = "data/_raw/02_time_series_covid19_deaths_global.csv")
regions_data_raw <- read_csv(file = "data/_raw/03_UID_ISO_FIPS_LookUp_Table.csv")

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
data14_raw <- read.csv(file = "data/_raw/14_government_health_spending_per_person_us.csv")
data15_raw <- read.csv(file = "data/_raw/15_total_health_spending_per_person_us.csv")
data16_raw <- read.csv(file = "data/_raw/16_ag_lnd_totl_k2.csv")
data17_raw <- read.csv(file = "data/_raw/17_democracy_score_use_as_color.csv")
data18_raw <- read.csv(file = "data/_raw/18_corruption_perception_index_cpi.csv")
data19_raw <- read.csv(file = "data/_raw/19_wn_bothhouses_c.csv")
data20_raw <- read.csv(file = "data/_raw/20_income_per_person_gdppercapita_ppp_inflation_adjusted.csv")
data21_raw <- read.csv(file = "data/_raw/21_at_least_basic_sanitation_overall_access_percent.csv")
data22_raw <- read.csv(file = "data/_raw/22_data_regions.csv")


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
  select('Combined_Key', 'Country_Region', 'Population') %>% 
  rename('Country/Region' = 'Country_Region')

data04_raw <- data04_raw  %>% 
  select(country, X2019) %>% 
  rename(UrbanPop = X2019)
data05_raw <- data05_raw  %>% 
  select(country, X2017) %>% 
  rename(LifeExp = X2017)
data06_raw <- data06_raw  %>% 
  select(country, X2005) %>% 
  rename(Smoking = X2005)
data07_raw <- data07_raw  %>% 
  select(country, X2008) %>% 
  rename(AlcConsump = X2008)
data08_raw <- data08_raw  %>% 
  select(country, X2008) %>% 
  rename(BMI_m = X2008)
data09_raw <- data09_raw  %>% 
  select(country, X2008) %>% 
  rename(BMI_f = X2008)
data10_raw <- data10_raw  %>% 
  select(country, X2008) %>% 
  rename(SBP_m = X2008)
data11_raw <- data11_raw  %>% 
  select(country, X2008) %>% 
  rename(SBP_f = X2008)
data12_raw <- data12_raw  %>% 
  select(country, X2008) %>% 
  rename(cholesterol_m = X2008)
data13_raw <- data13_raw  %>% 
  select(country, X2008) %>% 
  rename(cholesterol_f = X2008)
data14_raw <- data14_raw  %>% 
  select(country, X2010) %>% 
  rename(GovtHealthUSD_pp = X2010)
data15_raw <- data15_raw  %>% 
  select(country, X2010) %>% 
  rename(TotHealthUSD_pp = X2010)
data16_raw <- data16_raw  %>% 
  select(country, X2018) %>% 
  rename(LandSqkm = X2018)
data17_raw <- data17_raw  %>% 
  select(country, X2011) %>% 
  rename(DemScore = X2011)
data18_raw <- data18_raw  %>% 
  select(country, X2017) %>% 
  rename(CPI = X2017)
data19_raw <- data19_raw  %>% 
  select(country, X2020) %>% 
  rename(WomanInParlia = X2020)
data20_raw <- data20_raw  %>% 
  select(country, X2021) %>% 
  rename(Income_pp = X2021)
data21_raw <- data21_raw  %>% 
  select(country, X2017) %>% 
  rename(BasicSaniAcc = X2017)
data22_raw <- data22_raw  %>% 
  select(country, continent)

# Write data --------------------------------------------------------------
write_tsv(x = cases_data_raw,
          file = "data/01_01CovidCases.tsv")
write_tsv(x = deaths_data_raw,
          file = "data/01_02CovidDeaths.tsv")
write_tsv(x = regions_data_raw,
          file = "data/01_03Regions.tsv")
write_tsv(x = data04_raw, 
          file = "data/01_04UrbanPop.tsv")
write_tsv(x = data05_raw, 
          file = "data/01_05LifeExp.tsv")
write_tsv(x = data06_raw, 
          file = "data/01_06Smoking.tsv")
write_tsv(x = data07_raw, 
          file = "data/01_07AlcConsump.tsv")
write_tsv(x = data08_raw, 
          file = "data/01_08BMI_m.tsv")
write_tsv(x = data09_raw, 
          file = "data/01_09BMI_f.tsv")
write_tsv(x = data10_raw, 
          file = "data/01_10SBP_m.tsv")
write_tsv(x = data11_raw, 
          file = "data/01_11SBP_f.tsv")
write_tsv(x = data12_raw, 
          file = "data/01_12cholesterol_m.tsv")
write_tsv(x = data13_raw, 
          file = "data/01_13cholesterol_f.tsv")
write_tsv(x = data14_raw, 
          file = "data/01_14GovtHealthUSD_pp.tsv")
write_tsv(x = data15_raw, 
          file = "data/01_15TotHealthUSD_pp.tsv")
write_tsv(x = data16_raw, 
          file = "data/01_16LandSqkm.tsv")
write_tsv(x = data17_raw, 
          file = "data/01_17DemScore.tsv")
write_tsv(x = data18_raw, 
          file = "data/01_18CPI.tsv")
write_tsv(x = data19_raw, 
          file = "data/01_19WomanInParlia.tsv")
write_tsv(x = data20_raw, 
          file = "data/01_20Income_pp.tsv")
write_tsv(x = data21_raw, 
          file = "data/01_21BasicSaniAcc.tsv")
write_tsv(x = data22_raw, 
          file = "data/01_22DataRegions.tsv")
