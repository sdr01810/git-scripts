#!/bin/bash
##

set -e

set -o pipefail 2>&- || :

##
## from snippet library:
##

function xx() { # ...

	echo 1>&2 "${PS4:-+}" "$@"
	"$@"
}

##
## core logic:
##

xx git format-patch --ignore-cr-at-eol "$@"

