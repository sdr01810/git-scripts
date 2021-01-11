#!/bin/bash

set -e

git branch | perl -lne '

	next unless s{^[\s*]+(\S+/)?(bug.?fix|feature|lag|wip|(?:[-\w]+-)?\d+)([-.](?:QC\d+[-.]|local[-.]|baseline|headline|\w+line|master))?}{$1$2$3};
	#^-- active branches are feature branches and/or bug fixes and/or work in progress (wip)
	
	next if m{\.([A-Z]+)$|^([A-Z]+)\.}; # skip branches in special states: DONE, DEFUNCT, HOLD, etc.

	next if m{\.(bl|ss|cp)\d+$}; # skip branches that are baseline snapshots of other branches
	
	print;
';

