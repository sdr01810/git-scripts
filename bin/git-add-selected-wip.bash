#!/bin/bash
## Add selected work-in-progress commits to the current branch.
## By Stephen D. Rogers, 2012-06.
##
## Typical usage:
## 
##     git checkout wip.existing-topic-branch
##     git add-selected-wip
##

set -e
set -x

git rev-parse HEAD > .git.START

git reset --hard wip

git rebase -i --onto $(< .git.START) wip.headline

