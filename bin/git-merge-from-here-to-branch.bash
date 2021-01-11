#!/bin/bash
## Merge from the current branch to the specified destination branch.
## By Stephen D. Rogers, 2017-02.
##
## Typical uses:
##
##     git merge-from-here-to-branch upstream.master
##
##     git merge-from-here-to-branch upstream.master --no-commit
##
## Upon completion, the current branch becomes the push destination,
## unless that branch does not exist.
##

set -e -o pipefail

##

destination_branch="${1:?missing argument: destination_branch}" ; shift

current_commit="$(< "$(git-dir)/HEAD")"

xx :
xx git checkout "${destination_branch:?}"

xx :
xx git merge "$@" "${current_commit:?}"

