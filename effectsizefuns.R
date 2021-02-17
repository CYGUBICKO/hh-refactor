### Function to plot for different model classes i.e., glm and glmer
plotEsize <- function(df, col_lab = ""){
	estimates_df <- df
	parameters <- pull(estimates_df, parameter) %>% unique()
	estimates_df <- (estimates_df
		%>% mutate(parameter = factor(parameter, levels = parameters, labels = parameters))
	)
	pos <- ggstance::position_dodgev(height=0.5)
	p1 <- (ggplot(estimates_df, aes(x = estimate, y = model, colour = parameter))
		+ geom_point(position = pos)
		+ ggstance::geom_linerangeh(aes(xmin = conf.low, xmax = conf.high), position = pos)
		+ scale_colour_brewer(palette="Dark2"
			, guide = guide_legend(reverse = TRUE)
		)
		+ geom_vline(xintercept=0,lty=2)
		+ labs(x = "Estimate"
			, y = ""
			, colour = col_lab
		)
		+ facet_wrap(~term, scale = "free_x")
		+ theme(legend.position = "bottom")
	)
	return(p1)
}

saveEnvironment()
