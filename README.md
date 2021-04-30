# 2021_group_17
Final project repository

How to edit file: When work is in progress and its pushed, mark it like this:  
\# Annette  
y = work in progress  
z = more work  
\# Annette  



Idea 1:
- x: Gapminder statistics
- y: total cases / 100k people
- y2: total deaths / 100k people
- y3: fatality rate
- alternative y: excess mortality / 100k people (2020 vs. 2019/2018/2017) -> find the data!
Two analysis for y and y2, then compare with with each other!
- alternative y:  total cases/ 100k people / number of days since 10th case 

Idea 2:
- x: Day (starting with the day of 10th infection)
- y: total cases

John Hopkins data:
- 01: time series covid19 confirmed
- 02: time series covid19 deaths
- 03: Population count (IUD)

Gapminder statistics:

- 04: Urban population (% of total)
- 05: Life expenctancy (years)
- 06: Smoking adults
- 07: alcohol consumption
- 08: Body Mass Index, men
- 09: Body Mass Index, women
- 10: Blood pressure, men 
- 11: Blood pressure, women
- 12: Fat in blood, men
- 13: Fat in blood, women
- 14: Govt. health spending / person (US$)
- 15: Total health spending / person (US$)
- 16: Working hours per week
- 17: Democracy score
- 18: Corruption Perception index 
- 19: Percentage of women in parliaments
- 20: Income per person (GDP/capita, PPP inflation-adjusted)
- 21: At least basic sanitation, overall access (%)
- 22: Land area (sq. km) -> to calculate Population density


TO DO:

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
- join the dataframes 
- only take the rows that we need
- check that all countries are included! (length of gapminder table == length of new table)
- save cleaned dataframe (only one file)
03_augment:
- load cleaned dataframe
- create the additional attributes (total cases / 100k people, total deaths / 100k people, fatality rate, continent, population density)
- save dataframe ready for analysis
04_analysis:
- PCA
- ?

Work split up until next monday:
- Annette: 04-13, prework and 01_load
- Matthias: 14-22, prework and 01_load
- Thomas: 01_load and 02_clean for the covid data (datafiles 01,02,03)
- Carlotta: finish 02_clean or write sceleton for it, in case the files are not ready yet

Things to ask Leon:

- Correlation problem? 
- Final presentation: using premade tables?
