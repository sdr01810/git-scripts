#!/bin/bash
##

set -e
set -x

git checkout wip.headline

git reset --hard "${1:?}"

