library(shellpipes)
library(dplyr)
library(data.table)

commandEnvironments()

## Dwelling data
ownership_df <- (working_df_complete
	%>% select(!!ownership_group_vars)
	%>% mutate_at(colnames(.), function(x){
		x = ifelse(x=="yes", 1, ifelse(x=="no", 0, x))
	})
	%>% mutate_at(colnames(.), function(x){drop(scale(x))})
	%>% setnames(., old = ownership_group_vars, gsub("\\_new", "", ownership_group_vars))
	%>% data.frame()
)

head(ownership_df)

quit()
ownership_pca <- prcomp(ownership_df, center = TRUE, scale. = TRUE)
ownership_pc_df <- summary(ownership_pca)$x
ownership_index <- drop(ownership_pc_df[,1:2])


