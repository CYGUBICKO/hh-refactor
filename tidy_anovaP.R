library(shellpipes)
library(dplyr)

commandEnvironments()

anova_df <- list(waterP_tmb_anova, garbageP_tmb_anova, toiletP_tmb_anova)

anovaP_df <- (bind_rows(anova_df)
	%>% mutate(vars = gsub("watersourceP|garbagedposalP|toilettypeP", "StatusP", vars)) 
)
head(anovaP_df)

saveVars(anovaP_df)
