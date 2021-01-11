:

set -e

git_rpn="$(find-aoa . .git)" ; [ -n "${git_rpn}" ]

x="${git_rpn%.git}" ; x="${x%/}" ; x="${x:-.}"

current_working_tree_root_rpn="${x:?}"

(cd "${current_working_tree_root_rpn:?}" && pwd)
