#!/bin/bash
## Show (only) the file names reported by 'git status'
## By Stephen Rogers, 2015-03.
##

git status . | perl -lne '

	next unless s{^\s+.*?:\s+}{};

	s{^.* -> }{};
	
	print if -e;
	
';
