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

## More than 1 HH interview per year
tab_intperyear <- as.data.frame(table(working_df$nn))
print(tab_intperyear)

## Keep latest interview per HH per year
working_df <- (working_df
	%>% filter(keep==keep_n)
	%>% select(-nn, -keep)
)

head(working_df)

saveVars(working_df
	, codebook
	, tab_intperyear
)
