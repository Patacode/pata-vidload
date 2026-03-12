#!/usr/bin/env bash

# args
readonly A_BUMP_LEVEL="$1"

./scripts/replace-release-tokens-dryrun.sh $A_BUMP_LEVEL CHANGELOG.md || exit 1
gem bump -t -r -v "$A_BUMP_LEVEL" --pretend || exit 1
