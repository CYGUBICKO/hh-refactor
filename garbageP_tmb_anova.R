library(shellpipes)
library(glmmTMB)
library(car)

commandEnvironments()

garbageP_tmb_anova <- Anova(garbageP_tmb, type = "II")
garbageP_tmb_anova <- parseAnova(garbageP_tmb_anova, model = "garbageP")
print(garbageP_tmb_anova)

saveVars(garbageP_tmb_anova)
