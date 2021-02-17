library(shellpipes)
library(glmmTMB)
library(car)

commandEnvironments()

toiletP_tmb_anova <- Anova(toiletP_tmb, type = "II")
toiletP_tmb_anova <- parseAnova(toiletP_tmb_anova, model = "toiletP")
print(toiletP_tmb_anova)

saveVars(toiletP_tmb_anova)
