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
data22 <- read_tsv(file = "data/01_22DataRegions.tsv")

# Wrangle data ------------------------------------------------------------

#Countries separated by region (ex Australia) are summarized into one variable
data01 <- data01 %>% 
  group_by(Country) %>% 
  summarise_all(sum)

data02 <- data02 %>% 
  group_by(Country) %>% 
  summarise_all(sum)

#Only keep total population of countries (eliminate reginal data)
data_covid <- data01 %>% 
  left_join(data02, by="Country") %>% 
  left_join(data03, by="Country")

#Joining the Gapminder data with full-join
#NAs are replaced with the mean of the variable
data_gapminder <- data04 %>% 
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
  full_join(data21, by="country") %>% 
  mutate_if(is_numeric,
            function(x)
            {replace_na(x, 
                        mean(x,
                              na.rm=TRUE))
              }
            ) %>%
  mutate(country = case_when(country == "Myanmar" ~ "Burma",
                             country == "Cape Verde" ~ "Cabo Verde",
                             country == "Congo, Rep." ~ "Congo (Brazzaville)",
                             country == "Congo, Dem. Rep." ~ "Congo (Kinshasa)",
                             country == "Czech Republic" ~ "Czechia",
                             country == "South Korea" ~ "Korea, South",
                             country == "" ~ "Kosovo",
                             country == "Kyrgyz Republic" ~ "Kyrgyzstan",
                             country == "Lao" ~ "Laos",
                             country == "Micronesia, Fed. Sts." ~ "Micronesia",
                             country == "St. Kitts and Nevis" ~ "Saint Kitts and Nevis",
                             country == "St. Lucia" ~ "Saint Lucia",
                             country == "St. Vincent and the Grenadines" ~ "Saint Vincent and the Grenadines",
                             country == "Slovak Republic" ~ "Slovakia",
                             country == "" ~ "Taiwan*",
                             country == "United States" ~ "US",
                             country == "Palestine" ~ "West Bank and Gaza",
                             TRUE ~ country)) %>% 
  rename('Country' = 'country')


# To join all data together the countries variable has to be spelled the same way in every dataframe
data_continent <- data22 %>% 
  mutate(country = case_when(country == "Congo" ~ "Congo (Brazzaville)",
                             country == "Côte D'Ivoire" ~ "Cote d'Ivoire",
                             country == "Democratic Republic of the Congo" ~ "Congo (Kinshasa)",
                             country == "Bolivia (Plurinational State of)" ~ "Bolivia",
                             country == "Venezuela, Bolivarian Republic of" ~ "Venezuela",
                             country == "Brunei Darussalam" ~ "Brunei",
                             country == "Myanmar" ~ "Burma",
                             country == "Swaziland" ~ "Eswatini",
                             country == "Czech Republic" ~ "Czechia",
                             country == "Gambia (Islamic Republic of the)" ~ "Gambia",
                             country == "Guinea Bissau" ~ "Guinea-Bissau",
                             country == "Holy See (Vatican City State)" ~ "Holy See",
                             country == "Iran (Islamic Republic of)" ~ "Iran",
                             country == "Republic of Korea" ~ "Korea, South",
                             country == "Lao People's Democratic Republic" ~ "Laos",
                             country == "Micronesia (Federated States of)" ~ "Micronesia",
                             country == "Republic of Moldova" ~ "Moldova",
                             country == "The former Yugoslav Republic of Macedonia" ~ "North Macedonia",
                             country == "Russian Federation" ~ "Russia",
                             country == "Syrian Arab Republic" ~ "Syria",
                             country == "Taiwan, Province of China" ~ "Taiwan*",
                             country == "United Republic of Tanzania" ~ "Tanzania",
                             country == "United Kingdom of Great Britain and Northern Ireland" ~ "United Kingdom",
                             country == "United States of America" ~ "US",
                             country == "Viet Nam" ~ "Vietnam",
                             country == "Palestine, State of" ~ "West Bank and Gaza",
                             country == "Democratic People's Republic of Korea" ~ "North Korea",
                             TRUE ~ country)) %>% 
         rename(Country = country)

# Full join, to see which countries are excluded in our analysis
data_full <- data_covid %>% 
  full_join(data_continent, by="Country") %>% 
  full_join(data_gapminder, by="Country")

# Drop all countries with NA values to get the clean data set
data_clean <- data_full %>% 
  drop_na()

# Write data --------------------------------------------------------------
write_tsv(x = data_clean,
          file = "data/02_data_clean.tsv")
