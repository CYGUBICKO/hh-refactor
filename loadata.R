library(shellpipes)
library(haven)
library(data.table)
library(dplyr)

commandEnvironments()

file_name <- fileSelect(exts="dta")
load_df <- loadatafun(file_name)

working_df <- load_df[["working_df"]]
codebook <- load_df[["codebook"]]


#### ---- 1. Shorten variable names ----
## Remove hha_*

old_names <- colnames(working_df)
new_names <- gsub("(?!.^hhid.$)(hhh_*|hha_*)", "", old_names, perl = TRUE)
working_df <- (working_df
	%>% setnames(old_names, new_names)
)

codebook <- (codebook
	%>% mutate(variable = gsub("(?!.^hhid.$)(hhh_*|hha_*)", "", variable, perl = TRUE))
)

head(working_df)

saveVars(working_df, codebook)
