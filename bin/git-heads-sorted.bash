#!/bin/bash
## List git heads sorted by SHA1 sum
## By Stephen D. Rogers, 2017-02.
## 
## Typical uses:
## 
##     git heads-sorted
##

egrep . "$(git-dir)"/refs/heads/* | perl -pe 's{:}{ }' | tabular | sort -k 2
