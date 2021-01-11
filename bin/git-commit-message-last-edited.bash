#!/bin/bash
##

set -e

set -o pipeline 2>&- || :

##

cmle_pn="$(git path COMMIT_EDITMSG)"

exec cat "${cmle_pn:?}"
