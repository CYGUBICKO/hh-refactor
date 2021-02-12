library(shellpipes)
library(stringr)
library(tidyr)
library(dplyr)
library(scales)
library(forcats)
library(ggplot2)
library(patchwork)

commandEnvironments()

## Set ggplot theme
ggtheme()

#### ---- Data ----
## No. of hh
nhhid <- length(unique(working_df_complete$hhid))
## No. of interviews
nint_all <- nrow(working_df_complete)

#### ---- Descriptives ----

## Interviews per year
desc_year_plot <- simplePlot(working_df_complete
	, variable = "intvwyear_new"
	, show_percent_labels = FALSE
	, title = "Interview year"
	, sort_x = FALSE
)

## slumarea
desc_slumarea_plot <- simplePlot(working_df_complete
	, variable = "slumarea_new"
	, show_percent_labels = FALSE
	, title = "Slum area"
)

## gender
desc_gender_plot <- simplePlot(working_df_complete
	, variable = "gender_new"
	, show_percent_labels = FALSE
	, title = "Gender"
)

## Age
desc_age_plot <- simplePlot(working_df_complete
	, variable = "ageyears_new"
	, show_percent_labels = FALSE
	, title = "Age"
)

## Number of people
desc_numpeople_plot <- simplePlot(working_df_complete
	, variable = "numpeople_total_new"
	, show_percent_labels = FALSE
	, title = "Number of people in HH"
)

## Services
services_labs <- c("Toilet" = "toilet_5plusyrs_new"
	, "Garbage" = "garbagedisposal_new"
	, "Water" = "drinkwatersource_new"
)
desc_services_plot <- multiresFunc(working_df_complete
	, var_patterns = "drinkwatersource|toilet_5plusyrs|garbagedisposal"
	, question_labels = services_labs
	, wrap_labels = 30
	, show_percent_labels = TRUE
	, xlabel = ""
	, shift_axis = FALSE
	, distinct_quiz = FALSE
	, sum_over_N = TRUE
	, title = "Improved services"
)

## Dwelling variables
dwelling_labs <- dwelling_group_vars
names(dwelling_labs) <- gsub("\\_new", "", dwelling_group_vars)
desc_dwelling_plot <- multiresFunc(working_df_complete
	, var_patterns = dwelling_group_vars
	, question_labels = dwelling_labs
	, wrap_labels = 30
	, show_percent_labels = FALSE
	, xlabel = ""
	, shift_axis = TRUE
	, distinct_quiz = TRUE
	, sum_over_N = TRUE
	, title = "Dwelling"
)

## Ownership
ownership_labs <- ownership_group_vars
names(ownership_labs) <- gsub("\\_new", "", ownership_group_vars)
desc_ownership_plot <- multiresFunc(working_df_complete
	, var_patterns = ownership_group_vars
	, question_labels = ownership_labs
	, wrap_labels = 30
	, show_percent_labels = FALSE
	, xlabel = ""
	, shift_axis = TRUE
	, distinct_quiz = TRUE
	, sum_over_N = TRUE
	, NULL_label = "no"
	, title = "Ownership"
)

## Total income
working_df_complete$inc30days_total_new <- as.factor(working_df_complete$inc30days_total_new)
desc_income_plot <- simplePlot(working_df_complete
	, variable = "inc30days_total_new"
	, show_percent_labels = TRUE
	, sort_x = FALSE
	, title = "Total income"
)

## Expenditure
expenditure_df <- (working_df_complete
	%>% select(!!expenditure_group_vars)
	%>% mutate(total_expenditure = rowSums(., na.rm = TRUE))
)

desc_expend_plot <- simplePlot(expenditure_df
	, variable = "total_expenditure"
	, show_percent_labels = FALSE
	, sort_x = FALSE
	, title = "Total expenditure"
)

### Individual expenditure
expend_df_long <- (expenditure_df
	%>% select(-total_expenditure)
	%>% gather(labels, values)
	%>% mutate(labels = gsub("expend\\_|\\_new", "", labels))
)
all_sets <- unique(gsub("expend\\_|\\_new", "", expenditure_group_vars))
set1 <- all_sets[1:9]
set1_df <- (expend_df_long
	%>% filter(labels %in% set1)
)
desc_indiv_expend_plots1 <- (ggplot(set1_df, aes(x = values))
   + geom_histogram()
	+ facet_wrap(~labels, scales = "free")
   + labs(x = "Amount", y = "")
	+ coord_flip()
)

set2 <- all_sets[10:18]
set2_df <- (expend_df_long
	%>% filter(labels %in% set2)
)
desc_indiv_expend_plots2 <- (ggplot(set2_df, aes(x = values))
   + geom_histogram()
	+ facet_wrap(~labels, scales = "free")
   + labs(x = "Amount", y = "")
	+ coord_flip()
)

## Number of problems/shocks experienced
problems_df <- (working_df_complete
	%>% select(!!problems_group_vars)
	%>% mutate_all(function(x){as.numeric(as.character(x))})
	%>% mutate(shocks = rowSums(., na.rm = TRUE))
)

desc_shocks_plot <- simplePlot(problems_df
	, variable = "shocks"
	, show_percent_labels = FALSE
	, sort_x = FALSE
	, title = "Total no. of shocks"
)

## Number of problems/shocks ever experienced
problems_ever_df <- (working_df_complete
	%>% select(!!problems_ever_group_vars)
	%>% mutate(shocks_ever = rowSums(., na.rm = TRUE))
)

desc_shocks_ever_plot <- simplePlot(problems_ever_df
	, variable = "shocks_ever"
	, show_percent_labels = FALSE
	, sort_x = FALSE
	, title = "Total no. of shocks ever"
)

## Number of shocks ever - binary
desc_shocks_ever_bin_plot <- simplePlot(working_df_complete
	, variable = "shocks_ever_bin"
	, show_percent_labels = FALSE
	, sort_x = FALSE
	, title = "Ever experienced any shock?"
)

### Individual shocks
problems_df_long <- (problems_df
	%>% select(-shocks)
	%>% gather(labels, values)
	%>% mutate(labels = gsub("numprob\\_|\\_new", "", labels))
)
desc_indiv_shocks_plots <- (ggplot(problems_df_long, aes(x = values))
   + geom_histogram()
	+ facet_wrap(~labels, scales = "free")
   + labs(x = "No. of shocks", y = "")
	+ coord_flip()
)

## Household food consumption
desc_foodeaten_plot <- simplePlot(working_df_complete
	, variable = "foodeaten30days_new"
	, show_percent_labels = FALSE
	, sort_x = FALSE
	, title = "Food eaten by your household in the last 30 days."
)

## Self rating
working_df_complete$selfrating_new <- as.factor(working_df_complete$selfrating_new)
desc_selfrating_plot <- simplePlot(working_df_complete
	, variable = "selfrating_new"
	, show_percent_labels = TRUE
	, sort_x = FALSE
	, title = "Self rating"
)

# All plots
demographic_plots1 <- (desc_services_plot/desc_numpeople_plot)
print(demographic_plots1)

demographic_plots2 <- ((desc_year_plot + desc_slumarea_plot)
	/ (desc_gender_plot + desc_age_plot)
)
print(demographic_plots2)

print(desc_dwelling_plot)
print(desc_ownership_plot)

income_expend_shock_selfrate_plot <- ((desc_income_plot + desc_expend_plot)
	/ (desc_shocks_plot + desc_selfrating_plot)
)
print(income_expend_shock_selfrate_plot)

shocks_ever_plot <- desc_shocks_ever_plot + desc_shocks_ever_bin_plot
print(shocks_ever_plot)
	
saveVars(nhhid, nint_all
	, desc_services_plot
	, desc_numpeople_plot
	, desc_year_plot
	, desc_slumarea_plot
	, desc_gender_plot
	, desc_age_plot
	, desc_dwelling_plot
	, desc_ownership_plot
	, desc_income_plot
	, desc_expend_plot
	, desc_foodeaten_plot
	, desc_shocks_ever_plot
	, desc_shocks_ever_bin_plot
	, desc_selfrating_plot
)

