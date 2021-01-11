#!/bin/bash
## Prints the ID (if any) of the latest commit that contains the specified file(s).
## By Stephen D. Rogers, 2018-02.
## 
## Typical uses:
## 
##     git diff $(git latest-commit-with-file FOO) -- FOO
## 

set -e

git log -n1 -- "$@" | egrep '^commit\b'|
while read commit_kw commit_id ; do

	echo "${commit_id}"
done
