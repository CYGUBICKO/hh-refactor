library(shellpipes)
library(ggplot2)
library(patchwork)

commandEnvironments()

ggtheme()

## garbage
garbageP <- garbageP_tmb_varpred_plots 

## water
waterP <- waterP_tmb_varpred_plots

## toilet
toiletP <- toiletP_tmb_varpred_plots

nplots <- length(garbageP)
all_services_varpred_plots <- lapply(1:nplots, function(i){
	p <- ((garbageP[[i]] + labs(title = "garbage") + theme(legend.position = "none")) 
		+ (waterP[[i]] + labs(title = "water")) 
		+ (toiletP[[i]] + labs(y = "", title = "toilet") + theme(legend.position = "none")) 
		+ plot_layout(nrow = 2, byrow = FALSE)
	)
	return(p)
})
print(all_services_varpred_plots)

saveVars(all_services_varpred_plots)
