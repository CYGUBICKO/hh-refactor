library(shellpipes)
library(tibble)
library(dplyr)

commandEnvironments()

### Missing proportion for the cleaned variables
clean_vars <- grep("\\_new$", colnames(working_df), value = TRUE)
miss_df_temp <- missProp(working_df[, clean_vars])
miss_df <- (miss_df_temp
	%>% arrange(desc(miss_count))
	%>% droplevels()
)
print(miss_df)
