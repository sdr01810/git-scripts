#!/usr/bin/env perl
## Convert an issue title (including the leading or trailing issue number) to a git branch name.
## By Stephen D. Rogers, 2016-11.
## 
## Typical use:
## 
##     git branch-name-from-issue-title 'Make IDEA project settings developer-agnostic #1'
##
##     git branch-name-from-issue-title '#653 ECM: Fix estimated time remaining for non-quantify phases'
##

require 5.10.0;

##

while( $_ = shift ) {

	chomp;

	s{^(.*/)?(.*?)\s*(\#\d+)$} {$1$3 $2};

	s{\s*(/)\s*} {$1}g;

	##

	s#\s+#-#g;

	s#[^-\w/]##g;

	s#[A-Z]#\L$&\E#g;

	s#^-*(.*?)-*$#$1#;

	##

	print $_ . $/;
}
