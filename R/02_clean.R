# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------

#Make list of input files
my_files = list.files(path = "/cloud/project/data",
                      pattern = "^01_.+\\.tsv$")

#The working directory is changed to retrieve the data
setwd("/cloud/project/data")

#Read in data as tsv
my_data = map(my_files, read_tsv)

setwd("/cloud/project")

# Wrangle data ------------------------------------------------------------

#Countries separated by region (ex Australia) are summarized into one variable
data01 <- my_data %>%
  pluck(1) %>% 
  group_by(Country) %>% 
  summarise_all(sum)

data02 <- my_data %>% 
  pluck(2) %>% 
  group_by(Country) %>% 
  summarise_all(sum)

data03 <- my_data %>% 
  pluck(3)

#Only keep total population of countries (eliminate regional data)
data_covid <- data01 %>% 
  left_join(data02, by="Country") %>% 
  left_join(data03, by="Country")


#Full join gapminder data by country
data_gapminder <- my_data[4:21] %>% 
  reduce(full_join, 
         by="country")

#Replace NAs with mean
data_gapminder <- data_gapminder %>% 
  mutate_if(is_numeric,
            function(x)
            {replace_na(x, 
                        mean(x,
                             na.rm=TRUE))
            })

#Fix names, so they are in agreement with data_covid
data_gapminder <- data_gapminder %>% 
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
data_continent <- my_data %>% 
  pluck(22) %>% 
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

#EU testing - Currently not used
EU_testing <- my_data %>%
  pluck(23) %>% 
  filter(level == "national") %>% 
  select("country", 
         "tests_done") %>% 
  group_by(country) %>% 
  summarise_all(sum)


#All testing - Currently not used
all_testing <- my_data %>%
  pluck(24)

all_testing <- all_testing %>% 
  separate("Entity",
           c("Country", "TestUnit"),
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
data_full <- data_covid %>% 
  full_join(data_continent, by="Country") %>% 
  full_join(data_gapminder, by="Country")

data_full_testing <- data_covid %>% 
  full_join(data_continent, by="Country") %>% 
  full_join(data_gapminder, by="Country") %>% 
  full_join(all_testing, by="Country")

# Drop all countries with NA values to get the clean data set
data_clean <- data_full %>% 
  drop_na()

data_testing_clean <- data_full_testing %>% 
  drop_na()

# Write data --------------------------------------------------------------
write_tsv(x = data_clean,
          file = "data/02_data_clean.tsv")

write_tsv(x = data_testing_clean,
          file = "data/02_data_testing_clean.tsv")