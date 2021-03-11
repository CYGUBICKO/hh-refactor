library(shellpipes)

commandEnvironments()

model_df <- model.frame(
	~ watersource
	+ watersourceP
	+ toilettype
	+ toilettypeP
	+ garbagedposal
	+ garbagedposalP
	+ age
	+ age_scaled
	+ hhsize
	+ log_hhsize
	+ hhsize_scaled
	+ year
	+ year_scaled
	+ gender
	+ slumarea
	+ selfrating
	+ selfrating_scaled
	+ shocks_ever_bin
	+ shocks_scaled
	+ materials
	+ ownhere
	+ ownelse
	+ expenditure
	+ expenditure_scaled
	+ income
	+ foodeaten
	+ rentorown
	+ hhid
	+ intid
	, data = lagged_df, na.action = na.exclude, drop.unused.levels = TRUE
)
head(model_df)

saveVars(model_df, base_year)
