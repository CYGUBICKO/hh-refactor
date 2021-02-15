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

statusP_vars <- c("watersourceP", "toilettypeP", "garbagedposalP")

lagged_df <- (lagged_df
	%>% group_by(hhid)
	%>% mutate(watersourceP = ifelse(year==min(year), "Base year", watersourceP)
			, toilettypeP = ifelse(year==min(year), "Base year", toilettypeP)
			, garbagedposalP = ifelse(year==min(year), "Base year", garbagedposalP)
	)
	%>% ungroup()
	%>% mutate_at(statusP_vars, statusPfunc)
	%>% data.frame()
)

head(lagged_df, n = 50)

## Key variables put in categories

saveVars(lagged_df
	, wash_df
	, base_year
)

