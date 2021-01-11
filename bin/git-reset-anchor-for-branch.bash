#!/bin/bash
## Reset the anchor branch for the specified branch to the specified commit'ish.
## By Stephen D. Rogers, 2017-02.
##
## Typical use:
##
##     git reset-anchor-for-branch $(git branch-name)
##     
##     git reset-anchor-for-branch $(git branch-name) $(git branch-name)
##     
##     git reset-anchor-for-branch $(git branch-name) origin/master
##

set -e -o pipefail

##

branch_name="${1:?missing argument: branch_name}"

branch_anchor_name="${branch_name}.anchor"

branch_anchor_tip_revspec="${2:-${branch_name:?}}"

xx :
xx git checkout "${branch_anchor_name:?}"

xx :
xx git reset --hard "${branch_anchor_tip_revspec:?}"

xx :
xx git checkout "${branch_name:?}"


