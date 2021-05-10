# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
analysis_1_clean <- read_tsv(file = "data/02_analysis_1_clean.tsv")
analysis_2_clean <- read_tsv(file = "data/02_analysis_2_clean.tsv")


# Wrangle data ------------------------------------------------------------
analysis_1_clean_aug <- analysis_1_clean %>%
  mutate(Casesper100kpp = round((Cases / Population * 100000), 
                                digits = 2)) %>% 
  mutate(Deathsper100kpp = round((Deaths / Population * 100000), 
                                 digits = 2)) %>%
  mutate(FatalityRate = round((Deaths / Cases * 100), 
                              digits = 2)) %>%
  mutate(PopDens = round(Population/LandSqkm,
                         digits = 2)) %>%
  mutate(Fatality_class = case_when(FatalityRate < mean(FatalityRate) ~ "low fatality",
                                    FatalityRate > mean(FatalityRate) ~ "high fatality")) %>%
  mutate(BMI_m_class = case_when(BMI_m < 18.5 ~ "underweight",
                               18.5 <= BMI_m & BMI_m < 24.9 ~ "normal weight",
                               24.9 <= BMI_m & BMI_m < 29.9 ~ "overweight",
                               29.9 <= BMI_m & BMI_m < 35 ~ "obese",
                               35 <= BMI_m & BMI_m < 40 ~ "severe obesity",
                               40 <= BMI_m & BMI_m < 50 ~ "morbid obesity",
                               50 <= BMI_m ~ "super obese" )) %>%
  mutate(BMI_f_class = case_when(BMI_f < 18.5 ~ "underweight",
                               18.5 <= BMI_f & BMI_f < 24.9 ~ "normal weight",
                               24.9 <= BMI_f & BMI_f < 29.9 ~ "overweight",
                               29.9 <= BMI_f & BMI_f < 35 ~ "obese",
                               35 <= BMI_f & BMI_f < 40 ~ "severe obesity",
                               40 <= BMI_f & BMI_f < 50 ~ "morbid obesity",
                               50 <= BMI_f ~ "super obese" ))



analysis_2_clean_aug <- analysis_2_clean %>%
  mutate(PositiveRate = round((Cases / CumulativeTesting), 
                              digits = 3)) %>% 
  mutate(Tests_pp = round((CumulativeTesting / Population), 
                          digits = 3)) %>%
  mutate(Casesper100kpp = round((Cases / Population * 100000), 
                                digits = 2)) %>% 
  mutate(Deathsper100kpp = round((Deaths / Population * 100000), 
                                 digits = 2)) %>%
  mutate(FatalityRate = round((Deaths / Cases * 100), 
                              digits = 2)) %>%
  mutate(PopDens = round(Population/LandSqkm,
                         digits = 2)) %>%
  mutate(Fatality_class = case_when(FatalityRate < mean(FatalityRate) ~ "low fatality",
                                    FatalityRate > mean(FatalityRate) ~ "high fatality")) %>%
  mutate(BMI_m_class = case_when(BMI_m < 18.5 ~ "underweight",
                                 18.5 <= BMI_m & BMI_m < 24.9 ~ "normal weight",
                                 24.9 <= BMI_m & BMI_m < 29.9 ~ "overweight",
                                 29.9 <= BMI_m & BMI_m < 35 ~ "obese",
                                 35 <= BMI_m & BMI_m < 40 ~ "severe obesity",
                                 40 <= BMI_m & BMI_m < 50 ~ "morbid obesity",
                                 50 <= BMI_m ~ "super obese" )) %>%
  mutate(BMI_f_class = case_when(BMI_f < 18.5 ~ "underweight",
                                 18.5 <= BMI_f & BMI_f < 24.9 ~ "normal weight",
                                 24.9 <= BMI_f & BMI_f < 29.9 ~ "overweight",
                                 29.9 <= BMI_f & BMI_f < 35 ~ "obese",
                                 35 <= BMI_f & BMI_f < 40 ~ "severe obesity",
                                 40 <= BMI_f & BMI_f < 50 ~ "morbid obesity",
                                 50 <= BMI_f ~ "super obese" ))



# Write data --------------------------------------------------------------
write_tsv(x = analysis_1_clean_aug,
          file = "data/03_analysis_1_clean_aug.tsv")
write_tsv(x = analysis_2_clean_aug,
          file = "data/03_analysis_2_clean_aug.tsv")