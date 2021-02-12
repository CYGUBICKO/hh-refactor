library(shellpipes)
library(dplyr)
library(data.table)

commandEnvironments()

## Dwelling data
dwelling_df <- (working_df_complete
	%>% select(!!dwelling_group_vars)
	%>% mutate_all(as.numeric)
	%>% mutate_at(colnames(.), function(x){drop(scale(x))})
	%>% setnames(., old = dwelling_group_vars, gsub("\\_new", "", dwelling_group_vars))
	%>% select(-roofmaterial, -cookingfuel)
	%>% data.frame()
)
head(dwelling_df)

dwelling_pca <- prcomp(dwelling_df, center = TRUE, scale. = TRUE)
loadings <- dwelling_pca$rotation[, 1]
#if(min(sign(loadings)) != max(sign(loadings))){
#	stop("PC1 is not a positively signed index")
#}
#dwelling_index <- dwelling_pca$x[, 1]*max(sign(loadings))
dwelling_index <- dwelling_pca$x[, 1]

saveVars(dwelling_index
	, dwelling_pca
)

