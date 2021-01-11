#!/bin/bash
## Move to the (local) attic all branches matching the specified pattern.
## 
## Arguments:
## 
##     branch_spec  an egrep(1) pattern that matches the desired branch(es)
##
## Typical uses:
## 
##     git-move-to-attic-all-branches-related-to my-current-work
## 
##     git-move-to-attic-all-branches-related-to my-feature-branch-part-'\d+'
## 

set -e

set -o pipefail 2>&- || :

##

branch_spec="${1:?}" ; shift 1

branch_attic_prefix="attic/"

##

git branch | perl -pe 's#^[*]?\s+##' |
	
egrep "${branch_spec}" | egrep -v "^${branch_attic_prefix}" |

while read -r b1 ; do

	b2="attic/${b1}"

	xx git branch -M "${b1}" "${b2}"
done

