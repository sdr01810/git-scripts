:

match_expression="${1:-..}" ; shift

git status --porcelain "$@" | perl -lne '

	next unless s<^'"${match_expression:?}"'\s+> <> ;
	
	##

	s{ -> .*} {}           ; # strip destination of symbolic link
	
	s{^["](.*)["]\s*} {$1} ; # strip quotes
	
	##

	print ;
';
