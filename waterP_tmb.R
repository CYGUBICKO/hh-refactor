library(shellpipes)
library(glmmTMB)

commandEnvironments()

## Fit glmtmb model
waterP_tmb <- glmmTMB(model_form_water
	, data = model_df
	, family = binomial(link = "logit")
)
summary(waterP_tmb)

saveVars(waterP_tmb
	, model_df
	, model_form_water
	, base_year
)


