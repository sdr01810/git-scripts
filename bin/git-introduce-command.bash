#!/bin/bash
## Introduce a command into my toolset.
## By Stephen D. Rogers, 2018-02.
## 
## Typical uses:
## 
##    git introduce-command cmd/new-command.bash
## 

set -e

command_man_page_section="1sdr"

##

function git_introduce_command_1() { # command_stem_pn

	local command_stem_pn="${1:?}"
	command_stem_pn="${command_stem_pn%.*sh}"
	command_stem_pn="${command_stem_pn%.js}"
	command_stem_pn="${command_stem_pn%.py}"
	command_stem_pn="${command_stem_pn%.rb}"
	command_stem_pn="${command_stem_pn%.tcl}"
	command_stem_pn="${command_stem_pn%.tk}"

	command_stem_pn="$(echo "${command_stem_pn}" | 
		perl -lpe 's#(^|(?<=/))(\bthunk\b[^/]*)(/?)## ; s#(/?)(\bthunk\b[^/]*)((?=/)|$)##')"

	case "${command_stem_pn:?}" in
	*/*)
		true
		;;
	*)
		command_stem_pn="${HOME:?}/cmd/${command_stem_pn:?}"
		#^-- FIXME: srogers: search ${PATH} for command
		;;
	esac

	command_stem_dpn="$(dirname "${command_stem_pn:?}")"
	command_stem_fbn="$(basename "${command_stem_pn:?}")"

	##

	local files=()
	local f1 x1

	for f1 in "${command_stem_dpn:?}/${command_stem_fbn:?}"{,.*[^~]} ; do

		[ -e "${f1:?}" ] || continue

		files+=("${f1:?}")
	done

	for x1 in "${command_stem_dpn:?}"/thunk.*/.mk-links ; do
	for f1 in "${x1%/.mk-links}/${command_stem_fbn:?}" ; do

		[ -e "${f1:?}" ] || ! [ -e "${x1:?}" ] || (xx "${x1:?}")
		[ -e "${f1:?}" ] || continue

		files+=("${f1:?}")
	done;done

	if [ "${#files[@]}" -eq 0 ] ; then

		echo 1>&2 "Unrecognized command spec: ${command_stem_pn:?}" ; return 1
	fi

	##

	local command_type=

	case "${command_stem_dpn##*/}" in
	snippets)
		command_type="snippet"
		;;
	*)
		command_type="command"
		;;
	esac

	xx :

	xx git add -f "${files[@]}"

	xx git commit -m "Introduce ${command_type} ${command_stem_fbn:?}(${command_man_page_section:?})." "${files[@]}"

	xx git log -n1 --name-status | cat
}

function git_introduce_command() { # command_stem_pn ...

	local command_stem_pn

	for command_stem_pn in "$@" ; do

		git_introduce_command_1 "${command_stem_pn:?}"
	done
}

main() { # ...

	git_introduce_command "$@"
}

##

main "$@"


