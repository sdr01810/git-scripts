:

git init "$@" || exit $?

for f in "${HOME:?}"/.git.template.d/info/exclude ; do
[ -f "${f}" ] || continue
with-backup-if-supported cp "${f}" "$(git dir)"/info/exclude
done
