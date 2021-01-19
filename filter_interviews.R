library(shellpipes)
library(dplyr)

commandEnvironments()
sourceFiles()

working_df <- (working_df
	%>% filter(intvwresult==complete_status & (!intvwyear %in% years_drop))
	%>% group_by(hhid_anon, intvwyear)
	%>% mutate(nn = n()
		, intvwdate = as.Date(intvwdate)
		, keep = ifelse(nn==keep_n|intvwdate==max(intvwdate), 1, 0)
	)
	%>% ungroup()
)

str(working_df)
