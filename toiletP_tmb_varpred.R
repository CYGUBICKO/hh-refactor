library(shellpipes)
library(glmmTMB)
library(jdeffects)
jdtheme()

commandEnvironments()

## Model
mod <- toiletP_tmb

## Clean predictor names
toiletP_pred_vars <- all.vars(parse(text=attr(delete.response(terms(mod)), "term.labels")))
print(toiletP_pred_vars)


## Compute predictions

toiletP_varpred_df <- sapply(toiletP_pred_vars, function(x){
	pred <- varpred(mod, x, internal = TRUE, isolate=TRUE)
	return(pred)
}, simplify=FALSE)

saveVars(toiletP_pred_vars
	, toiletP_varpred_df
)
