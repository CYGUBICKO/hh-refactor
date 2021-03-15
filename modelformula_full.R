library(shellpipes)

## Variables in the data
#	+ status 
#	+ statusP
#	+ age
#	+ age_scaled
#	+ log_hhsize
#	+ hhsize
#	+ hhsize_scaled
#	+ year
#	+ f_year
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
fixed_effects <- paste0(c("-1"
		, "services"
		, "services:(age_scaled"
		, "log_hhsize"
		, "year_scaled"
		, "gender"
		, "slumarea"
		, "selfrating_scaled"
		, "shocks_ever_bin"
		, "materials"
		, "ownhere"
		, "ownelse"
		, "expenditure_scaled"
		, "income_scaled"
		, "foodeaten"
		, "rentorown"
		, "statusP)"
	)
	, collapse = "+"
)

## Random effects
# rand_effects <- "(services-1|hhid)" #+ "(services-1|intid) + (services-1|year)"
rand_effects <- "(services-1|hhid) + (services-1|year)"
model_form_joint <- as.formula(paste0("status ~ ", fixed_effects, "+", rand_effects))
print(model_form_joint)

saveVars(model_form_joint)

