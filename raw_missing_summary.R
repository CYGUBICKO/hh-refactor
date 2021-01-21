library(shellpipes)
library(purrr)
library(dplyr)
library(tibble)

commandEnvironments()

#### ---- Missing per missing value indicator ----
miss_pattern <- list(miss_impute = "^missing\\:impute"
	, refused = "^refused"
	, dont_know = "^Don\\'t know"
	, NIU = "^NIU"
)
miss_category_summary <- lapply(seq_along(miss_pattern), function(x){
	tab <- missPattern(working_df, miss_pattern[[x]])
	tab <- (tab
		%>% select(-miss_count)
		%>% arrange(desc(miss_prop))
	)
	colnames(tab) <- c("variable", names(miss_pattern)[[x]])
	return(tab)
})

## NAs
na_tab <- (working_df 
	%>% NAProps(.)
	%>% select(-miss_count)
	%>% arrange(desc(miss_prop))
	%>% rename(NAs = miss_prop)
)
miss_category_summary[["NAs"]] <- na_tab

miss_category_summary <- (miss_category_summary 
	%>% reduce(full_join, by = "variable")
)
miss_category_summary <- (codebook
	%>% full_join(miss_category_summary, by = "variable")
	%>% rowwise()
	%>% mutate(Total = sum(miss_impute, refused, dont_know, NIU, NAs, na.rm = TRUE))
	%>% arrange(desc(Total))
)
print(miss_category_summary)

saveVars(miss_category_summary
	, tab_intperyear
)

