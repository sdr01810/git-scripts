#!/bin/bash
## Wrapper around git(1); provides "standard" options + a few extra features
## By Stephen D. Rogers, 2020-04.
## 
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

function gitx_dispatcher() { # script_path_name [script_arg...]

	local script_path_name="${1:?missing argument: script_path_name}"
	shift 1

	local script_name="$(basename "$0")"
	script_name="${script_name%.*sh}"

	local function_name="gitx"
	local function_args_head=(      )
	local function_args_tail=( "$@" )
	shift $#

	case "${script_name:?}" in
	gx|gitx|git)
		true
		;;
	gx*)
		function_args_head=( "${script_name#gx}" )
		;;
	g*)
		function_args_head=( "${script_name#g}" )
		;;
	*|'')
		echo 1>&2 "Unrecognized alias for gitx: {${script_name:?}}."
		return 1 # fail fast
		;;
	esac

	"${function_name:?}" "${function_args_head[@]}" "${function_args_tail[@]}"
}

function gitx() { # [command_name] [command_arg...]

	local program_name="git"
	local program_args_head=()
	local program_args_tail=()

	if [ $# -gt 0 ] ; then
		program_args_head=( "$1" )
		shift 1
	fi

	program_args_tail=( "$@" )
	shift $#

	local x1

	case "${program_args_head}" in
	stash)
		program_args_tail=( "${program_args_head[@]}" "${program_args_tail[@]}" )
		program_args_head=( "${program_name:?}" )
		program_name="without-pager"
		;;
	*|'')
		for x1 in \
			"gitx_command_${program_args_head}" \
			"gitx-${program_args_head}" \
			"git-${program_args_head}" \
		;do
			if [ -n "$(type -t "${x1:?}")" ] ; then

				program_args_head=()
				program_name="${x1:?}"
				break
			fi
		done
		;;
	esac

	"${program_name:?}" "${program_args_head[@]}" "${program_args_tail[@]}"
}

##
## core logic:
##

function main() { # ...

	gitx_dispatcher "$0" "$@"
}

! [ "$0" = "${BASH_SOURCE}" ] || main "$@"
