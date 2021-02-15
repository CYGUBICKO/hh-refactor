library(shellpipes)
library(dplyr)

commandEnvironments()

## Restructure the data to have the services in current and previous year in a row per hhid

prevdat <- (wash_df
	%>% transmute(hhid = hhid
		, year = year + 1
		, watersourceP = watersource
		, toilettypeP = toilettype
		, garbagedposalP = garbagedposal
	)
)

lagged_df <- (wash_df
	%>% left_join(prevdat, by = c("hhid", "year"))
	%>% group_by(hhid)
	%>% mutate(n = n()
		, nprev_miss1 = sum(is.na(watersourceP))
	)
	%>% ungroup()
	%>% mutate(hhid = as.factor(hhid))
	%>% data.frame()
)
head(lagged_df, n = 50)

saveVars(lagged_df
	, wash_df
	, base_year
)

