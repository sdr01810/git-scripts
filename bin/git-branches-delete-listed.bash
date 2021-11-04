#!/bin/bash
## Deleted the named branches listed on stdin
##
## Typical uses:
## 
##     git-branches-ready-for-culling-against master | git-branches-delete-listed
##

set -e

set -o pipefail 2>&- || :

##
## from snippet library:
## 

function xx() { # ...

	echo 1>&2 "${PS4:-+}" "$@"

	"$@"
}

function git_branches_delete_listed() { #

	cat -- "$@" |

	while read -r b1 ; do

		case "${b1}" in
		(remotes/*/*)
			b1="${b1#remotes/}"

			xx :
			xx git push "${b1%%/*}" --delete "${b1#*/}"
			;;
		(*)
			xx :
			xx git branch --delete --force "${b1:?}"
			;;
		esac
	done
}

##
## core logic:
##

function main() { #

	git_branches_delete_listed "$@"
}

! [ "$0" = "${BASH_SOURCE}" ] || main "$@"
