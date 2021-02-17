library(shellpipes)
library(dplyr)
library(ggplot2)

commandEnvironments()

ggtheme()

## Combine anova data with coefs for variable p-value
var_pattern <- unique(anovaP_df$vars)
var_pattern <- paste0(var_pattern, collapse = "|")
var_pattern

coefsP_df <- (coefsP_df
	%>% filter(effect != "ran_pars")
	%>% mutate(term2 = ifelse(grepl("StatusP", term), "StatusP", as.character(parameter))
		, vars1 = gsub(".*\\:|.*\\(|\\,.*|\\).*", "", term)
		, vars = gsub(var_pattern, "", vars1)
		, vars = ifelse(vars=="", vars1, stringr::str_remove(term2, vars))
	)
	%>% left_join(anovaP_df, by = c("model", "vars"))
	%>% mutate(ll = sprintf("(P=%5.3f)", `Pr..Chisq.`)
		, ll = sub("=0.000", "<0.001", ll)
		, ll = paste(model, ll)
		, ll = ifelse(`Pr..Chisq.` < 0.05, paste(ll, "*", sep="")
			, ifelse(`Pr..Chisq.` < 0.01, paste(ll, "*", sep="")
				, ll
			)
		)
		, model = ifelse(!is.na(ll), ll, model)
	)
	%>% select(-vars1, -ll)
	%>% data.frame()
)
head(coefsP_df)

## All effect plots
pred_names <- unique(coefsP_df$term2)
names(pred_names) <- pred_names

effectsizeP_plots <- lapply(pred_names, function(x){
	dd <- (coefsP_df
		%>% filter(term2 == x)
	)
	plotEsize(dd, x)
})
effectsizeP_plots

saveVars(effectsizeP_plots)

