library(shellpipes)
library(haven)
library(data.table)
library(dplyr)

hh_df <- read_dta(fileSelect(exts="dta"))

summary(hh_df) 
