# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")
library("patchwork")
library("broom")
library("car")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
data1 <- read_tsv(file = "data/03_analysis_1_clean_aug.tsv")
data2 <- read_tsv(file = "data/03_analysis_2_clean_aug.tsv")


# Wrangle data ------------------------------------------------------------
data_nested <- data1 %>%
  left_join(data2) %>% 
  mutate(continent = as.factor(continent)) %>% 
  pivot_longer(cols = c(Casesper100kpp, Deathsper100kpp, FatalityRate, PositiveRate),
               names_to = "y_names",
               values_to = "y_values") %>% 
  group_by(y_names) %>%
  nest() %>%
  ungroup()


# Model data -------------------------------------------------------------
data_nested <- data_nested %>% 
  mutate(mdl = map(data, ~lm(y_values ~ (continent 
                                         + UrbanPop
                                         + LifeExp
                                         + Smoking
                                         + AlcConsump
                                         + SBP_m 
                                         + SBP_f 
                                         + cholesterol_m 
                                         + cholesterol_f 
                                         + BMI_m
                                         + BMI_f
                                         + GovtHealthUSD_pp 
                                         + TotHealthUSD_pp 
                                         + DemScore 
                                         + CPI
                                         + WomanInParlia
                                         + Income_pp
                                         + BasicSaniAcc 
                                         + PopDens),
                             data = .x))) %>% 
  mutate(mdl_tidy = map(mdl, ~tidy(.x, conf.int = TRUE))) %>%
  mutate(anv = map(mdl, ~Anova(.x)))

results_anova <- data_nested %>% 
  select(y_names, anv) %>% 
  mutate(anv = map(anv, ~cbind(variable = rownames(.x), .x))) %>% 
  unnest(anv) %>% 
  rename("anv_pvalue" = "Pr(>F)") %>%
  filter(anv_pvalue <= 0.05)

results_model <- data_nested %>% 
  select(y_names, mdl_tidy) %>% 
  unnest(mdl_tidy) %>% 
  left_join(results_anova, by = "y_names") %>% 
  filter(str_detect(term, variable)) %>% 
  select(y_names, term, p.value, estimate, conf.low, conf.high, variable, anv_pvalue)


# Visualize data ----------------------------------------------------------



# Write data --------------------------------------------------------------
#write_tsv(...)
#ggsave(...)