#!/bin/bash

# Tests for smart_copy.sh script using ./source and ./copy directories (./copy must be empty).
# If all tests have given 0, then everything is working fine.

# Function for substitution of newline character with '\n'. (Not test)
substitute_newline () {
    f_output=""
    while read line; do
        f_output+="${line}\n"
    done <<< "${1}"
    echo "${f_output}"
}

# All files, but not hidden.
all_but_not_all () {
    output="$(./smart_copy.sh -ld "source" "copy")"
    expected="$(printf "PATHS =\nsource/directory with space/text file.html\nsource/directory with space/~110_bytes\nsource/directory.png/who\nsource/simple.txt\nsource/with space.txt\nsource/without_extension\n")"
    [[ "${output}" == "${expected}" ]]
    echo $?
}

# All files, including hidden ones.
all_and_all () {
    output="$(./smart_copy.sh -lad "source" "copy")"
    expected="$(printf "PATHS =\nsource/.hidden space\nsource/.hidden.txt.zip.png\nsource/.hidden_directory/.hidden\nsource/.hidden_directory/not_hidden.txt\nsource/.hidden_file\nsource/directory with space/.xml\nsource/directory with space/text file.html\nsource/directory with space/~110_bytes\nsource/directory.png/who\nsource/simple.txt\nsource/with space.txt\nsource/without_extension\n")"
    [[ "${output}" == "${expected}" ]]
    echo $?
}

# All files bigger than 100 bytes.
bigger_than_100c () {
    output="$(./smart_copy.sh -lad -s "+100c" "source" "copy")"
    expected="$(printf "PATHS =\nsource/directory with space/~110_bytes\n")"
    [[ "${output}" == "${expected}" ]]
    echo $?
}

# All files smaller than 10 bytes.
smaller_than_10c () {
    output="$(./smart_copy.sh -lad -s "-10c" "source" "copy")"
    expected="$(printf "PATHS =\nsource/.hidden space\nsource/.hidden.txt.zip.png\nsource/.hidden_directory/.hidden\nsource/.hidden_directory/not_hidden.txt\nsource/.hidden_file\nsource/directory with space/.xml\nsource/directory with space/text file.html\nsource/directory.png/who\nsource/simple.txt\nsource/with space.txt\nsource/without_extension\n")"
    [[ "${output}" == "${expected}" ]]
    echo $?
}

# All files with .txt and .xml extensions.
only_txt_and_xml () {
    output="$(./smart_copy.sh -lad -o "txt xml" "source" "copy")"
    expected="$(printf "PATHS =\nsource/.hidden_directory/not_hidden.txt\nsource/directory with space/.xml\nsource/simple.txt\nsource/with space.txt\n")"
    [[ "${output}" == "${expected}" ]]
    echo $?
}

# All files without .txt and .xml extensions.
ignore_txt_and_xml () {
    output="$(./smart_copy.sh -lad -i "txt xml" "source" "copy")"
    expected="$(printf "PATHS =\nsource/.hidden space\nsource/.hidden.txt.zip.png\nsource/.hidden_directory/.hidden\nsource/.hidden_file\nsource/directory with space/text file.html\nsource/directory with space/~110_bytes\nsource/directory.png/who\nsource/without_extension\n")"
    [[ "${output}" == "${expected}" ]]
    echo $?
}

# All files which have .xml extension. Ignore of .txt should not work, because .xml is already not .txt file.
ignore_txt_only_xml () {
    output="$(./smart_copy.sh -lad -i "txt" -o "xml" "source" "copy")"
    expected="$(printf "PATHS =\nsource/directory with space/.xml\n")"
    [[ "${output}" == "${expected}" ]]
    echo $?
}

# Only files which bigger than 10 bytes and with .xml extension. (There are no such.)
only_xml_bigger_than_10c () {
    output="$(./smart_copy.sh -lad -o "xml" -s "+10c" "source" "copy")"
    expected="$(printf "PATHS =\n")"
    [[ "${output}" == "${expected}" ]]
    echo $?
}

# Copies all files which not hidden and which don't have .txt extension. (And then deletes afterward.)
copy_files_ignore_txt_not_hidden () {
    output="$(./smart_copy.sh -i "txt" "source" "copy")"
    ls_out="$(ls -Ra copy/source)"
    rm -r "copy/source"
    expected="$(printf "copy/source:\n.\n..\ndirectory.png\ndirectory with space\nwithout_extension\n\ncopy/source/directory.png:\n.\n..\nwho\n\ncopy/source/directory with space:\n.\n..\n~110_bytes\ntext file.html\n")"
    [[ "${ls_out}" == "${expected}" ]]
    echo $?
}

# List of all tests.
all_tests="all_but_not_all all_and_all bigger_than_100c smaller_than_10c only_txt_and_xml ignore_txt_and_xml ignore_txt_only_xml only_xml_bigger_than_10c copy_files_ignore_txt_not_hidden"

# Executes all tests.
if [[ "$0" == "$BASH_SOURCE" ]]; then
    echo "smart_copy.sh tests (0==pass 1==fail):"
    for i in $all_tests; do
        printf "    ${i}: "; eval "$i"
    done
fi
