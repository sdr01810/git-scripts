#!/bin/bash
## Print the name of the current branch.
## By Stephen D. Rogers, 2016-12.
## 

if [ $# -gt 0 ] ; then
	echo 1>&2 "Too many arguments."
	exit 2
fi

git branch --list | perl -lne 'print if s{^\s*\*\s+}{}'

