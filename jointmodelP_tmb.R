library(shellpipes)
library(glmmTMB)

commandEnvironments()

## Fit glmtmb model
jointmodelP_tmb <- glmmTMB(model_form_joint
	, data = model_df
	, family = binomial(link = "logit")
)
summary(jointmodelP_tmb)

saveVars(jointmodelP_tmb
	, model_df
	, model_form_joint
	, base_year
)


