#!/usr/bin/env bash

# args
readonly A_BUMP_LEVEL="$1"

# constants
readonly C_NEXT_VERSION="$(./get-next-release-version.sh $A_BUMP_LEVEL)"
readonly C_CURRENT_DATE="$(date +%d/%m/%Y)"

# functions
print_custom_txt() {
    local txt="$1"
    echo -n "------------------------------ "
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

for file in "${@:2}"; do
    cat $file >".tmp"
    print_custom_txt "Replacement in $file file"
    echo ">>>>>>>>>> Before"
    cat .tmp
    replace_release_tokens .tmp
    echo "<<<<<<<<<< After"
    cat .tmp
done

rm -f .tmp
