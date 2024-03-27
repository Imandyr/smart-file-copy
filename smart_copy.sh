#!/bin/bash

# The main script.

# Extracts input arguments into variables.
source ./arguments_extraction.sh "$@"

# Prints arguments values if desired.
[[ "$print_values" != "n" ]] && print_options_values

# Decides whether to include hidden files or not by changing -not -regex pattern of filename.
[[ "$select_all" == "n" ]] && file_name='.*/\..*' || file_name=""

# Builds regex pattern based on given option values and finds all matching paths.
pattern+="^.*"
if [[ "${#only_extensions[@]}" -gt 0 ]]; then
    # Only files with only_extensions[@] will be permitted.
    pattern+='\.('; pattern+="$(tr ' ' '|' <<< "${only_extensions[@]}"))[^.]*$"
    paths_str="$(find "$source_dir" -type f -regextype "posix-extended" -regex "$pattern" -not -regex "$file_name" -size "${size_pattern}")"
elif [[ "${#ignore_extensions[@]}" -gt 0 ]]; then
    # only files with ignore_extensions[@] will won't be permitted.
    pattern='^[^.]+$|\.(?!('; pattern+="$(tr ' ' '|' <<< ${ignore_extensions[@]}))$)([^.]*$)"
    paths_str="$(find "$source_dir" -type f -not -regex "$file_name" -size "${size_pattern}" | grep -P "$pattern")"
else
    # All files will be permited.
    pattern+="$"
    paths_str="$(find "$source_dir" -type f -not -regex "$file_name" -size "${size_pattern}")"
fi

# Deletes $source_dir from paths so it will not be accidentally copied.
first="${#source_dir}"
[[ "${paths_str::${first}}" == $(read line <<< $paths_str; echo $line) ]] && paths_str="${paths_str: $((first + 1)) : ${#paths_str}}"

# Prints pattern and paths if desired.
[[ "$print_pattern" != "n" ]] && echo "PATTERN = '${pattern}'; FILENAME = '$file_name'"
[[ "$print_paths_list" != "n" ]] && printf "PATHS =\n${paths_str}\n"

# Copying all matched files
if [[ "$disable_copying" == "n" ]]; then
    while read line; do
        mkdir -p "${target_dir}/$(dirname "$line")"
        cp -r -p "$line" "${target_dir}/${line}"
    done <<< "${paths_str}"
fi

