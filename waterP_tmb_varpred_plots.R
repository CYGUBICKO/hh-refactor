library(shellpipes)
library(ggplot2)
library(vareffects)
varefftheme()

commandEnvironments()

waterP_tmb_varpred_plots <- lapply(waterP_pred_vars, function(x){
	dd <- waterP_varpred_df[[x]]
	p1 <- plot(dd, xlabs = sigName(waterP_tmb_anova, x))
	p1 <- (p1 
		+ labs(y = "Probability of\nimproved water services")
	)
	return(p1)
})

print(waterP_tmb_varpred_plots)

saveVars(waterP_tmb_varpred_plots)

