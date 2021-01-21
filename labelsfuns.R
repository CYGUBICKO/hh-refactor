library(shellpipes)

### ---- Generate labels codebook ----

## oldpatterns: exact old label or grep-like pattern within each group. Similar cats are separated by | 
## Details: oldpatterns and newlabs are in the same order

genLabels <- function(df, var, oldpatterns, newlabs){
	lab_df <- data.frame(oldlabs = unique(df[[var]]), newlabs = unique(df[[var]]))
	for (p in seq_along(oldpatterns)){
		lab_df[["newlabs"]] <- ifelse(grepl(oldpatterns[[p]],  lab_df[["oldlabs"]])
			, newlabs[[p]]
			, as.character(lab_df[["newlabs"]])
		)
	}
	colnames(lab_df) <- c(var, paste0(var, "_new"))
	return(lab_df)
}


saveVars(genLabels)
