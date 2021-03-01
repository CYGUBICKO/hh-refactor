library(shellpipes)
library(glmmTMB)
library(vareffects)

commandEnvironments()

## Model
mod <- garbageP_tmb

## Clean predictor names
garbageP_pred_vars <- all.vars(parse(text=attr(delete.response(terms(mod)), "term.labels")))
print(garbageP_pred_vars)


## Compute predictions

garbageP_varpred_df <- sapply(garbageP_pred_vars, function(x){
	pred <- varpred(mod, x, internal = TRUE, isolate=TRUE)
	return(pred)
}, simplify=FALSE)

saveVars(garbageP_pred_vars
	, garbageP_varpred_df
)
