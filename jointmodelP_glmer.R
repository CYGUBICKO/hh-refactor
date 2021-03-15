library(shellpipes)
library(lme4)

commandEnvironments()

## Fit glmer model
jointmodelP_glmer <- glmer(model_form_joint
	, data = model_df
	, contrasts = list(services="contr.sum")
	, family = binomial(link = "logit")
	, control = glmerControl(optimizer="bobyqa"
		, check.nobs.vs.nlev="ignore"
		, check.nobs.vs.nRE="ignore"
	)
)
warnings()
summary(jointmodelP_glmer)
saveVars(jointmodelP_glmer
	, model_df
	, model_form_joint
	, base_year
)


