library(shellpipes)
library(dplyr)

commandEnvironments()

#### Proportion of missingness to drop variables
drop_miss <- 10	# Drop all variables with this % missing
drop_vars <- c(miss_df_temp$variable[miss_df_temp$miss_prop>=drop_miss], "expend_total_USD_per_new")
print(drop_vars)

#### Select the remaining va
new_vars <- grep("\\_new$", colnames(working_df), value  = TRUE)
working_df <- (working_df
	%>% select(!!new_vars)
	%>% select(-!!drop_vars)
)

saveVars(miss_before_df
	, miss_after_df
	, working_df
	, tab_intperyear
	, miss_category_summary
)


