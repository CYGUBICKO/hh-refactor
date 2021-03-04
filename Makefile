## This is cygubicko/hh-refactor

current: target
-include target.mk

vim_session:
	bash -cl "vmt notes.md"

######################################################################

Sources += $(wildcard *.R *.md. *.rmd *.tex)
autopipeR = defined

Ignore += $(wildcard *.xlsx)

######################################################################
steve_macdata_proposal.pdf: steve_macdata_proposal.tex

######################################################################

## cygubicko/funs: general purpose functions
Makefile: funs
funs:
	git clone https://github.com/cygubicko/funs.git
Ignore += funs
alldirs += funs

## Some functions which might go to shellpipes
shellpipesfuns.Rout: shellpipesfuns.R
	$(wrapR)

## Preset ggplot theme
ggtheme.Rout: ggtheme.R
	$(wrapR)

######################################################################

now: descriptive_stats_report.html dwelling_pca_plot.Rout ownership_here_pca_plot.Rout ownership_else_pca_plot.Rout tidy_coefP_plots.Rout all_services_varpred_plots.Rout

######################################################################

Ignore += data cachestuff
## Data symbolic links
### ln -fs ~/Dropbox/academic/aphrc/hh_amen_xtics/data/ data ##
### ln -fs ~/Dropbox/academic/aphrc/hh_amen_xtics/cache/ cachestuff ##

aphrc = $(shell ls -d ~/Dropbox/aphrc ~/Dropbox/*/aphrc | head -1)
hhdir = $(aphrc)/hh_amen_xtics
data: dir=$(hhdir)
data:
	$(linkdir)

data/%:
	$(MAKE) data

## cachestuff
cachestuff: dir=$(hhdir)/cache
cachestuff: 
	$(linkdirname)

## Loading data
loadatafun.Rout: loadatafun.R
charfile = data/NUHDSS_hhamenitiescharacteristics_anon.dta
loadata.Rout: loadata.R loadatafun.rda loadatafun.rda $(charfile)

## Filter data
interview_filters.Rout: interview_filters.R
filter_interviews.Rout: filter_interviews.R interview_filters.rda loadata.rda

## Examine types of missing values in the raw data
missingdatafuns.Rout: missingdatafuns.R
raw_missing_summary.Rout: raw_missing_summary.R missingdatafuns.rda filter_interviews.rda 

## Relabelling and recoding categorical variables
labelsfuns.Rout: labelsfuns.R
generate_labels.Rout: generate_labels.R labelsfuns.rda shellpipesfuns.rda filter_interviews.rda
generate_labels.Rout.xlsx: generate_labels.Rout ;

######################################################################

## Cleaning
cleaning.Rout: cleaning.R generate_labels.rda shellpipesfuns.rda filter_interviews.rda
cleaning.Rout.xlsx: cleaning.Rout;

## Missingness summary after cleaning
clean_missing_summary.Rout: clean_missing_summary.R missingdatafuns.rda cleaning.rda raw_missing_summary.rda shellpipesfuns.rda
clean_missing_summary.Rout.xlsx: clean_missing_summary.Rout;

## Drop variables with -% missing
drop_variables.Rout: drop_variables.R clean_missing_summary.rda

## Group variables per section in the questionnaire
variable_groups.Rout: variable_groups.R shellpipesfuns.rda missingdatafuns.rda drop_variables.rda
variable_groups.Rout.xlsx: variable_groups.Rout;

## Drop all cases with any missing information or specification
complete_cases.Rout: complete_cases.R missingdatafuns.rda variable_groups.rda

## Analysis data: outliers dropped according to some cutoff points
analysis_data.Rout: analysis_data.R variable_groups.rda complete_cases.rda

######################################################################

## Descriptives
descplotfuns.Rout: descplotfuns.R
	$(wrapR)
descriptive_stats.Rout: descriptive_stats.R ggtheme.rda descplotfuns.rda analysis_data.rda variable_groups.rda
descriptive_stats_report.html: descriptive_stats_report.rmd ggtheme.rda variable_groups.rda descriptive_stats.rda generate_labels.Rout.xlsx
	$(knithtml)

######################################################################

## PCA

### Dwelling index
#### Positively signed manually
dwelling_pca.Rout: dwelling_pca.R analysis_data.rda variable_groups.rda
dwelling_pca_plot.Rout: dwelling_pca_plot.R ggtheme.rda dwelling_pca.rda

### Ownership index

#### Owned within the hh
#### Positively signed manually
ownership_here_pca.Rout: ownership_here_pca.R analysis_data.rda variable_groups.rda
ownership_here_pca_plot.Rout: ownership_here_pca_plot.R ggtheme.rda ownership_here_pca.rda

#### Owned somewhere else
ownership_else_pca.Rout: ownership_else_pca.R analysis_data.rda variable_groups.rda
ownership_else_pca_plot.Rout: ownership_else_pca_plot.R ggtheme.rda ownership_else_pca.rda

######################################################################

## Select variables for wash analysis
washdata.Rout: washdata.R dwelling_pca.rda ownership_here_pca.rda ownership_else_pca.rda analysis_data.rda

## Lag wash data. Add immediate previous observational year as one of the predictors
laggeddata.Rout: laggeddata.R washdata.rda
laggeddata_plots.Rout: laggeddata_plots.R ggtheme.rda laggeddata.rda

## Recategorise previous status variables (*P$)
laggeddata_statusPcats.Rout: laggeddata_statusPcats.R laggeddata.rda

######################################################################

## Model data in a model frame with the selected predictors
modeldata.Rout: modeldata.R laggeddata_statusPcats.rda

## Model formula
modelformula.Rout: modelformula.R

######################################################################

## Model fitting

### Important functions
#### parse term names of anova object
anovafuns.Rout: anovafuns.R
	$(wrapR)

#### Label prediction plots
predlabelsfuns.Rout: predlabelsfuns.R
	$(wrapR)

#### Plot effects sizes
effectsizefuns.Rout: effectsizefuns.R
	$(wrapR)

### Water services
#### Model
waterP_tmb.Rout: waterP_tmb.R modelformula.rda modeldata.rda

#### Anova
waterP_tmb_anova.Rout: waterP_tmb_anova.R anovafuns.rda waterP_tmb.rda

#### Variable effects
waterP_tmb_varpred.Rout: waterP_tmb_varpred.R waterP_tmb.rda
waterP_tmb_varpred_plots.Rout: waterP_tmb_varpred_plots.R predlabelsfuns.rda waterP_tmb_anova.rda waterP_tmb_varpred.rda

### Garbage collection
#### Model
garbageP_tmb.Rout: garbageP_tmb.R modelformula.rda modeldata.rda

#### Anova
garbageP_tmb_anova.Rout: garbageP_tmb_anova.R anovafuns.rda garbageP_tmb.rda

#### Variable effects
garbageP_tmb_varpred.Rout: garbageP_tmb_varpred.R garbageP_tmb.rda
garbageP_tmb_varpred_plots.Rout: garbageP_tmb_varpred_plots.R predlabelsfuns.rda garbageP_tmb_anova.rda garbageP_tmb_varpred.rda

### Toilet facilities
#### Model
toiletP_tmb.Rout: toiletP_tmb.R modelformula.rda modeldata.rda

#### Anova
toiletP_tmb_anova.Rout: toiletP_tmb_anova.R anovafuns.rda toiletP_tmb.rda

#### Variable effects
toiletP_tmb_varpred.Rout: toiletP_tmb_varpred.R toiletP_tmb.rda
toiletP_tmb_varpred_plots.Rout: toiletP_tmb_varpred_plots.R predlabelsfuns.rda toiletP_tmb_anova.rda toiletP_tmb_varpred.rda

## Tidy Anova
tidy_anovaP.Rout: tidy_anovaP.R waterP_tmb_anova.rda garbageP_tmb_anova.rda toiletP_tmb_anova.rda

## Tidy coefficients
tidy_coefP.Rout: tidy_coefP.R waterP_tmb.rda garbageP_tmb.rda toiletP_tmb.rda
tidy_coefP_plots.Rout: tidy_coefP_plots.R ggtheme.rda effectsizefuns.rda tidy_anovaP.rda tidy_coefP.rda

## Compare variable effects across the three services
all_services_varpred_plots.Rout: all_services_varpred_plots.R ggtheme.rda waterP_tmb_varpred_plots.rda garbageP_tmb_varpred_plots.rda toiletP_tmb_varpred_plots.rda


######################################################################

### Makestuff

Sources += Makefile notes.md

## Sources += content.mk
## include content.mk

Ignore += makestuff
msrepo = https://github.com/dushoff

Makefile: makestuff/Makefile
makestuff/Makefile:
	git clone $(msrepo)/makestuff
	ls makestuff/Makefile

-include makestuff/os.mk

-include makestuff/pipeR.mk

-include makestuff/git.mk
-include makestuff/visual.mk
-include makestuff/texdeps.mk
-include makestuff/pandoc.mk
