#### ---- Functions for labeling effect plots  ----

### Add plogis labels
logist_format <- function() {
	function(x) round(plogis(x), 3)
}

### Add variable level p-values
sigName <- function(sigDF, varname){
	P <- sigDF[varname, "Pr..Chisq."]
	Pstr <- sprintf("(P=%5.3f)", P)
	Pstr <- sub("=0.000", "<0.001", Pstr)
	varname <- paste(varname, Pstr)
	if(P<0.05) varname <- paste(varname, "*", sep="")
	if(P<0.01) varname <- paste(varname, "*", sep="")
	return(varname)
}

saveEnvironment()
