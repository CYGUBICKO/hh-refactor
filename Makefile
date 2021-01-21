## This is cygubicko/hh-refactor

current: target
-include target.mk

vim_session:
	bash -cl "vmt notes.md"

######################################################################

Sources += $(wildcard *.R *.md.)

autopipeR = defined

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

######################################################################

## Data symbolic links
### ln -fs ~/Dropbox/aphrc/hh_amen_xtics/data/ data

loadatafun.Rout: loadatafun.R
loadata.Rout: loadata.R loadatafun.rda

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

