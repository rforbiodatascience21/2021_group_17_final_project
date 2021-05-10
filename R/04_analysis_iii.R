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
  rename("pvalue" = "Pr(>F)") %>%
  filter(pvalue <= 0.05) %>% 
  select(y_names, variable, pvalue) %>% 
  pivot_wider(names_from = y_names, values_from = pvalue) %>% 
  rename(p.value_Casesper100kpp = Casesper100kpp) %>% 
  rename(p.value_Deathsper100kpp = Deathsper100kpp) %>% 
  rename(p.value_FatalityRate = FatalityRate) %>% 
  rename(p.value_PositiveRate = PositiveRate)

results_estimates <- data_nested %>% 
  select(y_names, mdl_tidy) %>% 
  unnest(mdl_tidy) %>% 
  select(y_names, term, estimate, std.error, conf.low, conf.high)



# Write data --------------------------------------------------------------
write_tsv(x = results_anova, 
          file = "results/Ancova_pvalues.tsv")
write_tsv(x = results_estimates 
          %>%  filter( y_names == "Casesper100kpp"), 
          file = "results/Estimates_Casesper100kpp.tsv")
write_tsv(x = results_estimates 
          %>%  filter( y_names == "Deathsper100kpp"), 
          file = "results/Estimates_Deathsper100kpp.tsv")
write_tsv(x = results_estimates 
          %>%  filter( y_names == "FatalityRate"), 
          file = "results/Estimates_FatalityRate.tsv")
write_tsv(x = results_estimates 
          %>%  filter( y_names == "PositiveRate"), 
          file = "results/Estimates_PositiveRate.tsv")