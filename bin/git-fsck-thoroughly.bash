#!/bin/bash

(cd "$(git rev-parse --git-dir)"/refs/heads >/dev/null 2>&1 && ls -A) |

xlines git fsck --unreachable "${@:-HEAD}"
