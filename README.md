# 2021_group_17
Final project repository

### How to edit file: 
When work is in progress and its pushed, mark it like this:  
\# Annette  
y = work in progress  
z = more work  
\# Annette  



## Idea 1:
- x: Gapminder statistics
- y: total cases / 100k people
- y2: total deaths / 100k people
- y3: fatality rate
- alternative y: excess mortality / 100k people (2020 vs. 2019/2018/2017) -> find the data!
Two analysis for y and y2, then compare with with each other!
- alternative y:  total cases/ 100k people / number of days since 10th case 

## Idea 2:
- x: Day (starting with the day of 10th infection)
- y: total cases

## Raw data:

### John Hopkins data
- 01: time series covid19 confirmed
- 02: time series covid19 deaths
- 03: Population count (IUD)

### Gapminder statistics
https://www.gapminder.org/data/
- 04: Urban population (% of total) - [2019] (https://data.worldbank.org/indicator/SP.URB.TOTL.IN.ZS)
- 05: Life expenctancy (years) - [2017] (http://gapm.io/ilex)
- 06: Smoking adults - [2005] (https://www.who.int/gho/en/)
- 07: alcohol consumption - [2008] (https://www.who.int/gho/en/)
- 08: Body Mass Index, men - [2008] (https://www.imperial.ac.uk/school-public-health/epidemiology-and-biostatistics/)
- 09: Body Mass Index, women - [2008] (https://www.imperial.ac.uk/school-public-health/epidemiology-and-biostatistics/)
- 10: Blood pressure, men - [2008] (https://www.imperial.ac.uk/school-public-health/epidemiology-and-biostatistics/)
- 11: Blood pressure, women - [2008] (https://www.imperial.ac.uk/school-public-health/epidemiology-and-biostatistics/)
- 12: Fat in blood, men - [2008] (https://www.imperial.ac.uk/school-public-health/epidemiology-and-biostatistics/)
- 13: Fat in blood, women - [2008] (https://www.imperial.ac.uk/school-public-health/epidemiology-and-biostatistics/)
- 14: Govt. health spending / person (US$) - [2010] (https://www.who.int/data/gho)
- 15: Total health spending / person (US$) - [2010] (https://www.who.int/data/gho)
- 16: Land area (sq. km) -> to calculate Population density - [2018] (http://www.fao.org/home/en/)
- 17: Democracy score - [2011] (https://www.systemicpeace.org/polityproject.html)
- 18: Corruption Perception index - [2017] (https://www.transparency.org/en/cpi/2020/index/nzl) 
- 19: Percentage of women in parliaments - [2020] (http://gapm.io/dwparl)
- 20: Income per person (GDP/capita, PPP inflation-adjusted) - [2021] (https://www.gapminder.org/data/documentation/gd001/) #Projection
- 21: At least basic sanitation, overall access (%) - [2017] (https://data.worldbank.org/indicator/SH.STA.SMSS.ZS) #2015?
- 22: Dictionary of countries and continents - (https://github.com/vincentarelbundock/countrycode/blob/main/dictionary/data_regions.csv)


## TO DO:

Pre-work:
- download the data from gapminder and upload it to the _raw
- decide which year to take from each table and add the year to the README  

01_load: 
- load the raw dataframes
- take the columns that we need
- change column name to describe attribute
- save each dataframe again (many files, with each having only two columns)  

02_clean:
- load all data frames
- for the covid counts file: add up up the numbers, so that only one row for each country
- join the dataframes according to country name
- check that all countries are included 
- save cleaned dataframe (only one file)  

03_augment:
- load cleaned dataframe
- create the additional attributes (total cases/100k people, total deaths/100k people, fatality rate, population density, additional categories (f.ex. BMI))
- save dataframe ready for analysis  

04_analysis:
- PCA
- linear regression

### Work split up until next Wednesday kl 20.00 :

- gapminder data (04-21):
  - fix data 04, read from the .xlsx file downloaded from gapminder (**Mathias**)
  - full join (**Mathias**)
  - Fix N/A, take the mean (most basic method, because focus is on the process raw data to analysis data) (**Mathias**)
  - change the country names to fit the covid count data (**Annette**)
- continent data (22):
  - change the country names to fit the covid count data (**Annette**)
- covid data (01-02):
  - aggregate the region data to one country (**Thomas**)
- Population data (03):
  - remove the regions (**Thomas**)
- Join all data together (01-22) (**Thomas**)
- Create new attributes in 03_augment (**Carlota**)


## Things to ask Leon:

- Final presentation: using premade tables?
- Should we use stringr, to solve issues where the country names are different?
