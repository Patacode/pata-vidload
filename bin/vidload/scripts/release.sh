#!/usr/bin/env bash

if [[ -n "$(git status --porcelain)" ]]; then
    echo "Uncommitted changes found. Please commit or stash. Aborting."
    exit 1
fi

# args
readonly A_BUMP_LEVEL="$1"

# functions
clean_exit() {
    local status="$1"
    rm CHANGELOG-tmp.md
    exit 1
}

./scripts/preprocess-changelog.sh CHANGELOG.md >CHANGELOG-tmp.md || clean_exit 1
./scripts/replace-release-tokens.sh $A_BUMP_LEVEL CHANGELOG-tmp.md || clean_exit 1
gem bump -t -r -v "$A_BUMP_LEVEL" || clean_exit 1
