#!/usr/bin/env bash

# args
readonly A_BUMP_LEVEL="$1"

./replace-release-tokens-dryrun.sh $A_BUMP_LEVEL CHANGELOG.md
gem bump "$A_BUMP_LEVEL" --pretend
gem tag --pretend
gem release --pretend
