library(shellpipes)
library(glmmTMB)
library(purrr)
library(dplyr)
library(tidyr)
library(broom.mixed)

commandEnvironments()

coefsP_df <- (map(list(waterP = waterP_tmb, garbageP = garbageP_tmb, toiletP = toiletP_tmb)
		, tidy
		, conf.int = TRUE
	)
	%>% bind_rows(.id = "model")
	%>% dotwhisker::by_2sd(model_df)
	%>% mutate(term = factor(term, levels = unique(term))
		, parameter = term
		, parameter = gsub(".*\\(|\\).*|\\,.*", "", parameter)
		, parameter_new = ifelse(parameter == "Intercept", "Intercept", "Coefs")
		, term = ifelse(grepl("PImproved|PNot observed|PUnimproved", term), "StatusP", as.character(term))
		, parameter = gsub("watersourceP|garbagedposalP|toilettypeP", "", parameter)
	)
	%>% mutate(term = reorder(term, estimate))
)

print(coefsP_df, n = Inf, width = Inf)

saveVars(coefsP_df)
