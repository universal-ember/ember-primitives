#!/bin/bash

# https://jqplay.org/s/g1NZ1sAB_F_Q
pnpm turbo run $1 --dry-run=json \
| jq 'reduce .tasks[] as {$package,$task,$cache} ({};.[$package][$task] |= $cache)' \
| jq -R
