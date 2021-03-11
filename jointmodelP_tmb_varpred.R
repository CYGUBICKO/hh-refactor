library(shellpipes)
library(glmmTMB)
library(vareffects)
varefftheme()

commandEnvironments()

## Model
mod <- jointmodelP_tmb

## Clean predictor names
jointmodelP_pred_vars <- all.vars(parse(text=attr(delete.response(terms(mod)), "term.labels")))
jointmodelP_pred_vars <- jointmodelP_pred_vars[!jointmodelP_pred_vars %in% "services"]
print(jointmodelP_pred_vars)

## Compute predictions

jointmodelP_varpred_df <- sapply(jointmodelP_pred_vars, function(x){
	pred <- varpred(mod, c("services", x), x.var = x, isolate=TRUE, vcov.=zero_vcov(mod, x))
	print(plot(pred, facet_scales="free", facet_ncol=2))
#	return(pred)
}, simplify=FALSE)

