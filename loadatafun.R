## Load data function

# The function loads the raw data, extracts codebook and save the a .rds file. 
# This is done only once, unless there is a change in raw data.

## * df_name: Name of the data file without the extension (.dta, .xlsx, .csv, ..., etc)
## * file_extension: File extension e.g, .xlsx, .dta
## * df_folder: Directory where raw dataset is saved (relative to the working directory) or "." if current
## * df_outname: How to save the converted data file. 
## * re_run: Logical. Whether to regenerate the .rds files or not.

loadatafun <- function(df_name = df_name
	, file_extension = file_extension
  	, df_folder = df_folder
  	, df_outname = df_outname
  	,re_run = FALSE
	){
  	files <- list.files(df_folder)
  	# Check if the .rds dataset already exists
  	if (sum(grepl(df_outname, files, ignore.case = TRUE))==0 | re_run){
    	file_extension <- gsub("\\.", "", file_extension)
    	df_path <- paste0(df_folder, "/", df_name, ".", file_extension)
    	hh_df <- read_dta(df_path)
    	# Extract value labels
    	val_labels <- AtribLst(hh_df, attrC="labels", isNullC=NA)
    	val_labels <- val_labels[!is.na(val_labels)]
    	# Extract varaible labels
		var_labels <- AtribLst(hh_df, attrC="label", isNullC="")
    
    	# Generate codebook from attributes
    	codebook <- (var_labels 
      	%>% melt()
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
    	# Save a copy of the converted datset and the codebook
    	df_outname <- paste0(
			gsub("\\.rds.*", "", df_outname)
      		, ".rds"
    	)
    	df_outpath <- paste0(df_folder, "/", df_outname)
    	codebook_outpath <- paste0(df_folder, "/", "codebook.rds")
    	saveRDS(working_df, df_outpath)
    	saveRDS(codebook, codebook_outpath)
	}
  
  	# Read data from the local folder
  	if (sum(grepl(df_outname, files, ignore.case = TRUE)) >= 1 & re_run == FALSE){
		df_outname <- paste0(
			gsub("\\.rds.*", "", df_outname)
				, ".rds"
		)
    	df_outpath <- paste0(df_folder, "/", df_outname)
    	df_loadpath <- paste0(df_folder, "/", df_outname)
    	codebook_loadpath <- paste0(df_folder, "/", "codebook.rds")
   	working_df <- readRDS(df_loadpath)
    	codebook <- readRDS(codebook_loadpath)
	}
	return(
   	list(working_df = working_df
      	, codebook = codebook
		)
	)
}

