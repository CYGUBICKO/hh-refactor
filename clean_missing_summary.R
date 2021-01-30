library(shellpipes)
library(purrr)
library(data.table)
library(tibble)
library(dplyr)

commandEnvironments()

### ---- Missingness but well-defined criteria included (e.g., missing impute, 9999999) ----

## Variables with more than 30% missingness
miss_over30percent <- 30

### Missing proportion for the cleaned variables
new_vars <- grep("\\_new$", colnames(working_df), value = TRUE)
miss_df_temp <- missProp(working_df[, new_vars])
miss_df <- (miss_df_temp
	%>% arrange(desc(miss_count))
	%>% droplevels()
	%>% mutate(variable = gsub("\\_new", "", variable))
)
print(miss_df)

### Add variables description 
miss_before_df <- (miss_category_summary
	%>% select(-Total)
	%>% right_join(., miss_df, by = "variable")
	%>% setnames(c("miss_count", "miss_prop"), c("total_count", "total_prop"))
	%>% mutate(miss_over30percent = ifelse(total_prop >= miss_over30percent, "Yes", "No"))
)
print(miss_before_df)


#### ---- Include well-defined missingness ----

temp_df <- (working_df
	%>% select(!!new_vars)
)

## Missing per missing value indicator
miss_pattern <- list(miss_impute = "^missing\\:impute|9999995"
	, NIU = "^NIU|999999$"
)
miss_after_df <- lapply(seq_along(miss_pattern), function(x){
	tab <- missPattern(temp_df, miss_pattern[[x]])
	tab <- (tab
		%>% select(-miss_count)
		%>% arrange(desc(miss_prop))
	)
	colnames(tab) <- c("variable", names(miss_pattern)[[x]])
	return(tab)
})

## NAs: Don't know and refused
na_tab <- (temp_df
	%>% NAProps(.)
	%>% select(-miss_count)
	%>% arrange(desc(miss_prop))
	%>% rename(dontknow_refused = miss_prop)
)
miss_after_df[["dontknow_refused"]] <- na_tab

miss_after_df <- (miss_after_df
	%>% reduce(full_join, by = "variable")
	%>% mutate(NIU_dontknow_refused = NIU + dontknow_refused
		, Total = miss_impute + NIU_dontknow_refused
	)
	%>% select(-NIU, -dontknow_refused)
	%>% arrange(desc(Total))
	%>% data.frame()
)

miss_after_df <- (miss_category_summary
	%>% data.frame()
	%>% select(variable, description)
	%>% right_join(., (miss_after_df %>% mutate(variable = gsub("\\_new", "", variable)))
		, by = "variable"
	)
	%>% data.frame()
)

miss_out <- list(miss_before_df = miss_before_df
	, miss_after_df = miss_after_df
)

## Save .xlsx copy
xlsxSave(miss_out, colNames = TRUE)

saveVars(miss_before_df
	, miss_after_df
	, miss_df_temp
	, miss_category_summary
	, tab_intperyear
	, working_df
)
