library(shellpipes)
library(dplyr)

commandEnvironments()

# Recode cases with missing previous to
## 1. Base year: status of service in the first HH year
## 2. Not observed: immediate preceding year not observed
## 3. Unimproved: Observed but unimproved service
## 4. Improved: Observed improved service

statusPfunc <- function(x){
	x <- ifelse(is.na(x), "Not observed"
		, ifelse(x==0, "Unimproved"
			, ifelse(x==1, "Improved", x)
		)
	)
}

## Restructure the data to have the services in current and previous year in a row per hhid

prevdat <- (long_df
	%>% transmute(hhid = hhid
		, services = services
		, year = year + 1
		, statusP = status
	)
)

lagged_df <- (long_df
	%>% left_join(prevdat, by = c("hhid", "year", "services"))
	%>% group_by(hhid)
	%>% mutate(statusP = ifelse(year==min(year), "Base year", statusP)
		, f_year = as.factor(year)
		, hhid = as.factor(hhid)
		, services = as.factor(services)
	)
	%>% ungroup()
	%>% mutate_at("statusP", statusPfunc)
	%>% data.frame()
)

dim(long_df)
dim(lagged_df)

## Check 
check_df <- (lagged_df
	%>% select(!!c("hhid", "intid", "year", "services", "status", "statusP"))
	%>% mutate(hhid = as.numeric(hhid))
	%>% head(n=50)
)
print(check_df)

saveVars(lagged_df
	, long_df
	, base_year
)

