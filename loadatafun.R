library(shellpipes)

## Load data function

# The function loads the raw data, extracts codebook and save the
# This is done only once, unless there is a change in raw data.

## * df_name: Name of the data file with the extension (.dta)

loadatafun <- function(df_name = df_name){
	hh_df <- read_dta(df_name)
	# Extract value labels
	val_labels <- AtribLst(hh_df, attrC="labels", isNullC=NA)
	val_labels <- val_labels[!is.na(val_labels)]
	# Extract varaible labels
	var_labels <- AtribLst(hh_df, attrC="label", isNullC="")

	# Generate codebook from attributes
	codebook <- (var_labels 
		%>% reshape2::melt()
		%>% rename(description = value, variable = L1)
		%>% select(variable, description)
		%>% mutate(description = ifelse(description == ""|is.na(description)
			, as.character(variable)
			, as.character(description))
		)
	)

	## Convert values to labels
	working_df <- (hh_df
		%>% as_factor()
		%>% as_tibble()
		%>% droplevels()
	)
	out <- list(working_df = working_df, codebook = codebook) 
	return(out)
}

## Extract codebook

ColAttr <- function(x, attrC, ifIsNull) {
	# Returns column attribute named in attrC, if present, else isNullC.
  	atr <- attr(x, attrC, exact = TRUE)
  	atr <- if (is.null(atr)) {ifIsNull} else {atr}
  	atr
}

AtribLst <- function(df, attrC, isNullC){
  	# Returns list of values of the col attribute attrC, if present, else isNullC
	lapply(df, ColAttr, attrC=attrC, ifIsNull=isNullC)
}

saveVars(loadatafun
	, ColAttr
	, AtribLst
)

