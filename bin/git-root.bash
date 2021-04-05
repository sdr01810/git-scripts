#!/bin/bash
## List the pathname of the git repository root
##
## Typical uses:
##
##     cd $(git root)
##

exec git rev-parse --show-toplevel
