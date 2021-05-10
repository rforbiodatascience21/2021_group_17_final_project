# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")
library("broom")
library("cowplot")
library("patchwork")
library("viridis")


# Load data ---------------------------------------------------------------
analysis_1_clean_aug <- read_tsv(file = "data/03_analysis_1_clean_aug.tsv")


# Wrangle data ------------------------------------------------------------

#one hot encode continents and then filter for only numeric values
data_numeric <- analysis_1_clean_aug  %>% 
  mutate(isAfrica = case_when(continent == 'Africa' ~ 1,
                              continent != 'Africa' ~ 0)) %>% 
  mutate(isAmericas = case_when(continent == 'Americas' ~ 1,
                                continent != 'Americas' ~ 0)) %>% 
  mutate(isAsia = case_when(continent == 'Asia' ~ 1,
                            continent != 'Asia' ~ 0)) %>% 
  mutate(isEurope = case_when(continent == 'Europe' ~ 1,
                              continent != 'Europe' ~ 0)) %>% 
  mutate(isOceania = case_when(continent == 'Oceania' ~ 1,
                               continent != 'Oceania' ~ 0)) %>% 
  select_if(is.numeric)


# Model data -------------------------------------------------------------

#PCA fit of Cases
pca_fit <- data_numeric %>% 
  select(-Cases) %>%
  select(-Casesper100kpp) %>%
  select(-Deaths) %>%
  select(-Deathsper100kpp) %>%
  select(-FatalityRate) %>% 
  prcomp(scale. = TRUE)


# Visualise data ----------------------------------------------------------

#PCA plot for Cases
plot1_pca <- pca_fit %>% 
  augment(data_numeric) %>% 
  ggplot(aes(.fittedPC1, 
             .fittedPC2, 
             color = Casesper100kpp)) +
  scale_color_viridis(option = 'C',
                      name = 'Cases per 100k people') +
  geom_point(size = 2) +
  theme(legend.position = "bottom",
        legend.key.width = unit(1.5, 
                                "cm")) +
  labs(x = 'PC1',
       y = 'PC2',
       title = "PCA Cases per 100k inhabitants")
plot1_pca

#PCA plot for Deaths
plot2_pca <- pca_fit %>% 
  augment(data_numeric) %>% 
  ggplot(aes(.fittedPC1, 
             .fittedPC2, 
             color = Deathsper100kpp)) +
  scale_color_viridis(option = 'C',
                      name = 'Deaths per 100k people') +
  geom_point(size = 2) +
  theme(legend.position = "bottom",
        legend.key.width = unit(1.5, 
                                "cm")) +
  labs(x = 'PC1',
       y = 'PC2',
       title = "PCA Deaths per 100k inhabitants")
plot2_pca

#PCA plot for Fatality Rate
plot3_pca <- pca_fit %>% 
  augment(data_numeric) %>% 
  ggplot(aes(.fittedPC1, 
             .fittedPC2, 
             color = FatalityRate)) +
  scale_color_viridis(option = 'C',
                      name = 'log(Fatality Rate)') +
  geom_point(size = 2) +
  theme(legend.position = "bottom",
        legend.key.width = unit(1.5, 
                                "cm")) +
  labs(x = 'PC1',
       y = 'PC2',
       title = "PCA Fatality rate")
plot3_pca

plot1_pca / plot2_pca 

ggsave("PCA_first_analysis.png", 
       path = "results/",
       plot = (plot1_pca / plot2_pca ),width = 15, height = 10)

# Box plots of cases per 100k pp, deaths per 100k pp and fatality rate for each continent.
pl1 <- analysis_1_clean_aug %>% 
  ggplot(mapping = aes(x = continent, 
                       y = Casesper100kpp, 
                       fill = continent)) +
  geom_boxplot(alpha = 0.5) +
  labs(x = "Continent",
       y = "Number of cases per 100k inhabitants",
       fill = "Continent") +
  theme_classic(base_size = 18,
                base_family = "Avenir") +
  theme(legend.position = "none",
        axis.title = element_text(size = 12),
        axis.text.x = element_text(size = 8),
        axis.text.y = element_text(size = 8))

pl2 <- analysis_1_clean_aug %>% 
  ggplot(mapping = aes(x = continent, 
                       y = Deathsper100kpp, 
                       fill = continent)) +
  geom_boxplot(alpha = 0.5) +
  labs(x = "Continent",
       y = "Number of deaths per 100k inhabitants",
       fill = "Continent") +
  theme_classic(base_size = 18,
                base_family = "Avenir") +
  theme(legend.position = "none",
        axis.title = element_text(size = 12),
        axis.text.x = element_text(size = 8), 
        axis.text.y = element_text(size = 8))

pl3 <- analysis_1_clean_aug %>% 
  ggplot(mapping = aes(x = continent, 
                       y = FatalityRate, 
                       fill = continent)) +
  geom_boxplot(alpha = 0.5) +
  labs(x = "Continent",
       y = "Fatality rate",
       fill = "Continent") +
  theme_classic(base_size = 18,
                base_family = "Avenir") +
  theme(legend.position = "none",
        axis.title = element_text(size = 12),
        axis.text.x = element_text(size = 8), 
        axis.text.y = element_text(size = 8))

pl1 + pl2 / pl3

ggsave("Boxplot_first_analysis.png", 
       path = "results/",
       plot = (pl1 + pl2 / pl3))

# Linear regression

# Without fill=continent the linear regression is clearer.
pl4 <- analysis_1_clean_aug %>% 
  ggplot(mapping = aes(x= Smoking, 
                       y = Deathsper100kpp, 
                       fill=continent)) + 
  #facet_wrap(~continent)+ # We can use this or not
  labs(x = "Smoking index",
       y = "Number of deaths per 100k inhabitants")+
  geom_smooth(method = lm) +
  geom_point()+
  theme(legend.position = "bottom")

ggsave("Scatterplot_smoking_continent.png", 
       path = "results/",
       plot = pl4)

# All continents together
pl5 <- analysis_1_clean_aug %>% 
  ggplot(mapping = aes(x= Smoking, 
                       y = Deathsper100kpp)) + 
  #facet_wrap(~continent)+ # We can use this or not
  labs(x = "Smoking index",
       y = "Number of deaths per 100k inhabitants")+
  geom_smooth(method = lm) +
  geom_point() +
  theme(legend.position = "bottom")

ggsave("Scatterplot_smoking_all.png", 
       path = "results/",
       plot = pl5)


# Sanitary access scatterplot
pl6 <- analysis_1_clean_aug %>% 
  ggplot(mapping = aes(x= BasicSaniAcc, 
                       y = Deathsper100kpp)) + 
  #facet_wrap(~continent)+ # We can use this or not
  labs(x = "BasicSaniAcc",
       y = "Deaths per 100k inhabitants")+
  geom_smooth(method = lm) +
  geom_point()+
  theme(legend.position = "bottom")

ggsave("Scatterplot_saniacc_all.png", 
       path = "results/",
       plot = pl6)

# Density plot, not sure if relevant
pl7 <- analysis_1_clean_aug %>% 
  ggplot(mapping = aes(x = FatalityRate,
                     fill=continent)) +
  geom_density(alpha = 0.5)+
  labs(x = "Fatality rate",
       y = "Density")
ggsave("Densityplot_continent.png", 
       path = "results/",
       plot = pl7)

# BMI per continent
analysis_1_clean_aug %>% 
  filter(continent=='Europe') %>%
  ggplot(mapping = aes(x = Country, 
                       y = BMI_f, 
                       color=BMI_f_class)) + 
  geom_point() +
  coord_flip()+
  theme(legend.position = "right",
        axis.text.y = element_text(size = 7)) +
  labs(x = "Country",
       y = "BMI in females")

# Fatality rate per continent
pl8 <- analysis_1_clean_aug %>% 
  filter(continent=='Europe') %>%
  ggplot(mapping = aes(x = Country, 
                       y = FatalityRate, 
                       color=Fatality_class)) + 
  geom_point() +
  coord_flip() +
  geom_hline(yintercept = 2.070798, 
             linetype = "dashed")+
  theme(legend.position = "right",
        axis.text.y = element_text(size = 7))+
  labs(x = "Country",
       y = "Fatality rate")

ggsave("Fatalityrate_europe.png", 
       path = "results/",
       plot = pl8)
# Write data --------------------------------------------------------------
#write_tsv(...)
#ggsave(...)