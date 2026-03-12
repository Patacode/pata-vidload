#!/usr/bin/env bash

# args
readonly A_BUMP_LEVEL="$1"

# constants
readonly C_NEXT_VERSION="$(./get-next-release-version.sh $A_BUMP_LEVEL)"
readonly C_CURRENT_DATE="$(date +%d/%m/%Y)"
readonly C_ANSI_BOLD_LIGHT_GREEN="\033[1;92m"
readonly C_ANSI_BOLD_LIGHT_RED="\033[1;91m"
readonly C_ANSI_BOLD_WHITE="\033[1;97m"
readonly C_ANSI_RESET="\033[0m"

# functions
print_custom_txt() {
    local txt="$1"
    printf "$C_ANSI_BOLD_WHITE===========================$C_ANSI_RESET->> "
    printf "$txt\n"
}

replace_token() {
    local token="$1"
    local value="$2"
    local file="$3"

    sed -i -e "s|__${token}__|$value|g" "$file"
}

replace_release_tokens() {
    local file="$1"

    replace_token GEM_VER "$C_NEXT_VERSION" "$file"
    replace_token CUR_DT "$C_CURRENT_DATE" "$file"
}

print_header() {
    local file="$1"
    print_custom_txt "Replacement in $C_ANSI_BOLD_WHITE$file$C_ANSI_RESET file"
}

print_before() {
    local file="$1"
    printf "$C_ANSI_BOLD_LIGHT_RED<<<<<<<<<< Before$C_ANSI_RESET\n"
    cat "$file"
}

print_after() {
    local file="$1"
    printf "$C_ANSI_BOLD_LIGHT_GREEN>>>>>>>>>> After$C_ANSI_RESET\n"
    cat "$file"
}

for file in "${@:2}"; do
    cat "$file" >.tmp
    print_header "$file"

    print_before .tmp
    replace_release_tokens .tmp
    print_after .tmp
done

rm -f .tmp
