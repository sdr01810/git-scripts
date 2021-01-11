:

git ls-files | perl -lne 'print if s{/[^/]*$}{} || s{^[^/]*$}{.}' | sort -u |

while read -r d1 ; do find "$d1" -depth 1 -name '*~' ; done | 

only-backup-files

