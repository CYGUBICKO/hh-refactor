library(shellpipes)
library(dplyr)
library(data.table)

commandEnvironments()

## Key variables
response_vars <- c("drinkwatersource_new", "toilet_5plusyrs_new", "garbagedisposal_new")
demographic_vars <- c("hhid_anon_new", "intvwyear_new", "slumarea_new"
	, "gender_new", "ageyears_new", "numpeople_total_new"
)
other_vars <- c("inc30days_total_new", "foodeaten30days_new", "selfrating_new"
	, "shocks_ever_bin", "rentorown_new"
)
indices_vars <- c("materials", "ownhere", "ownelse", "shocks", "shocks_ever", "total_expenditure")
temp_vars <- c(demographic_vars, response_vars, indices_vars, other_vars)

## Select variables for analysis
wash_df <- (working_df_complete
	%>% mutate(materials = drop(dwelling_index)
		, ownhere = drop(ownership_here_index)
		, ownelse = drop(ownership_else_index)
	)
	%>% select(!!temp_vars)
	%>% setnames(., old = temp_vars, new = gsub("\\_new", "", temp_vars))
	%>% ungroup()
	%>% data.frame()
)

head(wash_df)

## Check
sapply(wash_df[,c("drinkwatersource", "toilet_5plusyrs", "garbagedisposal")], table)

### Additional variable names cleaning
base_year <- min(as.numeric(as.character(wash_df$intvwyear)))-1
print(base_year)

wash_df <- (wash_df
	%>% setnames(names(.), gsub(".*_hh|.*hhd|_anon|is|intvw|years|drink", "", names(.)))
	%>% setnames(old = c("numpeople_total", "toilet_5plusyrs", "inc30days_total", "foodeaten30days", "total_expenditure")
		, new = c("hhsize", "toilettype", "income", "foodeaten", "expenditure")
	)
	%>% mutate(year = as.numeric(as.character(year)) - base_year
		, hhsize_scaled = drop(scale(hhsize))
		, log_hhsize = log(hhsize)
		, year_scaled = drop(scale(year))
		, age_scaled = drop(scale(age))
		, selfrating_scaled = drop(scale(selfrating))
		, shocks_scaled = drop(scale(shocks))
		, expenditure_scaled = drop(scale(expenditure))
		, income_scaled = drop(scale(income))
		, intid = 1:nrow(.)
	)
	%>% mutate_at(c("watersource", "toilettype", "garbagedposal"), function(x){
		as.numeric(ifelse(x=="Improved", 1, ifelse(x=="Unimproved", 0, x)))
	})
)

##
nrow(wash_df)
max(wash_df$intid)

## Confirm tallies with above
sapply(wash_df[,c("watersource", "toilettype", "garbagedposal")], table)

saveVars(wash_df, base_year)
