library(shellpipes)
library(glmmTMB)

commandEnvironments()

## Fit glmtmb model
toiletP_tmb <- glmmTMB(model_form_toilet
	, data = model_df
	, family = binomial(link = "logit")
)
summary(toiletP_tmb)

saveVars(toiletP_tmb
	, model_df
	, model_form_toilet
	, base_year
)


