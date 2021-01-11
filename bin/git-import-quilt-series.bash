#!/bin/bash
## Import a quilt patch series into git, each as a separate commit
## 
## Empty patches are skipped unless you specify `--allow-empty`.
##
## Loads quilt environment variables from `~/.quiltrc` if it exists.
##
## The corresponding commit comment for each patch will be the patch header
## unless the patch header is empty, in which case it will be the patch name.
##
## Arguments:
## 
##     [ --dry-run | -n ] [ --allow-empty ] [ git-commit-arg ... ]
## 
## Typical uses:
## 
##     quilt unapplied
##     
##     cat ~/.quiltrc || :
## 
##     git import-quilt-series --dry-run
## 
## See also:
## 
##     git-commit(1), quilt(1)
## 

set -e

set -o pipefail 2>&1 || :

##
## from snippet library:
## 

function arguments_quoted() { # ...

	printf '%q\n' "$@"
}

function git_committer() { #

	local result="$(git var GIT_COMMITTER_IDENT)" ; result="${result:+${result%>*}>}"

	[ -n "${result}" ] && echo "${result}"
}

function git_author() { #

	local result="$(git var GIT_AUTHOR_IDENT)" ; result="${result:+${result%>*}>}"

	[ -n "${result}" ] && echo "${result}"
}

function check_git_work_tree_is_clean() {

        local git_status_output="$(git status --porcelain --untracked-files 2>&1)"

	if [ -n "${git_status_output}" ] ; then

		echo 1>&2 "Git work tree is not clean:"
		echo 1>&2 "${git_status_output:?}"
		echo 1>&2 ""

		return 2
	fi
}

function check_quilt_patch_stack_is_empty() {

	local quilt_applied_output="$(quilt applied 2>&1)"

	if [ "${quilt_applied_output:?}" != "No patches applied" ] ; then

		echo 1>&2 "Quilt already has patches applied:"
		echo 1>&2 "${quilt_applied_output:?}"
		true

		return 2
	fi
}

function git_import_quilt_series() {( # ...

	local allow_empty_p= dry_run_p=

	load_optional_quilt_rc_file

	while [ $# -gt 0 ] ; do
	case "${1}" in
	--allow-empty)
		allow_empty_p=t
		shift 1
		;;

	--dry-run|-n)
		dry_run_p=t
		shift 1
		;;

	--)
		shift 1
		break
		;;

	*|'')
		break
		;;

	esac;done

	local git_add_command_quoted=( $(arguments_quoted ${dry_run_p:+:} git add -A :/) )

	local git_commit_command_quoted=( $(arguments_quoted ${dry_run_p:+:} git commit --allow-empty "$@") )

	shift $#

	##

	local rc=0
	local patch_count_pushed=0
	local patch_count_skipped=0
	local patch_count_committed=0

	check_git_work_tree_is_clean || rc=2

	check_quilt_patch_stack_is_empty || rc=2

	while [ ${rc:?} -eq 0 ] && quilt push ; do	

		(( patch_count_pushed += 1 ))

		local diff_line_count="$(quilt diff | wc -l)"

		if [ ${diff_line_count:?} -lt 1 ] && [ ! -n "${allow_empty_p}" ] ; then

			echo "Skipping empty patch."

			(( patch_count_skipped += 1 ))
		else
			echo "Committing patch."

			local comment="$(quilt header)"

			[ -n "${comment}" ] || comment="$(quilt top)"

			echo "${comment}" | eval-with-temp-file '

				cat > "${f_temp:?}" &&

				(' "${git_add_command_quoted[@]}" ') &&

				(' "${git_commit_command_quoted[@]}" '-F "${f_temp:?}" ) ;

			' || { rc=$? ; continue ; }

			(( patch_count_committed += 1 ))
		fi

		echo ""
	done

	##

	echo ""
	echo "Patches committed: ${patch_count_committed:?}; skipped: ${patch_count_skipped:?}; pushed: ${patch_count_pushed:?}."
	echo ""

	local Import_into_git="Import into git${dry_run_p:+ (would have)}"

	if [ ${patch_count_pushed:?} -gt 0 ] && [ ${rc:?} -ne 0 ] ; then

		echo "${Import_into_git} failed before finishing."
	else
	if [ ${patch_count_pushed:?} -le 0 ] && [ ${rc:?} -eq 0 ] ; then

		echo "${Import_into_git} had nothing to do."

	else
	if [ ${rc:?} -eq 0 ] ; then

		echo "${Import_into_git} succeeded."
	else
		echo "${Import_into_git} failed."
	fi;fi;fi

	return ${rc:?}
)}

function load_optional_quilt_rc_file() {

	! [ -f ~/.quiltrc ] || source ~/.quiltrc || return 2

	export_all_quilt_vars
}

function export_all_quilt_vars() {

	local quilt_vars=( $(set -o posix && set | egrep '^QUILT\w*=' | sed -e 's/=.*//') )
	local v1
	
	for v1 in "${quilt_vars[@]}" ; do

		export "${v1:?}"
	done
}

##
## core logic:
##

function main() { # ...

	git_import_quilt_series "$@"
}

! [ "$0" = "${BASH_SOURCE:?}" ] || main "$@"
