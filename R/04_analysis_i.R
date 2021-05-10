# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")
library("broom")
library("cowplot")
library("patchwork")
library("viridis")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
data_clean_aug <- read_tsv(file = "data/03_data_clean_aug.tsv")


# Wrangle data ------------------------------------------------------------

#one hot encode continents and then filter for only numeric values
data_numeric <- data_clean_aug %>% 
  mutate(isAfrica = case_when(continent == 'Africa' ~ 1,
                              continent != 'Africa' ~ 0)) %>% 
  mutate(isAmericas = case_when(continent == 'Americas' ~ 1,
                                continent != 'Americas' ~ 0)) %>% 
  mutate(isAsia = case_when(continent == 'Asia' ~ 1,
                            continent == 'Asia' ~ 0)) %>% 
  mutate(isEurope = case_when(continent == 'Europe' ~ 1,
                              continent != 'Europe' ~ 0)) %>% 
  mutate(isOceania = case_when(continent == 'Oceania' ~ 1,
                               continent != 'Oceania' ~ 0)) %>% 
  select_if(is.numeric)


# Model data -------------------------------------------------------------

#PCA fit of Cases
pca_fit_cases <- data_numeric %>% 
  select(-Cases) %>% 
  prcomp(scale. = TRUE)

#PCA fit of Deaths
pca_fit_deaths <- data_numeric %>% 
  select(-Deaths) %>% 
  prcomp(scale. = TRUE)

#PCA fit of Fatality Rate
pca_fit_FR <- data_numeric %>% 
  select(-FatalityRate) %>% 
  prcomp(scale. = TRUE)

# Visualise data ----------------------------------------------------------

#PCA plot for Cases
plot1 <- pca_fit_cases %>% 
  augment(data_numeric) %>% 
  mutate(Cases = log(Cases)) %>% 
  ggplot(aes(.fittedPC1, .fittedPC2, color = Cases)) +
  scale_color_viridis(option = 'C',
                      name = 'log(Cases)') +
  geom_point(size = 2) +
  theme(legend.position = "bottom",
        legend.key.width = unit(1.5, "cm")) +
  labs(x = 'PC1',
       y = 'PC2')

#PCA plot for Deaths
plot2 <- pca_fit_deaths %>% 
  augment(data_numeric) %>% 
  mutate(Deaths = log(Deaths)) %>% 
  ggplot(aes(.fittedPC1, .fittedPC2, color = Deaths)) +
  scale_color_viridis(option = 'C',
                      name = 'log(Deaths)') +
  geom_point(size = 2) +
  theme(legend.position = "bottom",
        legend.key.width = unit(1.5, "cm")) +
  labs(x = 'PC1',
       y = 'PC2')

#PCA plot for Fatality Rate
plot3 <- pca_fit_FR %>% 
  augment(data_numeric) %>% 
  mutate(FatalityRate = log(FatalityRate)) %>% 
  ggplot(aes(.fittedPC1, .fittedPC2, color = FatalityRate)) +
  scale_color_viridis(option = 'C',
                      name = 'log(Fatality Rate)') +
  geom_point(size = 2) +
  theme(legend.position = "bottom",
        legend.key.width = unit(1.5, "cm")) +
  labs(x = 'PC1',
       y = 'PC2')

plot1 + plot2 + plot3

# Box plots of cases per 100k pp, deaths per 100k pp and fatality rate for each continent.
pl1 <- data_clean_aug %>% ggplot(mapping = aes(x = continent, y = Casesper100kpp, fill = continent)) +
  geom_boxplot(alpha = 0.5) +
  labs(x = "Continent",
       y = "Number of cases per 100k inhabitants",
       fill = "Continent") +
  theme_classic(base_size = 18,
                base_family = "Avenir") +
  theme(legend.position = "none",axis.title = element_text(size = 12),
        axis.text.x = element_text(size = 8),axis.text.y = element_text(size = 8))
pl2 <- data_clean_aug %>% ggplot(mapping = aes(x = continent, y = Deathsper100kpp, fill = continent)) +
  geom_boxplot(alpha = 0.5) +
  labs(x = "Continent",
       y = "Number of deaths per 100k inhabitants",
       fill = "Continent") +
  theme_classic(base_size = 18,
                base_family = "Avenir") +
  theme(legend.position = "none",axis.title = element_text(size = 12),
        axis.text.x = element_text(size = 8), axis.text.y = element_text(size = 8))
pl3 <- data_clean_aug %>% ggplot(mapping = aes(x = continent, y = FatalityRate, fill = continent)) +
  geom_boxplot(alpha = 0.5) +
  labs(x = "Continent",
       y = "Fatality rate",
       fill = "Continent") +
  theme_classic(base_size = 18,
                base_family = "Avenir") +
  theme(legend.position = "none",axis.title = element_text(size = 12),
        axis.text.x = element_text(size = 8), axis.text.y = element_text(size = 8))

pl1 + pl2 / pl3

# Linear regression

# Without fill=continent the linear regression is clearer.
data_clean_aug %>% 
  ggplot(mapping = aes(x= Smoking, y = Deathsper100kpp, fill=continent)) + 
  #facet_wrap(~continent)+ # We can use this or not
  labs(x = "Smoking index",
       y = "Number of deaths per 100k inhabitants")+
  geom_smooth(method = lm) +
  geom_point()+
  theme(legend.position = "bottom")

data_clean_aug %>% 
  ggplot(mapping = aes(x= Smoking, y = Casesper100kpp)) + 
  #facet_wrap(~continent)+ # We can use this or not
  labs(x = "Smoking index",
       y = "Number of cases per 100k inhabitants")+
  geom_smooth(method = lm) +
  geom_point()+
  theme(legend.position = "bottom")

data_clean_aug %>% 
  ggplot(mapping = aes(x= Smoking, y = FatalityRate)) + 
  #facet_wrap(~continent)+ # We can use this or not
  labs(x = "Smoking index",
       y = "Fatality rate")+
  geom_smooth(method = lm) +
  geom_point()+
  theme(legend.position = "bottom")


data_clean_aug %>% 
  ggplot(mapping = aes(x= BasicSaniAcc, y = Deathsper100kpp)) + 
  #facet_wrap(~continent)+ # We can use this or not
  labs(x = "BasicSaniAcc",
       y = "Deaths per 100k inhabitants")+
  geom_smooth(method = lm) +
  geom_point()+
  theme(legend.position = "bottom")


# Density plot, not sure if relevant
data_clean_aug %>% 
  ggplot(mapping = aes(x = FatalityRate,
                     fill=continent)) +
  geom_density(alpha = 0.5)+
  labs(x = "Fatality rate",
       y = "Density")


# BMI per continent
data_clean_aug %>% filter(continent=='Europe') %>%
  ggplot(mapping = aes(x = Country, y = BMI_f, color=BMI_f_class)) + 
  geom_point() +
  coord_flip()+
  theme(legend.position = "right",axis.text.y = element_text(size = 7))+
  labs(x = "Country",
       y = "BMI in females")

# Fatality rate per continent
data_clean_aug %>% filter(continent=='Europe') %>%
  ggplot(mapping = aes(x = Country, y = FatalityRate, color=Fatality_class)) + 
  geom_point() +
  coord_flip()+
  geom_hline(yintercept = 2.070798, linetype = "dashed")+
  theme(legend.position = "right",axis.text.y = element_text(size = 7))+
  labs(x = "Country",
       y = "Fatality rate")

# Write data --------------------------------------------------------------
write_tsv(...)
ggsave(...)