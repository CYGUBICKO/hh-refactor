library(shellpipes)
library(dplyr)

commandEnvironments()

## Completed surveys
complete_status <- "completed"

## Drop early years missing some key variables
years_drop <- c("2002", "2003", "2004", "2005")

## Keep last interview in case there are more than one interview
keep_n <- 1

saveVars(complete_status
	, years_drop
	, keep_n
)
