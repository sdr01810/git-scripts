#!/bin/bash
## Shorthand for: git rev-parse --git-path "$@"
## By Stephen D. Rogers, 2019-10.
## 

exec git rev-parse --git-path "$@"
