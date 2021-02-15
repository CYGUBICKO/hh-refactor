library(shellpipes)
library(dplyr)
library(data.table)

commandEnvironments()

## Dwelling data
ownelse_vars <- grep("ownelse", ownership_group_vars, value = TRUE)
ownership_else_df <- (working_df_complete
	%>% select(!!ownelse_vars)
	%>% mutate_at(colnames(.), function(x){
		x = ifelse(x=="yes", 1, ifelse(x=="no", 0, x))
	})
	%>% mutate_at(colnames(.), function(x){drop(scale(x))})
	%>% setnames(., old = ownelse_vars, gsub("\\_new", "", ownelse_vars))
	%>% data.frame()
)

head(ownership_else_df)

ownership_else_pca <- prcomp(ownership_else_df, center = TRUE, scale. = TRUE)
ownership_else_index <- ownership_else_pca$x[,1]

saveVars(ownership_else_pca
	, ownership_else_index
)

