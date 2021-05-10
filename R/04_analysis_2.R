# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")
library("patchwork")


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
bp1 <- analysis_2_clean_aug %>% 
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

bp2 <- analysis_2_clean_aug %>% 
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

# Linear regression

analysis_2_clean_aug %>% 
  ggplot(mapping = aes(x = PositiveRate, 
                       y = Casesper100kpp)) + 
  facet_wrap(~continent) + # We can use this or not
  labs(x = "Cumulative tests per person",
       y = "Number of cases per 100k inhabitants")+
  geom_smooth(method = lm) +
  geom_point() +
  theme(legend.position = "bottom")


analysis_2_clean_aug %>% 
  ggplot(mapping = aes(x = Tests_pp, 
                       y = Casesper100kpp)) + 
  facet_wrap(~continent) + # We can use this or not
  labs(x = "Cumulative tests per person",
       y = "Number of cases per 100k inhabitants")+
  geom_smooth(method = lm) +
  geom_point() +
  theme(legend.position = "bottom")


analysis_2_clean_aug %>% 
  ggplot(mapping = aes(x = BasicSaniAcc, 
                       y = PositiveRate)) + 
  facet_wrap(~continent)+ # We can use this or not
  labs(x = "Basic Sanitaion Access",
       y = "Positive rate") +
  geom_smooth(method = lm) +
  geom_point() +
  theme(legend.position = "bottom")


analysis_2_clean_aug %>% 
  ggplot(mapping = aes(x = PopDens, 
                       y = PositiveRate)) + 
  facet_wrap(~continent) + # We can use this or not
  labs(x = "Population density",
       y = "Positive rate") +
  geom_smooth(method = lm) +
  geom_point()+
  theme(legend.position = "bottom")


# Density plot, not sure if relevant
analysis_2_clean_aug %>% 
  ggplot(mapping = aes(x = PositiveRate,
                       fill = continent)) +
  geom_density(alpha = 0.5) +
  labs(x = "Positive rate",
       y = "Density")


# 10 countries with highest Positive Rate
analysis_2_clean_aug %>%
  slice_max(order_by = PositiveRate,
            n=10) %>% 
  mutate(Country = fct_reorder(Country, 
                               PositiveRate,
                               .desc = FALSE)) %>% 
  ggplot(mapping = aes(x = Country,
                       y = PositiveRate,
                       fill = continent)) + 
  coord_flip() +
  geom_bar(stat="Identity")

# 10 countries with lowest Positive Rate
analysis_2_clean_aug %>%
  slice_min(order_by = PositiveRate,
            n=10) %>% 
  mutate(Country = fct_reorder(Country, 
                               PositiveRate,
                               .desc = TRUE)) %>% 
  ggplot(mapping = aes(x = Country,
                       y = PositiveRate,
                       fill = continent)) + 
  coord_flip() +
  geom_bar(stat="Identity")

#
analysis_2_clean_aug %>% 
  ggplot(mapping = aes(x = WomanInParlia,
                       y = PositiveRate,
                       color = continent)) +
  geom_smooth(method = lm) +
  geom_point()+
  labs(x = "Women in Parliament",
       y = "Positive Rate")


# Write data --------------------------------------------------------------
ggsave("Boxplot_CumulativeTesting_Continent.png", 
       path = "results/",
       plot = bp1)

ggsave("Boxplot_PositiveRate_Continent.png", 
       path = "results/",
       plot = bp2)
write_tsv(...)
ggsave(...)