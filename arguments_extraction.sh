#!/bin/bash

# Script for command-line arguments extraction.

# Initialization of variables.
size_pattern="+0c"
select_all="n"
print_pattern="n"
print_paths_list="n"
print_values="n"
disable_copying="n"
source_dir=""
target_dir=""
declare ignore_extensions
declare only_extensions

# Function to show help message.
help_func () {
    echo "${0} help:"
    cat README.md
    exit 0
}

# Function for exit with error message printed.
error_message () {
    echo "${0}: ${1}" >&2
    exit 1
}

# Function for print of current values of option variables.
print_options_values () {
    echo "OPTIONS_VALUES = {size_pattern: '${size_pattern}', select_all: '${select_all}', print_pattern: '${print_pattern}', print_paths_list: '${print_paths_list}', print_values: '${print_values}', disable_copying: '${disable_copying}', ignore_extensions: '${ignore_extensions[@]}', only_extensions: '${only_extensions[@]}', source_dir: '${source_dir}', target_dir: '${target_dir}'}"
}

# Extraction of short input options values.
while getopts s:i:o:haplvd arg; do
    case "$arg" in
        h)
            help_func;;
        a)
            select_all="y";;
        p)
            print_pattern="y";;
        l)
            print_paths_list="y";;
        v)
            print_values="y";;
        d)
            disable_copying="y";;
        s)
            if [[ "$OPTARG" =~ ^[+-]?[0-9]+[A-Za-z]*$ ]]
                then size_pattern="${OPTARG}"
                else error_message "Value '${OPTARG}' of option -s is not valid."
            fi;;
        i)
            ignore_extensions=( $OPTARG );;
        o)
            only_extensions=( $OPTARG );;
    esac
done

# Fetch remaining options.
agrs=( "$@" )
remaining=( "${agrs[@]:((OPTIND - 1))}" )

# Check if there is enough arguments.
[[ "${#remaining[@]}" -lt 2 ]] && error_message "<2 positional arguments."

# Extraction of remaining option values.
for i in "${remaining[@]}"; do
    if [[ "$i" =~ ^--help$ ]]; then
        help_func
    elif [[ "${#source_dir}" -eq 0 ]]; then
        source_dir="$i"
    elif [[ "${#target_dir}" -eq 0 ]]; then
        target_dir="$i"
    else
        error_message "Too many positional arguments."
    fi
done

