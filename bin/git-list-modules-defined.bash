#!/bin/bash
##

vcs_root="$(find-aoa . .git)"

work_tree_root="$(dirname "${vcs_root:?}")"

cat "${work_tree_root:?}"/.gitmodules | perl -lne '

	print if s{^.*?submodule\s+"([^"]+)".*} {$1}
';

