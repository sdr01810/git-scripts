#!/bin/bash
## Manages aspects of a unit testing framework for bash scripts
##
## Arguments:
##
##     path [ file_or_directory_rpn ... ]
## 
##     run [ test_script_fpn ... ]
## 
## Typical uses:
## 
##     PATH="${PATH}${PATH:+:}$(bash-ut path)"
##     PATH="${PATH}${PATH:+:}$(bash-ut path bin)"
##     PATH="${PATH}${PATH:+:}$(bash-ut path bin libexec)"
##     
##     source "$(bash-ut path functions.sh)"
##     source "$(bash-ut path libexec/bash_ut_api.functions.sh)"
##     
##     bash-ut run tests/**/*.tests.sh
## 

source "$(dirname "${BASH_SOURCE:?}")"/thunk/bash-ut.prolog.sh

source bash_ut_cli_dispatcher.functions.sh

##

function main() { # ...

	bash_ut_cli_dispatcher "$@"
}

! [ "$0" = "${BASH_SOURCE:?}" ] || main "$@"
