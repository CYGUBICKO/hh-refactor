library(shellpipes)
library(factoextra)
library(ggplot2)
library(ggfortify)

commandEnvironments()

## Set ggplot theme
ggtheme()

## Variance explained plot
ownership_else_explained_plot <- fviz_screeplot(ownership_else_pca, addlabels = TRUE)
print(ownership_else_explained_plot)

## PC plots
### Drinking water
ownership_else_pc_plot <- (autoplot(ownership_else_pca
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
print(ownership_else_pc_plot)


