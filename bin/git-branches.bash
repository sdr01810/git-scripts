#!/bin/bash
## Shorthand for git branches --list
##

git branch --list "$@" |
	
exec perl -pe 's#^\W*##'

