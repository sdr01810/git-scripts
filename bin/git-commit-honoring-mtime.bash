#!/bin/bash
## Like git commit, but using a recorded date based on the mtime of the newest file in the commit set
##
## Typical uses:
##
##     git commit-honoring-mtime $(select-related-batch-from-backlog-of-recently-changed-files)
##

set -e -o pipefail

##
## from snippet library:
##

function date_time_from_seconds_since_unix_epoch() { # [ value ]

	local value=${1}

	case "${value}" in
	(@now|@|now|'')
		value=
		;;

	(@[0-9]*)
		value=${value#@}
		;;

	([0-9]*)
		true
		;;

	(*)
		echo 1>&2 "${FUNCNAME:?}: unrecognized value: ${value}"
		return 2
		;;
	esac

	perl -e '
		use DateTime;
		use DateTime::Format::Epoch;
		use DateTime::TimeZone;

		use Time::Format qw(%time);

		my $dt_tz = DateTime::TimeZone->new(name => $ENV{"TZ"} || "UTC");

		my $dt_unix_epoch = DateTime->new(year => 1970, month => 1, day => 1);

		my $dtio_unix_epoch = DateTime::Format::Epoch->new(epoch => $dt_unix_epoch);

		##

		my $value = shift || time;

		my $dt = $dtio_unix_epoch->parse_datetime($value);

		$dt->set_time_zone($dt_tz);

		my $result = $dt->rfc3339();

		print "$result$/";

	' ${value};
}

function git_commit_honoring_mtime() {( [ git_commit_arg ... ]

	local mtime_of_commit_set ; mtime_of_commit_set=$(

		staged_git_change_lines_from_commit_porcelain "$@" |

		mtime_lines_from_staged_git_change_lines |

		sort -n | tail -1

	) || return

	local date_from_mtime; date_from_mtime=$(

		date_time_from_seconds_since_unix_epoch "${mtime_of_commit_set:?}"

	) || return

	export GIT_AUTHOR_DATE="${date_from_mtime:?}"

	export GIT_COMMITTER_DATE="${date_from_mtime:?}"

	git commit "$@"
)}

function mtime_lines_from_staged_git_change_lines() { # ...

	local op_index op_work_tree pn_current pn_original

	while true ; do

		IFS= read -r op_index       || return 0
		IFS= read -r op_work_tree   || return 2
		IFS= read -r pn_current     || return 2
		IFS= read -r pn_original    || return 2

		local pn=

		case "${op_index:?}" in
		(D)
			case "${op_work_tree:?}" in
			(C|R)
				pn=${pn_original}
				;;

			(*|'')
				[[ -z ${pn_current} ]] ||

				pn=$(dirname "${pn_current:?}")
				;;
			esac
			;;

		(*|'')
			pn=${pn_current}
			;;
		esac

		[[ -z ${pn} ]] || mtime_of_file "${pn:?}"
	done
}

function mtime_of_file() { # file_pn

	perl -e '
		use Time::HiRes qw(lstat);

		##

		my $value = shift;

		my $result = (lstat($value))[9];

		print "$result$/";

	' "${1:?}";
}

function staged_git_change_lines_from_commit_porcelain() { # [ git_commit_arg ... ]

	git commit --porcelain -z "$@" | 

	staged_git_change_lines_from_commit_porcelain_v1_lines
}

function staged_git_change_lines_from_commit_porcelain_v1_lines() { #

	(egrep '^[A-Z]' || :) | # only changes that would be committed

	staged_git_change_lines_from_status_porcelain_v1_lines
}

function staged_git_change_lines_from_status_porcelain() { # [ git_status_arg ... ]

	git status --porcelain -z "$@" |

	staged_git_change_lines_from_status_porcelain_v1_lines
}

function staged_git_change_lines_from_status_porcelain_v1_lines() { #

	(egrep -v '^#' || :) | # omit porcelain header lines

	perl -0 -ne '

		# format specified by git-status(1)

		exit 2 unless m#^(.)(.) (.*)$#;

		my ($op_index, $op_work_tree, $pn_current, $pn_original) = ($1, $2, $3, "");

		print "$op_index\n$op_work_tree\n$pn_current\n";

		if ( $op_index =~ m#^[CR]$# || $op_work_tree =~ m#^[CR]$# ) {

			exit 2 if eof;  $pn_original = <>;
		}

		print "$pn_original\n";
	';
}

##
## core logic:
##

function main() { # ...

	git_commit_honoring_mtime "$@"
}

! [[ ${0} == ${BASH_SOURCE} ]] || main "$@"

