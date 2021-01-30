library(shellpipes)
library(dplyr)

commandEnvironments()

#### Compare complete cases with all cases
working_df_complete <- (working_df
	%>% na.omit()
)

### Number of cases to impute missing
impute_na <- nrow(working_df) - nrow(working_df_complete)

## Create indicator for cases to drop based on don't know, NIU and refused
working_df_complete <- (working_df_complete
	%>% mutate(impute_cases = ifelse(imputeCase(., patterns = "missing:impute"), 1, 0))
   %>% mutate_at(colnames(.), function(x)na_if(x, "missing:impute"))
   %>% mutate_at(colnames(.), function(x)na_if(x, "999996"))
   %>% mutate_at(colnames(.), function(x)na_if(x, "999999"))
   %>% mutate_at(colnames(.), function(x)na_if(x, "999997"))
   %>% mutate_at(colnames(.), function(x)na_if(x, "999998"))
   %>% mutate_at(colnames(.), function(x)na_if(x, "9999995"))
   %>% mutate_at(colnames(.), function(x)na_if(x, "NIU (not in universe)"))
   %>% droplevels()
	%>% na.omit()
	%>% data.frame()
)

head(working_df_complete)

saveVars(working_df_complete
	, impute_na
)
