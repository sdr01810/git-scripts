#!/bin/bash
##

source "${HOME:?}"/.bash_login.d/00.core.10.shell.10.functions.bash

##

git_slate_without_pager() { # ...

	slate

	(set -x ; wop git describe --long --tags) |&
		sed -e 's#^fatal: No names found.*#No tags found#' || :

	bl

	(set -x ; wop git ls-active-topic-branches)

	bl

	(set -x ; wop git stash list)

	bl

	(set -x ; wop git status "$@")

	bl
}

git_slate() {

        git_slate_without_pager "$@" | ${PAGER:-less}
}

git_slate_without_pager "$@"
