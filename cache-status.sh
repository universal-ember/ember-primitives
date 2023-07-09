#!/bin/bash

#
# NOTE: GitHub actions does not support json-keys
#       with special characters (:, @, etc)
#
# Why do we do this instead of javascript?
# - it's *way* faster.
# - we want to stay as true to turbo's json format as possible
#
# https://jqplay.org/s/g1NZ1sAB_F_Q
# https://jqplay.org/s/3fjQTNbPH3u
pnpm turbo run lint:types test _:lint --dry-run=json \
| jq 'reduce .tasks[] as {$package,$task,$cache} ({};
        .[$package][$task] |= $cache
      )
      ' \
| jq -c

