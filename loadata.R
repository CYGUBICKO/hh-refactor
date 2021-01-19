library(shellpipes)
library(data.table)
library(dplyr)

sourceFiles()

# This script uses the loadatafun function to generate .rds file.

df_name <- "NUHDSS_hhamenitiescharacteristics_anon"
file_extension <- "dta"
df_folder <- "data"
df_outname <- "hh_working_df"

load_df <- loadatafun(df_name
	, file_extension
  	, df_folder
  	, df_outname
)

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
