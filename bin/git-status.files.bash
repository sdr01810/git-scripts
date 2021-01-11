:

set -e

cd "$(git current-working-tree)"

git status --porcelain "$@" | perl -lne '

	next unless s{^.. }{} ;
	
	s{ -> }{$/} ;
	
	print
';
