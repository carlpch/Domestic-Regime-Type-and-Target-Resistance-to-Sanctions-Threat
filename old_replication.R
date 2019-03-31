
# ------------------------------------------------------------
# ------------------------------------------------------------
# 
# 2019.03.30: Note: officially abandon using R to run the model
# 
# ------------------------------------------------------------
# ------------------------------------------------------------

require(tidyverse) # for data manipulation
require(haven) # for reading STATA files
require(forcats) # categorical variable
require(carlpch) # for rownonmiss
require(countrycode) # for cowcode
require(margins)

the_data <- read_dta("_data/_replication/sanctions-II-replication.dta") %>%
  mutate(bin_outcome = ifelse(m_outcome==1,1,0),
         target_regime = factor(target_regime),
         financial_san = factor(financial_san),
         targeted_san = factor(targeted_san),
         is_security = factor(is_security),
         is_econ = factor(is_econ),
         is_hrts = factor(is_hrts),
         post_coldwar = factor(post_coldwar),
         sender_usa = factor(sender_usa),
         institution = factor(institution),
         sender_regime = factor(sender_regime),
         past_success = factor(past_success),
         multiple = factor(multiple),
         perso = factor(ifelse(target_regime ==3,1,0))
         )

#l_tt t_tradeshare_mainUN t_tradeshare_altcow t_tradeshare_altUN t_tradeshare_alt_UNimputed1
model <- glm(bin_outcome ~ l_tt*target_regime +
               t_gdp + s_gdp + financial_san + targeted_san + 
               capdist + is_security + is_econ + is_hrts + cinc_ratio + post_coldwar + 
               sender_usa + institution + sender_regime + past_success + multiple, 
             family = "binomial", data = the_data)
summary(model)

# Generate Predicted Probability
# grid <- data.frame(target_regime=seq(3,1))
model2 <- glm(bin_outcome ~ l_tt*perso +
               t_gdp + s_gdp + financial_san + targeted_san + 
               capdist + is_security + is_econ + is_hrts + cinc_ratio + post_coldwar + 
               sender_usa + institution + sender_regime + past_success + multiple, 
             family = "binomial", data = the_data)
# cplot(model2, x = "perso", what = "prediction")

margins(model2, at = list(perso = 0))

