library(shellpipes)
library(glmmTMB)

commandEnvironments()

## Fit glmtmb model
garbageP_tmb <- glmmTMB(model_form_garbage
	, data = model_df
	, family = binomial(link = "logit")
)
summary(garbageP_tmb)

saveVars(garbageP_tmb
	, model_df
	, model_form_garbage
	, base_year
)


