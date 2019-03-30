require(tidyverse) # for data manipulation
require(haven) # for reading STATA files
require(forcats) # categorical variable
require(carlpch) # for rownonmiss
require(countrycode) # for cowcode
require(corrr)


ties <- read_csv('_data/TIESv4.csv')
ties <- ties %>% 
  mutate(binary_outcome = ifelse(as.integer(finaloutcome) %in% c(1,2),1,0))%>%
  select(targetstate, startyear, binary_outcome) 
  
weeks <- read_dta('_data/weeks_raw_full_public.dta')
weeks <- weeks %>% select(targetstate=ccode,startyear=year,ends_with('jlw'))

data <- ties %>% 
  left_join(weeks, by = c('targetstate','startyear')) 
  
# data <- data %>% mutate(target = countrycode(targetstate, 'cown','country.name'))




library(modelr)
options(na.action = na.warn)
model <- lm(binary_outcome ~ strongmanjlw, data=data)
summary(model)

require(glmnet)