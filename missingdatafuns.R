library(shellpipes)

## Missingness functions

missProp <- function(df){
	n <- nrow(df)
  	df <- as.data.frame(df)
	miss_count <- apply(df, 2
		, function(x) sum(is.na(x)|x == ""|grepl("^refuse|^NIU|^don\\'t|^missing\\:impute|999999|9999995", x, ignore.case = TRUE)))
  	miss_df <- (miss_count
    	%>% enframe(name = "variable")
    	%>% rename(miss_count = value)
    	%>% mutate(miss_prop = miss_count/n)
    	%>% mutate(miss_prop = round(miss_prop, digits = 3) * 100)
	)
}

## Pattern specific
missPattern <- function(df, pattern = "^refuse|^NIU|^don\\'t|^missing\\:impute"){
   n <- nrow(df)
   df <- as.data.frame(df)
   miss_count <- apply(df, 2
      , function(x) sum(grepl(pattern = pattern, x, ignore.case = TRUE)))
   miss_df <- (miss_count
      %>% enframe(name = "variable")
      %>% rename(miss_count = value)
      %>% mutate(miss_prop = miss_count/n)
      %>% mutate(miss_prop = round(miss_prop, digits = 3) * 100)
   )
}

## NA proportion per variable

NAProps <- function(df){
	n <- nrow(df)
  	df <- as.data.frame(df)
	miss_count <- apply(df, 2
		, function(x) sum(is.na(x)|x == ""))
  	miss_df <- (miss_count
    	%>% enframe(name = "variable")
    	%>% rename(miss_count = value)
    	%>% mutate(miss_prop = miss_count/n)
    	%>% mutate(miss_prop = round(miss_prop, digits = 3) * 100)
	)
}

## Impute missing indicator function
imputeCase <- function(df, patterns = "missing:impute"){
	apply(df, 1, function(x){
		any(x %in% patterns)
	})
}

saveVars(missProp
	, missPattern
	, NAProps
	, imputeCase
)
