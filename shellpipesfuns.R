#' Save a single table or a list of tables to excel
#' @param object a variable or a list of variables to save
#' @param target stem of file to save to (defaults to name from call)
#' @param ext file extension (default .Rout.xlsx)
#' @param ... optional parameters to pass to \code{openxlsx::write.xlsx}
#' @export
xlsxSave <- function(object, target = targetname(), ext="Rout.xlsx", ...){
	openxlsx::write.xlsx(x = object, file=paste(target, ext, sep="."), ...)
}

saveEnvironment()
