#!/bin/bash
## List the names of (remote) branches that are ready for culling against a backbone branch
##
## Typical uses:
## 
##     git-branches-ready-for-culling-against
##     git-branches-ready-for-culling-against master
##     git-branches-ready-for-culling-against develop
## 
## A branch is ready for culling against a backbone branch if: (a) all of its commits have
## already been directly incorporated (merged) into the specified backbone branch; and (b) it is
## not 'special'.  Special branches are branches with names that tend to represent major code
## lines, such as 'develop', 'main', 'master', 'release'.  Local (non-remote) branches are also
## special.
##

set -e

set -o pipefail 2>&- || :

##
## from snippet library:
## 

function git_branches_ready_for_culling_against() { # backbone_branch_spec

	local backbone_branch_spec="${1:?must specify backbone branch, such as 'master'}" ; shift 1

	git branch -a --merged "${backbone_branch_spec:?}" |

	while read -r b1 ; do 

		! git_branch_is_protected_against_culling "${b1:?}" || continue

		echo "${b1:?}"
	done
}

function git_branch_is_protected_against_culling() { # branch_name

	local branch_name="${1:?}" ; shift 1

	git_branch_is_local "${branch_name:?}" ||
	git_branch_looks_like_major_code_line "${branch_name:?}"
}

function git_branch_looks_like_major_code_line() { # branch_name

	local branch_name="${1:?}" ; shift 1

	local branch_base_name="${branch_name##*/}"

	case "${branch_base_name:?}" in
	(develop|main|master|release)
		true
		;;
	(*)
		false
		;;
	esac
}

function git_branch_is_local() { # branch_name

	! git_branch_is_remote "$@"
}

function git_branch_is_remote() { # branch_name

	local branch_name="${1:?}" ; shift 1

	case "${branch_name:?}" in
	(remotes/*)
		true
		;;
	(*)
		false
		;;
	esac
}

##
## core logic:
##

function main() { # backbone_branch_spec

	git_branches_ready_for_culling_against "$@"
}

! [ "$0" = "${BASH_SOURCE}" ] || main "$@"
