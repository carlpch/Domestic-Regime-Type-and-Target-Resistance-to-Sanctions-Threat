require(tidyverse) # for data manipulation
require(haven) # for reading STATA files
require(forcats) # categorical variable
require(carlpch) # for rownonmiss
require(countrycode) # for cowcode
require(corrr)

#1 Read TIES data into R, recode binary outcome and simplify variables
ties <- read_csv('_data/TIESv4.csv') 
ties <- ties %>% 
  mutate(binary_outcome = ifelse(as.integer(finaloutcome) %in% c(1,2),1,0))%>%
  select(targetstate, startyear, binary_outcome) 
  
#2 Read Weeks data partially ("demjlw", "juntajlw", "strongmanjlw", "machinejlw","bossjlw","regimejlw")
weeks <- read_dta('_data/weeks_raw_full_public.dta') %>% 
  select(targetstate=ccode,startyear=year,ends_with('jlw'))

#3 Merge TIES and Weeks
data <- ties %>% left_join(weeks, by = c('targetstate','startyear')) 

library(modelr)
options(na.action = na.warn)
model <- glm(binary_outcome ~ strongmanjlw, data=data, family='binomial')
summary(model)

require(glmnet)