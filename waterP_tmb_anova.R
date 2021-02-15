library(shellpipes)
library(glmmTMB)
library(car)

commandEnvironments()

waterP_tmb_anova <- Anova(waterP_tmb, type = "II")
waterP_tmb_anova <- parseAnova(waterP_tmb_anova, model = "waterP")
print(waterP_tmb_anova)

saveVars(waterP_tmb_anova)
