library(shellpipes)
library(dplyr)
library(data.table)

commandEnvironments()

## Dwelling data
ownhere_vars <- grep("ownhere", ownership_group_vars, value = TRUE)
ownership_here_df <- (working_df_complete
	%>% select(!!ownhere_vars)
	%>% mutate_at(colnames(.), function(x){
		x = ifelse(x=="yes", 1, ifelse(x=="no", 0, x))
	})
	%>% mutate_at(colnames(.), function(x){drop(scale(x))})
	%>% setnames(., old = ownhere_vars, gsub("\\_new", "", ownhere_vars))
	%>% data.frame()
)

head(ownership_here_df)

ownership_here_pca <- prcomp(ownership_here_df, center = TRUE, scale. = TRUE)
ownership_here_index <- ownership_here_pca$x[,1]

saveVars(ownership_here_pca
	, ownership_here_index
)

