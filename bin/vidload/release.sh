#!/usr/bin/env bash

# constants
readonly C_VERSION_FILE=".version"
readonly C_GEMSPEC_FILE="vidload.gemspec"
readonly C_CURRENT_VERSION="$(cat $C_VERSION_FILE)"

# args
readonly A_RELEASE_VERSION="${1:-$C_CURRENT_VERSION}"

if [ "$A_RELEASE_VERSION" != "$C_CURRENT_VERSION" ]; then
    echo "New release from v$C_CURRENT_VERSION to v$A_RELEASE_VERSION"
    echo "Updating version in '$C_VERSION_FILE' and '$C_GEMSPEC_FILE' files"

    echo "$A_RELEASE_VERSION" >$C_VERSION_FILE
    sed -i "s/$C_CURRENT_VERSION/$A_RELEASE_VERSION/g" $C_GEMSPEC_FILE
fi

gem build vidload.gemspec
gem install vidload-"$A_RELEASE_VERSION".gem
