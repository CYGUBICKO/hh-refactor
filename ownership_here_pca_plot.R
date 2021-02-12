library(shellpipes)
library(factoextra)
library(ggplot2)
library(ggfortify)

commandEnvironments()

## Set ggplot theme
ggtheme()

## Variance explained plot
ownership_here_explained_plot <- fviz_screeplot(ownership_here_pca, addlabels = TRUE)
print(ownership_here_explained_plot)

## PC plots
### Drinking water
ownership_here_pc_plot <- (autoplot(ownership_here_pca
		, alpha = 0.2
		, shape = FALSE
		, label = FALSE
		, frame = TRUE
		, frame.type = 'norm'
		, frame.alpha = 0.1
		, show.legend = FALSE
		, loadings = TRUE
		, loadings.colour = "gray"
		, loadings.label.size = 3
		, loadings.label.repel = TRUE
	)
	+ geom_vline(xintercept = 0, lty = 2, colour = "gray")
	+ geom_hline(yintercept = 0, lty = 2, colour = "gray")
)
print(ownership_here_pc_plot)


