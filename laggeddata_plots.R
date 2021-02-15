library(shellpipes)
library(data.table)
library(dplyr)
library(tidyr)
library(tibble)
library(scales)
library(ggplot2)

commandEnvironments()

## Set ggplot theme
ggtheme()

summaryFunc <- function(var){
	summary_df <- (wash_df
		%>% select(var, year)
		%>% rename("temp_var" = var)
		%>% group_by(year)
		%>% summarise(prop = mean(temp_var))
		%>% ungroup()
		%>% mutate(services = var, overall = mean(prop))
	)
	return(summary_df)
}


#### ---- Some summaries ----

## No. of hh
nhhid <- length(unique(wash_df$hhid))
nint_all <- nrow(wash_df)

## No. of interviews for consecutive interviews
nint_consec <- nrow(lagged_df)

## HH which had missing interviews in consecutive years

prevcases_df <- (lagged_df
	%>% group_by(hhid)
#	%>% filter(year != min(year))
	%>% mutate(nprev_miss2 = sum(is.na(watersourceP) & year != min(year)))
	%>% ungroup()
	%>% mutate_at("hhid", as.numeric)
	%>% select(hhid, year, watersource, watersourceP, n, nprev_miss1, nprev_miss2)
)
print(prevcases_df %>% arrange(desc(nprev_miss1)), n = 50, width = Inf)

### Save a summary for explannation on the rmd
prevcases_df_summary <- (prevcases_df
	%>% filter(hhid %in% c(1,818))
)
print(prevcases_df_summary)

prevcases_df <- (prevcases_df
	%>% filter(year != min(year))
	%>% select(-c("year", "watersource", "watersourceP"))
	%>% distinct()
)
print(prevcases_df, n = 50, width = Inf)

### Excluding first year interviews because no previous year anyway

summary_consec_noyr0_df <- (prevcases_df
	%>% filter(nprev_miss2 > 0)
	%>% group_by(nprev_miss2)
	%>% summarise(nn = sum(nprev_miss2))
)
summary_consec_noyr0_df

nint_noyr0 <- (lagged_df
	%>% group_by(hhid)
	%>% filter(year != min(year))
	%>% nrow()
)

percent_miss_consec_noyr0 <- percent(sum(summary_consec_noyr0_df$nn/nint_noyr0))
percent_miss_consec_noyr0

### Missing previous year percentage with all cases as the denominator
percent_miss_consec_noyr0_all <- percent(sum(summary_consec_noyr0_df$nn)/nrow(lagged_df))
percent_miss_consec_noyr0_all

## Percentage of year 1 interviews
nint_yr0 <- (lagged_df
	%>% group_by(hhid)
	%>% filter(year == min(year))
	%>% nrow()
)
nint_yr0

percent_year0 <- percent(sum(nint_yr0/nrow(lagged_df)))
percent_year0

### All missing at least one previous interviews 
summary_consec_df <- (lagged_df
	%>% ungroup()
	%>% select(hhid, n, nprev_miss1)
	%>% distinct()
)

table(summary_consec_df$nprev_miss1) # Just for check

summary_consec_df <- (summary_consec_df
	%>% group_by(nprev_miss1)
	%>% summarise(nn = sum(nprev_miss1))
)
print(summary_consec_df) # Compare with the above check

percent_miss_consec <- percent(sum(summary_consec_df$nn/nint_all))
percent_miss_consec

## Transition status (JD's Status Quo)

consec_temp_df <- (lagged_df
	%>% group_by(hhid)
	%>% filter(year != min(year))
	%>% mutate(waterSQ = case_when(watersource==0 & watersourceP==0 ~ "All -"
			, watersource==1 & watersourceP==1 ~ "All +"
			, watersourceP==1 & watersource==0 ~ "Loss"
			, watersourceP==0 & watersource==1 ~ "Gain"
			, is.na(watersourceP) & (watersource==0 | watersource==1) ~ "No prev."
		)
		, garbageSQ = case_when(garbagedposal==0 & garbagedposalP==0 ~ "All -"
			, garbagedposal==1 & garbagedposalP==1 ~ "All +"
			, garbagedposalP==1 & garbagedposal==0 ~ "Loss"
			, garbagedposalP==0 & garbagedposal==1 ~ "Gain"
			, is.na(garbagedposalP) & (garbagedposal==0 | garbagedposal==1) ~ "No prev."
		)
		, toiletSQ = case_when(toilettype==0 & toilettypeP==0 ~ "All -"
			, toilettype==1 & toilettypeP==1 ~ "All +"
			, toilettypeP==1 & toilettype==0 ~ "Loss"
			, toilettypeP==0 & toilettype==1 ~ "Gain"
			, is.na(toilettypeP) & (toilettype==0 | toilettype==1) ~ "No prev."
		)
	)
	%>% ungroup()
	%>% mutate(hhid = as.numeric(hhid))
	%>% data.frame()
)

## Lagged: Any interview before now is considered previous interview

summary_laged_df <- (wash_df
	%>% group_by(hhid)
	%>% mutate(watersourceP = lag(watersource, order_by = year)
		, toilettypeP = lag(toilettype, order_by = year)
		, garbagedposalP = lag(garbagedposal, order_by = year)
	)
	%>% mutate(n = n()
		, nprev_miss1 = sum(is.na(watersourceP))
	)
	%>% ungroup()
	%>% mutate_at("hhid", as.numeric)
	%>% select(hhid, n, nprev_miss1)
	%>% distinct()
	%>% summarise(nn = sum(nprev_miss1))
)
percent_miss_lagged <- percent(summary_laged_df$nn/nint_consec)

#### ---- Overall service proportion per year ----

service_props <- lapply(c("watersource", "garbagedposal", "toilettype"), summaryFunc)
service_props_df <- do.call(rbind, service_props)

prop_plot <- (ggplot(service_props_df, aes(x = factor(year+base_year), y = prop, group = services, colour = services))
	+ geom_point()
	+ geom_line()
	+ geom_hline(aes(yintercept = overall, group = services, colour = services), linetype = "dashed")
	+ geom_text(aes(x = max(year)-1, y = overall, group = services, label = paste0("Overall = ", scales::percent(overall)))
		, vjust = -1.5
		, show.legend = FALSE
	)
	+ labs(x = "Years"
		, y = "Proportions of\nimproved services"
		, colour = "Services"
	)
	+ scale_y_continuous(labels = percent, limits = c(0,1))
	+ scale_colour_discrete(breaks = c("watersource"
			, "garbagedposal"
			, "toilettype"
		)
	)
	+ theme(legend.position = "bottom"
		, plot.title = element_text(hjust = 0.5)
	)
)
print(prop_plot)


#### ---- Number of completed interviews for all the hh ----

n_intv_hh_df <- (wash_df
	%>% group_by(hhid)
	%>% summarise(n = n())
)

n_interviews_plot <- (ggplot(n_intv_hh_df, aes(x = as.factor(n)))
	+ geom_bar(aes(y = ..prop.., group = 1), stat = "count")
	+ scale_y_continuous(labels = percent)
	+ labs(x = "No. of interviews", y = "Proportion")
)
print(n_interviews_plot)

#### ---- Number of completed interviews per year ----

n_intv_year_df <- (wash_df
	%>% group_by(year)
	%>% summarise(n = n())
	%>% mutate(prop = n/nhhid) #sum(n))
	%>% ungroup()
)
year_plot <- (ggplot(n_intv_year_df, aes(x = factor(year+base_year), group = 1, y = prop))
	+ geom_point()
	+ geom_line()
	+ scale_y_continuous(labels = percent)
	+ labs(x = "Year", y = "Interviews")
)
print(year_plot)


#### ---- Compare HH size scaled vs unscaled ----

hhsize_df <- (wash_df
	%>% select(hhsize, hhsize_scaled)
	%>% setnames(c("hhsize", "hhsize_scaled"), c("unscaled", "scaled")) 
	%>% gather(type, value)
)

hhsize_plot <- (ggplot(hhsize_df, aes(x = value))
	+ geom_histogram()
	+ labs(x = "HH size", y = "Count")
	+ facet_wrap(~type, scales = "free_x")
)
print(hhsize_plot)

#### ---- Consecutive interviews per year plot ----
consec_all_plot <- (ggplot(summary_consec_df, aes(x = as.factor(nprev_miss1), y = nn))
	+ geom_bar(stat='identity')
	+ geom_text(aes(label=paste0(percent(nn/nint_consec)))
		, stat='identity'
		, position=position_dodge(0.9)
		, vjust=-0.2
	)
	+ labs(x = "Missing previous interviews"
		, y = "Total no. of interviews"
	)
)
print(consec_all_plot)

#### ---- First year ignored consecutive interviews ----

consec_noyr0_plot <- (ggplot(summary_consec_noyr0_df, aes(x = as.factor(nprev_miss2), y = nn))
	+ geom_bar(stat='identity')
	+ geom_text(aes(label=paste0(percent(nn/nint_noyr0)))
		, stat='identity'
		, position=position_dodge(0.9)
		, vjust=-0.2
	)
	+ labs(x = "Missing previous interviews"
		, y = "Total no. of interviews"
	)
)
print(consec_noyr0_plot)

#### ---- Status Quo based on the previous year ----

consec_temp_df <- (consec_temp_df
	%>% select(c("waterSQ", "garbageSQ", "toiletSQ"))
	%>% gather(services, SQ)
	%>% mutate(services = gsub("SQ", "", services))
	%>% group_by(services, SQ)
	%>% summarise(n = n())
	%>% mutate(prop = n/sum(n))
	%>% ungroup()
)
print(consec_temp_df)

status_quo_plot <- (ggplot(consec_temp_df, aes(x = reorder(SQ, -prop), y = prop, group = services, colour = services))
	+ geom_line()
	+ geom_point()
	+ scale_y_continuous(labels = percent)
	+ labs(x = "Current-previous year status", y = "Proportion", colour = "Services")
	+ scale_colour_discrete(breaks = c("water"
			, "garbage"
			, "toilet"
		)
	)
	+ theme(legend.position = "bottom")
)
print(status_quo_plot)

saveVars(base_year
	, nhhid
	, nint_all
	, prevcases_df_summary
	, nint_consec
	, nint_noyr0
	, percent_miss_consec
	, percent_year0
	, percent_miss_consec_noyr0
	, percent_miss_consec_noyr0_all
	, percent_miss_lagged
	, prop_plot
	, status_quo_plot
	, n_interviews_plot
	, year_plot
	, consec_all_plot
	, consec_noyr0_plot

)

