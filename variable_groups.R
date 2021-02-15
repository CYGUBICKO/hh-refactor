library(shellpipes)
library(dplyr)

commandEnvironments()

# All variables
all_vars <- colnames(working_df)

## Dwelling
dwelling_group_vars <- c("floormaterial", "roofmaterial"
	, "wallmaterial", "cookingfuel", "lighting"
)
dwelling_group_vars <- paste0(dwelling_group_vars, "_new")

## Ownership
ownership_group_vars <- grep("^ownhere\\_|^ownelse\\_|^own\\_|^grewcrops\\_", all_vars, value = TRUE)

## Expenditure
expenditure_group_vars <- grep("^expend\\_", all_vars, value = TRUE)

## Problems experienced
problems_group_vars <- grep("^numprob\\_", all_vars, value = TRUE)

## Problems ever experienced
problems_ever_group_vars <- grep("^prob\\_", all_vars, value = TRUE)
problems_ever_group_vars

# Summary of groups
#ignore_vars <- c("ownlivestock_new", grep("^prob\\_", colnames(working_df), value = TRUE))
ignore_vars <- "ownlivestock_new"
var_groups_df <- (data.frame(variable = colnames(working_df)[!colnames(working_df) %in% ignore_vars])
	%>% mutate(group = ifelse(variable %in% ownership_group_vars, "Ownership"
			, ifelse(variable %in% expenditure_group_vars, "Expenditure"
				, ifelse(variable %in% problems_group_vars, "Shocks/problems"
					, ifelse(variable %in% dwelling_group_vars, "Dwelling"
						, ifelse(grepl("^drinkwatersource|^toilet|^garbaged", variable), "Response"
							, ifelse(grepl("^slumarea|^ageyears|^gender|^numpeople|^intvwyear", variable), "Demographic"
								, ifelse(variable %in% problems_ever_group_vars, "Shocks/probles ever", as.character(variable)))))
				)
			)
		)
		, group = ifelse(grepl("^hhid_anon", group), "id"
			, ifelse(grepl("^foodeaten30days", group), "Food consumption"
				, ifelse(grepl("^inc30days_total", group), "Income"
					, ifelse(grepl("^selfrating", group), "Selff rating",  as.character(group))))
		)
		, variable = gsub("\\_new", "", variable)
	)
	%>% left_join(miss_after_df, by = "variable")
)
head(var_groups_df, 200)

## Factor the binary variables and count the number of NAs per case
working_df <- (working_df
	%>% mutate_at(c(ownership_group_vars, problems_group_vars), as.factor)
	%>% mutate(totalNA = round(rowSums(is.na(.)|.=="missing:impute"|.==999999|.==9999995|.=="9999995"|.=="999999")/ncol(.) * 100, 3))
)

miss_percase_df <- as.data.frame(table(working_df$totalNA))
head(miss_percase_df)

miss_peryear_df <- table(working_df$totalNA, working_df$intvwyear_new)
head(miss_peryear_df)

analysis_vars <- gsub("\\_new.*", "", all_vars)
miss_category_summary_df <- (miss_category_summary
	%>% data.frame()
	%>% filter(variable %in% analysis_vars)
)


## Save variable descriptions
xlsxSave(var_groups_df)
saveVars(var_groups_df
	, working_df
	, dwelling_group_vars
	, ownership_group_vars
	, expenditure_group_vars
	, problems_group_vars
	, problems_ever_group_vars
	, miss_percase_df
	, miss_peryear_df
	, tab_intperyear
	, miss_category_summary_df
)

