# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")
library("patchwork")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
data_clean_testing_aug <- read_tsv(file = "data/03_data_testing_clean_aug.tsv")


# Visualise data ----------------------------------------------------------


# Box plots of Tests per person and Positive Rate for each continent.
pl1 <- data_clean_testing_aug %>% 
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

pl2 <- data_clean_testing_aug %>% 
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

# Linear regression

# Without fill=continent the linear regression is clearer.

data_clean_testing_aug %>% 
  ggplot(mapping = aes(x= Tests_pp, 
                       y = Casesper100kpp)) + 
  facet_wrap(~continent)+ # We can use this or not
  labs(x = "Cumulative tests per person",
       y = "Number of cases per 100k inhabitants")+
  geom_smooth(method = lm) +
  geom_point()+
  theme(legend.position = "bottom")


data_clean_testing_aug %>% 
  ggplot(mapping = aes(x = BasicSaniAcc, 
                       y = PositiveRate)) + 
  facet_wrap(~continent)+ # We can use this or not
  labs(x = "Basic Sanitaion Access",
       y = "Positive rate")+
  geom_smooth(method = lm) +
  geom_point()+
  theme(legend.position = "bottom")


data_clean_testing_aug %>% 
  ggplot(mapping = aes(x = PopDens, 
                       y = PositiveRate)) + 
  facet_wrap(~continent)+ # We can use this or not
  labs(x = "Population density",
       y = "Positive rate")+
  geom_smooth(method = lm) +
  geom_point()+
  theme(legend.position = "bottom")


# Density plot, not sure if relevant
data_clean_testing_aug %>% 
  ggplot(mapping = aes(x = PositiveRate,
                       fill = continent)) +
  geom_density(alpha = 0.5)+
  labs(x = "Positive rate",
       y = "Density")


# 10 countries with highest Fatality rate
data_clean_testing_aug %>%
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

#
data_clean_testing_aug %>% 
  ggplot(mapping = aes(x = WomanInParlia,
                       y = PositiveRate,
                       color = continent)) +
  geom_smooth(method = lm) +
  geom_point()+
  labs(x = "Women in Parliament",
       y = "Positive Rate")


# Write data --------------------------------------------------------------
write_tsv(...)
ggsave(...)