#!/bin/bash
##

set -e 

set -o pipefail 2>&- || :

##

commit_args=( )
commit_message="Checkpoint"

while [ $# -gt 0 ] ; do

	case "$1" in
	--)
		shift 1 ; break
		;;
	-e)
		commit_args+=( $1 ) ; shift 1
		;;
	-m)
		commit_message="$2" ; shift 2
		;;
	-*)
		exit 1>&2 "Unrecognized option: $1" ; exit 2
		;;
	*)
		break
		;;
	esac
done

commit_args+=( -m "$commit_message" "$@" )

##

xx git add -A :/

xx git commit "${commit_args[@]}"

