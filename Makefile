## This is cygubicko/hh-refactor

current: target
-include target.mk

vim_session:
	bash -cl "vmt notes.md"

######################################################################

Sources += $(wildcard *.R *.md.)
autopipeR = defined

Ignore += $(wildcard *.xlsx)

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
dwelling_pca.Rout: dwelling_pca.R analysis_data.rda variable_groups.rda
dwelling_pca_plot.Rout: dwelling_pca_plot.R ggtheme.rda dwelling_pca.rda

### Ownership index
ownership_here_pca.Rout: ownership_here_pca.R analysis_data.rda variable_groups.rda
ownership_here_pca_plot.Rout: ownership_here_pca_plot.R ggtheme.rda ownership_here_pca.rda


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
-include makestuff/pandoc.mk
