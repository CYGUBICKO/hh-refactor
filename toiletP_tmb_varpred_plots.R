library(shellpipes)
library(ggplot2)
library(jdeffects)
jdtheme()

commandEnvironments()

toiletP_tmb_varpred_plots <- lapply(toiletP_pred_vars, function(x){
	dd <- toiletP_varpred_df[[x]]
	p1 <- plot(dd, xlabs = sigName(toiletP_tmb_anova, x))
	p1 <- (p1 
		+ scale_y_continuous(labels = logist_format())
		+ labs(y = "Probability of\nimproved toilet facilities")
	)
	return(p1)
})

print(toiletP_tmb_varpred_plots)

saveVars(toiletP_tmb_varpred_plots)

