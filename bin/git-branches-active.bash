#!/bin/bash
## List the active branches, omitting corresponding auxiliary branches.
##

set -e 

set -o pipefail 2>&- || :

##

git branches | perl -pe 's#^[*]?\s+##' |
	
egrep "^${USER}\b" |

egrep -v '^${USER}\W(attic)\b' |

egrep -v '\.(anchor|bl\d+|ss\d+|ref|trash)$'

#^-- FIXME: align semantics with git-ls-active-topic-branches(1sdr)
