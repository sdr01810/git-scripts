#!/bin/bash
## Execute the specified git command for each listed directory
## By Stephen D. Rogers, 2017-02.
## 
## Typical use:
## 
##     ls -d astam* | git for-each-dir fetch origin
##     
##     ls -d astam* | git for-each-dir status
## 

set -e -o pipefail

while read -r d1 ; do

	[ -n "${d1}" ] || continue

	case "${d1:?}" in
	*.git)
		d1="${d1%.git}"
		;;
	*/.git)
		d1="${d1%/.git}"
		;;
	esac

	(set -x ; : ; cd "${d1:?}" ; git "$@")
done
