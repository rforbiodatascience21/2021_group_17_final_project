# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
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
data_gapminder_clean_x <- data04 %>% 
  full_join(data05, by="country") %>% 
  full_join(data06, by="country") %>% 
  full_join(data07, by="country") %>% 
  full_join(data08, by="country") %>% 
  full_join(data09, by="country") %>% 
  full_join(data10, by="country") %>% 
  full_join(data11, by="country") %>%
  full_join(data12, by="country") %>% 
  full_join(data13, by="country") %>% 
  full_join(data14, by="country") %>% 
  full_join(data15, by="country") %>% 
  full_join(data16, by="country") %>% 
  full_join(data17, by="country") %>% 
  full_join(data18, by="country") %>% 
  full_join(data19, by="country") %>% 
  full_join(data20, by="country") %>% 
  full_join(data21, by="country")



# Write data --------------------------------------------------------------
write_tsv(x = data_gapminder_clean_x,
          file = "data/02_gapminder_clean_NA.tsv")
