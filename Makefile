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


######################################################################

## Data symbolic links
### ln -fs ~/Dropbox/aphrc/hh_amen_xtics/data/ data

loadatafun.Rout: loadatafun.R
loadata.Rout: loadata.R loadatafun.R

## Filter data
interview_filters.Rout: interview_filters.R
filter_interviews.Rout: filter_interviews.R interview_filters.R loadata.rda


######################################################################

### Makestuff

Sources += Makefile

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

