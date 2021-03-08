library(shellpipes)
library(tidyr)
library(dplyr)

commandEnvironments()

## Transform data into long format:
## Following Bolker melting method
## https://mac-theobio.github.io/QMEE/MultivariateMixed.html

head(wash_df)
dim(wash_df)

services_vars <- c("watersource", "toilettype", "garbagedposal")
long_df <- (wash_df
	%>% gather(services, status, !!services_vars)
#	%>% filter(hhid=="00005B9B-0170-4614-80F8-BF9A0976C8C0")
	%>% data.frame()
)
dim(long_df)
head(long_df)

saveVars(wash_df
	, long_df
	, base_year
)
