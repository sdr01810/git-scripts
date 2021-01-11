##/bin/bash
## Provides the bash-ut api runtime.
## 

[ -z "$bash_ut_api_functions_p" ] || return 0

bash_ut_api_functions_p=t

bash_ut_api_debug_p=

##

source bash_ut_api_assertion.functions.sh

source bash_ut_api_test_result_formatter.functions.sh

source bash_ut_api_test_run.functions.sh

source bash_ut_api_value_predicate.functions.sh

##
