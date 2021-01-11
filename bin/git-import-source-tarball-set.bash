#!/usr/bin/env bash
## Import a set of source tarballs.
## By Stephen D. Rogers, 2018-04.
## 
## Typical use:
## 
##     ls -tr ~/Downloads/cweb@ftp.cs.stanford.edu/cweb*gz | xlines git import-source-tarball-set 
##

set -e
set -o pipefail 2>&1 || :

##

function source_tarball_vitals_from_stat() # source_tarball_fpn
{
	local source_tarball_fpn="${1:?missing argument: source_tarball_fpn}"

	perl -le '

		@file_stat = stat($ARGV[0]);

		print "size:${file_stat[7]}";
		print "mtime:${file_stat[9]}";

	' "${source_tarball_fpn:?}"
}

function source_tarball_vitals_from_sums() # source_tarball_fpn
{
	local source_tarball_fpn="${1:?missing argument: source_tarball_fpn}"

        echo -n "md5:"
	if command -v md5 1>&- 2>&- ; then

		md5 "${source_tarball_fpn:?}" | perl -lpe 's{^.*=\s+}{}'
	else
	if command -v md5sum 1>&- 2>&- ; then

		md5sum "${source_tarball_fpn:?}" | perl -lpe 's{\s+.*$}{}'
	else
		echo ""
	fi;fi

        echo -n "sha1:"
	if command -v shasum 1>&- 2>&- ; then

		shasum -a 1 "${source_tarball_fpn:?}" | perl -lpe 's{\s+.*$}{}'
	else
		echo ""
	fi

        echo -n "sha256:"
	if command -v shasum 1>&- 2>&- ; then

		shasum -a 256 "${source_tarball_fpn:?}" | perl -lpe 's{\s+.*$}{}'
	else
		echo ""
	fi
}

function source_tarball_vitals() # source_tarball_fpn
{
	local source_tarball_fpn="${1:?missing argument: source_tarball_fpn}"

	source_tarball_vitals_from_stat "${source_tarball_fpn:?}"

        source_tarball_vitals_from_sums "${source_tarball_fpn:?}"
}

##

function git_import_source_tarball() # source_tarball_fpn
{
	local source_tarball_fpn="${1:?missing argument: source_tarball_fpn}"

	echo "importing ${source_tarball_fpn} ..."

	create_separate_local_git_repo_on_demand
        
	local scratch_sandbox_dpn="$(create_scratch_sandbox_from_source_tarball "${source_tarball_fpn})"

}

##

function git_import_source_tarball_set() # [ source_tarball_fpn ] ...
{
	local source_tarball_fpn

	for source_tarball_fpn in "$@" ; do

		[ -n "${source_tarball_fpn}" ] || continue

		git_import_source_tarball "${source_tarball_fpn:?}"
	done
}

function main() # ...
{
	git_import_source_tarball_set "$@"
}

##

main "$@"
