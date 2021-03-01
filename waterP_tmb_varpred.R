library(shellpipes)
library(glmmTMB)
library(vareffects)

commandEnvironments()

## Model
mod <- waterP_tmb

## Clean predictor names
waterP_pred_vars <- all.vars(parse(text=attr(delete.response(terms(mod)), "term.labels")))
print(waterP_pred_vars)


## Compute predictions

waterP_varpred_df <- sapply(waterP_pred_vars, function(x){
	pred <- varpred(mod, x, internal = TRUE, isolate=TRUE)
	return(pred)
}, simplify=FALSE)

saveVars(waterP_pred_vars
	, waterP_varpred_df
)
