#!/usr/bin/env bash

# args
readonly A_BUMP_LEVEL="$1"

gem bump "$A_BUMP_LEVEL" --pretend
gem tag --pretend
gem release --pretend
