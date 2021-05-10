# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")
library("patchwork")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
analysis_2_clean_aug <- read_tsv(file = "data/03_analysis_2_clean_aug.tsv")


# Visualise data ----------------------------------------------------------

data_2_numeric <- analysis_2_clean_aug  %>% 
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

#PCA fit of the Positive Rate
pca_fit_positive <- data_2_numeric %>% 
  select(-PositiveRate) %>% 
  prcomp(scale. = TRUE)


#PCA plot for the Positive Rate
pca_fit_positive %>% 
  augment(data_2_numeric) %>% 
  mutate(PositiveRate = log(PositiveRate)) %>% 
  ggplot(aes(.fittedPC1, 
             .fittedPC2, 
             color = PositiveRate)) +
  scale_color_viridis(option = 'C',
                      name = 'log(PositiveRate)') +
  geom_point(size = 2) +
  labs(x = 'PC1',
       y = 'PC2')




# Box plots of Tests per person and Positive Rate for each continent.
pl1 <- analysis_2_clean_aug %>% 
  ggplot(mapping = aes(x = continent, 
                       y = Tests_pp, 
                       fill = continent)) +
  geom_boxplot(alpha = 0.5) +
  labs(x = "Continent",
       y = "Cumulative tests per person",
       fill = "Continent") +
  theme_classic(base_size = 18,
                base_family = "Avenir") +
  theme(legend.position = "none",
        axis.title = element_text(size = 12),
        axis.text.x = element_text(size = 8),
        axis.text.y = element_text(size = 8))

<<<<<<< HEAD:R/04_analysis_ii.R

bp2 <- analysis_2_clean_aug %>% 
=======
pl2 <- analysis_2_clean_aug %>% 
>>>>>>> d88c1d62d49e6a37c76745d41623cacd8c2bbd4e:R/04_analysis_2.R
  ggplot(mapping = aes(x = continent, 
                       y = PositiveRate, 
                       fill = continent)) +
  geom_boxplot(alpha = 0.5) +
  labs(x = "Continent",
       y = "Positive Rate",
       fill = "Continent") +
  theme_classic(base_size = 18,
                base_family = "Avenir") +
  theme(legend.position = "none",
        axis.title = element_text(size = 12),
        axis.text.x = element_text(size = 8),
        axis.text.y = element_text(size = 8))
pl1 + pl2

<<<<<<< HEAD:R/04_analysis_ii.R
bp_combined <- bp1 + bp2

# Linear regression

p1 <- analysis_2_clean_aug %>% 
  ggplot(mapping = aes(x = PositiveRate, 
                       y = Casesper100kpp)) + 
  facet_wrap(~continent) + # We can use this or not
  labs(x = "Positive rate",
       y = "Number of cases per 100k inhabitants")+
  geom_smooth(method = lm) +
  geom_point() +
  theme(legend.position = "bottom")
=======
ggsave("Boxplot_CumulativeTesting_Continent.png", 
       path = "results/",
       plot = pl1)

ggsave("Boxplot_PositiveRate_Continent.png", 
       path = "results/",
       plot = pl2)
# Linear regression
>>>>>>> d88c1d62d49e6a37c76745d41623cacd8c2bbd4e:R/04_analysis_2.R

# Without fill=continent the linear regression is clearer.

p2 <- analysis_2_clean_aug %>% 
  ggplot(mapping = aes(x = Tests_pp, 
                       y = Casesper100kpp)) + 
  facet_wrap(~continent)+ # We can use this or not
  labs(x = "Cumulative tests per person",
       y = "Number of cases per 100k inhabitants")+
  geom_smooth(method = lm,
              fullrange = TRUE) +
<<<<<<< HEAD:R/04_analysis_ii.R
  geom_point() +
=======
  geom_point()+
>>>>>>> d88c1d62d49e6a37c76745d41623cacd8c2bbd4e:R/04_analysis_2.R
  theme(legend.position = "bottom")


p3 <- analysis_2_clean_aug %>% 
  ggplot(mapping = aes(x = BasicSaniAcc, 
                       y = PositiveRate)) + 
  facet_wrap(~continent)+ # We can use this or not
  labs(x = "Basic Sanitaion Access",
       y = "Positive rate")+
  geom_smooth(method = lm) +
  geom_point()+
  theme(legend.position = "bottom")


p4 <- analysis_2_clean_aug %>% 
  ggplot(mapping = aes(x = PopDens, 
                       y = PositiveRate)) + 
  facet_wrap(~continent)+ # We can use this or not
  labs(x = "Population density",
       y = "Positive rate")+
  geom_smooth(method = lm) +
  geom_point()+
  theme(legend.position = "bottom")


p5 <- analysis_2_clean_aug %>% 
  ggplot(mapping = aes(x = GovtHealthUSD_pp,
                       y = Tests_pp)) +
  geom_smooth(method = lm) +
  geom_point() +
  labs(x = "Governmental healthcare spendings per person (USD)",
       y = "Cumulative tests per person")


p6 <- analysis_2_clean_aug %>% 
  ggplot(mapping = aes(x = GovtHealthUSD_pp,
                       y = PositiveRate)) +
  geom_smooth(method = lm) +
  geom_point() +
  labs(x = "Governmental healthcare spendings per person (USD)",
       y = "Positive Rate")


p7 <- analysis_2_clean_aug %>% 
  ggplot(mapping = aes(x = PositiveRate,
<<<<<<< HEAD:R/04_analysis_ii.R
                       y = FatalityRate)) +
  geom_smooth(method = lm) +
  geom_point() +
=======
                       fill = continent)) +
  geom_density(alpha = 0.5)+
>>>>>>> d88c1d62d49e6a37c76745d41623cacd8c2bbd4e:R/04_analysis_2.R
  labs(x = "Positive rate",
       y = "Fatality rate")


# 10 countries with highest Positive Rate
b1 <- analysis_2_clean_aug %>%
  slice_max(order_by = PositiveRate,
            n=10)%>% 
  mutate(Country = fct_reorder(Country, 
                               PositiveRate,
                               .desc = FALSE)) %>% 
  ggplot(mapping = aes(x = Country,
                       y = PositiveRate,
                       fill = continent)) + 
  coord_flip() +
  geom_bar(stat="Identity")

# 10 countries with lowest Positive Rate
b2 <- analysis_2_clean_aug %>%
  slice_min(order_by = PositiveRate,
            n=10)%>% 
  mutate(Country = fct_reorder(Country, 
                               PositiveRate,
                               .desc = TRUE)) %>% 
  ggplot(mapping = aes(x = Country,
                       y = PositiveRate,
                       fill = continent)) + 
  coord_flip() +
  geom_bar(stat="Identity")

# Write data --------------------------------------------------------------
<<<<<<< HEAD:R/04_analysis_ii.R
ggsave("Boxplot_CumulativeTesting_Continent.png", 
       path = "results/",
       plot = bp1)

ggsave("Boxplot_PositiveRate_Continent.png", 
       path = "results/",
       plot = bp2)

ggsave("Boxplot_Testing_and_PositiveRate_Continent.png", 
       path = "results/",
       plot = bp_combined)

ggsave("Cases_vs_Testing_Projection.png", 
       path = "results/",
       plot = p2)

ggsave("Tests_vs_GovernmentalHealthSpending.png", 
       path = "results/",
       plot = p5)

ggsave("PositiveRate_vs_GovernmentalHealthSpending.png", 
       path = "results/",
       plot = p6)

ggsave("10_Highest_PositiveRate.png", 
       path = "results/",
       plot = b1)

ggsave("10_Lowest_PositiveRate.png", 
       path = "results/",
       plot = b2)
=======
write_tsv(...)
ggsave(...)
>>>>>>> d88c1d62d49e6a37c76745d41623cacd8c2bbd4e:R/04_analysis_2.R
