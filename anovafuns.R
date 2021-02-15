## Clean term names of an Anova object
parseAnova <- function(object, pattern = ".*\\:|.*\\(|\\,.*|\\).*", model = NULL) {
	out <- data.frame(object)
	rownames(out) <- gsub(pattern, "", rownames(out))
	out$vars <- rownames(out)
	if (!is.null(out)) out$model <- model
	return(out)
}

saveEnvironment()
