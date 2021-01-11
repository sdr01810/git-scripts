:

set -e

cd "$(git current-working-tree)"

git status.files "$@" | perl -lne 'print if -e' | xlines find |
	
	omit-meta-files | sort -u
