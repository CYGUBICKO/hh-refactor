library(shellpipes)
library(ggplot2)
library(vareffects)
varefftheme()

commandEnvironments()

garbageP_tmb_varpred_plots <- lapply(garbageP_pred_vars, function(x){
	dd <- garbageP_varpred_df[[x]]
	p1 <- plot(dd, xlabs = sigName(garbageP_tmb_anova, x))
	p1 <- (p1 
		+ labs(y = "Probability of\nimproved garbage collection")
	)
	return(p1)
})

print(garbageP_tmb_varpred_plots)

saveVars(garbageP_tmb_varpred_plots)

