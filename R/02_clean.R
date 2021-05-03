# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
data01 <- read_tsv(file = "data/01_01CovidCases.tsv")
data02 <- read_tsv(file = "data/01_02CovidDeaths.tsv")
data03 <- read_tsv(file = "data/01_03Regions.tsv")
data04 <- read_tsv(file = "data/01_04UrbanPop.tsv")
data05 <- read_tsv(file = "data/01_05LifeExp.tsv")
data06 <- read_tsv(file = "data/01_06Smoking.tsv")
data07 <- read_tsv(file = "data/01_07AlcConsump.tsv")
data08 <- read_tsv(file = "data/01_08BMI_m.tsv")
data09 <- read_tsv(file = "data/01_09BMI_f.tsv")
data10 <- read_tsv(file = "data/01_11SBP_f.tsv")
data11 <- read_tsv(file = "data/01_11SBP_f.tsv")
data12 <- read_tsv(file = "data/01_12cholesterol_m.tsv")
data13 <- read_tsv(file = "data/01_13cholesterol_f.tsv")
data14 <- read_tsv(file = "data/01_14GovtHealthUSD_pp.tsv")
data15 <- read_tsv(file = "data/01_15TotHealthUSD_pp.tsv")
data16 <- read_tsv(file = "data/01_16LandSqkm.tsv")
data17 <- read_tsv(file = "data/01_17DemScore.tsv")
data18 <- read_tsv(file = "data/01_18CPI.tsv")
data19 <- read_tsv(file = "data/01_19WomanInParlia.tsv")
data20 <- read_tsv(file = "data/01_20Income_pp.tsv")
data21 <- read_tsv(file = "data/01_21BasicSaniAcc.tsv")


# Wrangle data ------------------------------------------------------------

#Countries separated by region (ex Australia) are summarized into one variable
data01 <- data01 %>% 
  group_by(Country) %>% 
  summarise_all(sum)

data02 <- data02 %>% 
  group_by(Country) %>% 
  summarise_all(sum)

#Only keep total population of countries (eliminate reginal data)
covid_data <- data01 %>% 
  left_join(data02, x_names = Country) %>% 
  left_join(data03, x_names = Country)

data_clean_x <- data04 %>% 
  left_join(data05) %>% 
  left_join(data06) %>% 
  left_join(data07) %>% 
  left_join(data08) %>% 
  left_join(data09) %>% 
  left_join(data10) %>% 
  left_join(data11) %>%
  left_join(data12) %>% 
  left_join(data13) %>% 
  left_join(data14) %>% 
  left_join(data15) %>% 
  left_join(data16) %>% 
  left_join(data17) %>% 
  left_join(data18) %>% 
  left_join(data19) %>% 
  left_join(data20) %>% 
  left_join(data21) %>% 
  left_join(data22)


# Write data --------------------------------------------------------------
#write_tsv(x = my_data_clean,
          #file = "data/02_my_data_clean.tsv")
