library(shellpipes)
library(dplyr)

commandEnvironments()

# Drop cases that are greater than...
## HH size > 8
hhsize_drop <- 8
## Total HH expenditure >= 100K
total_expend_drop_lower <- 100
total_expend_drop_upper <- 10000
## HH Shocks
shocks_drop <- 10
## Age 
age_drop_lower <- 20
age_drop_upper <- 60
## Self rating
selfrating_drop <- 7

nrow(working_df_complete)

working_df_complete <- (working_df_complete
	%>% mutate_at(problems_group_vars, function(x){as.numeric(as.character(x))})
	%>% mutate_at(problems_ever_group_vars, function(x){ifelse(x=="yes", 1, 0)})
	%>% mutate(total_expenditure = rowSums(select(., !!expenditure_group_vars), na.rm = TRUE)
		, shocks = rowSums(select(., !!problems_group_vars), na.rm = TRUE)
		, shocks_ever = rowSums(select(., !!problems_ever_group_vars), na.rm = TRUE)
		, shocks_ever_bin = ifelse(shocks_ever>=1, "Yes"
			, ifelse(shocks_ever==0, "No", as.character(shocks_ever))
		)
	)
	%>% filter(numpeople_total_new <= hhsize_drop 
		& total_expenditure >= total_expend_drop_lower
		& total_expenditure < total_expend_drop_upper
		& shocks < shocks_drop
		& ageyears_new >= age_drop_lower
		& ageyears_new <= age_drop_upper
		& selfrating_new <= selfrating_drop
	)
)
nrow(working_df_complete)
head(working_df_complete)

saveVars(working_df_complete)
