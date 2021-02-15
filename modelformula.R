library(shellpipes)

## Variables in the data
#	+ watersource
#	+ watersourceP
#	+ toilettype
#	+ toilettypeP
#	+ garbagedposal
#	+ garbagedposalP
#	+ age
#	+ age_scaled
#	+ log_hhsize
#	+ hhsize
#	+ hhsize_scaled
#	+ year
#	+ year_scaled
#	+ gender
#	+ slumarea
#	+ selfrating
#	+ selfrating_scaled
#	+ shocks_ever_bin
#	+ shocks_scaled
#	+ materials
#	+ ownhere
#	+ ownelse
#	+ expenditure
#	+ expenditure_scaled
#	+ income
#	+ foodeaten
#	+ rentorown
#	+ hhid

## Fixed effects
fixed_effects <- paste0(c("age_scaled"
		, "log_hhsize"
		, "year"
		, "gender"
		, "slumarea"
		, "selfrating_scaled"
		, "shocks_ever_bin"
		, "materials"
		, "ownhere"
		, "ownelse"
		, "expenditure_scaled"
		, "income"
		, "foodeaten"
		, "rentorown"
	)
	, collapse = "+"
)

## Random effects
rand_effects <- "(1|hhid) + (1|year)"

## Water services
model_form_water <- as.formula(paste0("watersource ~ ", fixed_effects, "+", "watersourceP", "+", rand_effects))
print(model_form_water)

## Toilet type
model_form_toilet <- as.formula(paste0("toilettype ~ ", fixed_effects, "+", "toilettypeP", "+", rand_effects))
print(model_form_toilet)

## Garbage collection
model_form_garbage <- as.formula(paste0("garbagedposal ~ ", fixed_effects, "+", "garbagedposalP", "+", rand_effects))
print(model_form_garbage)

saveVars(model_form_water
	, model_form_toilet
	, model_form_garbage
)

