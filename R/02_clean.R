# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")


# Load data ---------------------------------------------------------------
#Make list of input files
JH_files = list.files(path = "/cloud/project/data",
                      pattern = "^01_JH_.+\\.tsv$")

Gap_files = list.files(path = "/cloud/project/data",
                       pattern = "^01_Gap_.+\\.tsv$")

#Read in data as tsv
setwd("/cloud/project/data")

JH_data = map(JH_files, 
              read_tsv)

Gap_data = map(Gap_files, 
               read_tsv)

setwd("/cloud/project")

data_continent <- read_tsv(file = "data/01_CC_22DataRegions.tsv")

all_testing <- read_tsv(file = "data/01_OWID_23AllTesting.tsv")


# Wrangle data ------------------------------------------------------------
#Countries separated by region (ex Australia) are summarized into one variable
JH_01 <- JH_data %>%
  pluck(1) %>% 
  group_by(Country) %>% 
  summarise_all(sum)

JH_02 <- JH_data %>% 
  pluck(2) %>% 
  group_by(Country) %>% 
  summarise_all(sum)

JH_03 <- JH_data %>% 
  pluck(3)

# Only keep total population of countries (disregard regional data)
data_covid <- JH_01 %>% 
  left_join(JH_02, 
            by="Country") %>% 
  left_join(JH_03, 
            by="Country")

# Full join gapminder data by country
# Replace NAs with mean of variable
data_gapminder <- Gap_data %>% 
  reduce(full_join, 
         by="country") %>% 
  mutate_if(is_numeric,
            function(x)
            {replace_na(x, 
                        mean(x,
                             na.rm=TRUE))
            })

# Fix names, so they are in agreement with data_covid
data_gapminder <- data_gapminder %>% 
  mutate(country = case_when(country == "Myanmar" ~ "Burma",
                             country == "Cape Verde" ~ "Cabo Verde",
                             country == "Congo, Rep." ~ "Congo (Brazzaville)",
                             country == "Congo, Dem. Rep." ~ "Congo (Kinshasa)",
                             country == "Czech Republic" ~ "Czechia",
                             country == "South Korea" ~ "Korea, South",
                             country == "Kyrgyz Republic" ~ "Kyrgyzstan",
                             country == "Lao" ~ "Laos",
                             country == "Micronesia, Fed. Sts." ~ "Micronesia",
                             country == "St. Kitts and Nevis" ~ "Saint Kitts and Nevis",
                             country == "St. Lucia" ~ "Saint Lucia",
                             country == "St. Vincent and the Grenadines" ~ "Saint Vincent and the Grenadines",
                             country == "Slovak Republic" ~ "Slovakia",
                             country == "United States" ~ "US",
                             country == "Palestine" ~ "West Bank and Gaza",
                             TRUE ~ country)) %>% 
  rename("Country" = "country")

# To join all data together the countries variable has to be spelled the same way in every dataframe
data_continent <- data_continent %>% 
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

# Selection of cumulative tests done by 2021-04-30
all_testing <- all_testing %>% 
  separate("Entity",
           c("Country", 
             "TestUnit"),
           sep = " - ") %>%
  filter(TestUnit != "units unclear") %>% 
  filter(str_detect(Date, 
                    "^2021-04-"))%>% 
  group_by(Country) %>% 
  select("Country",
         "CumulativeTesting") %>% 
  top_n(n=1) %>% 
  mutate(Country = case_when(Country == "South Korea" ~ "Korea, South",
                             Country == "United States" ~ "US",
                             TRUE ~ Country))


# Full join, to see which countries are excluded in our analysis
# Drop all countries with NA values to get the clean data set
combined_1_clean <- data_covid %>% 
  left_join(data_continent, 
            by="Country") %>% 
  left_join(data_gapminder, 
            by="Country") %>% 
  drop_na()
  
combined_2_clean <- combined_1_clean %>% 
  left_join(all_testing, 
            by="Country") %>% 
  drop_na()


# Write data --------------------------------------------------------------
write_tsv(x = combined_1_clean,
          file = "data/02_combined_1_clean.tsv")

write_tsv(x = combined_2_clean,
          file = "data/02_combined_2_clean.tsv")
