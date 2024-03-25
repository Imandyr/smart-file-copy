#!/bin/bash

# Extracts input arguments into variables.
source ./arguments_extraction.sh "$@"

# Prints arguments values if desired.
[[ $print_values != "n" ]] && print_options_values

# Makes target directory if it does not exists already.
mkdir -p "$target_dir"

# Decides whether to include hidden files or not by changing glob pattern of filename.
[[ $select_all == "n" ]] && file_name="[^.]*" || file_name="*"

# Builds regex pattern based on given option values and finds all matching paths.
pattern+="^.*"
if [[ ${#only_extensions[@]} -gt 0 ]]; then
    pattern+='\.('; pattern+="$(tr ' ' '|' <<< ${only_extensions[@]}))$"
    paths=( $(find "$source_dir" -regextype "posix-extended" -regex "$pattern" -size "${size_pattern}" -iname "$file_name") )
elif [[ ${#ignore_extensions[@]} -gt 0 ]]; then
    pattern+='\.(?!'; pattern+="$(tr ' ' '|' <<< ${ignore_extensions[@]}))[^./]*$"
    paths=( $(find "$source_dir" -size "${size_pattern}" -iname "$file_name" | grep -P "$pattern") )
else
    pattern+="$"
    paths=( $(find "$source_dir" -regextype "posix-extended" -regex "$pattern" -size "${size_pattern}" -iname "$file_name") )
fi

# Deletes $source_dir from paths so it will not be accidentally copied.
[[ ${paths[0]} == "$source_dir" ]] && paths=( "${paths[@]:1}" )

# Prints pattern and paths if desired.
[[ $print_pattern != "n" ]] && echo "PATTERN = '${pattern}'"
[[ $print_paths_list != "n" ]] && echo "PATHS = [ "${paths[@]}" ]"

# Copying all matched files
[[ $disable_copying == "n" ]] && cp -r "$paths" "$target_dir"
