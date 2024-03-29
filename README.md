# The Smart Copy

smart_copy.sh copies files that satisfy the size and extension requirements from the source to the target directory.


# Synopsis

smart_copy.sh [OPTIONS] SOURCE TARGET


# Description

Positional arguments must be written after all short options, or else they will not be interpreted correctly.

tests.sh contains the script's tests. Run in order to check if everything works properly, or read the code to see some examples of script use.

source directory contains meaningless files that are used only for tests of tests.sh.


## Option list

- -s "PATTERN": Specifies size pattern for find command -size option. For example, "./smart_copy.sh -s "-100c" source copy" will only match files that have a size lesser than 100 bytes.

- -i "EXTENSIONS": List of file extension names in the form "ext1 ext2 ext3" (for example: "txt zip py json yaml"), which will be ignored and not copied.

- -o "EXTENSIONS": List of extension names, only files with which will be copied. If Specified, -i option will have no effect.

- -a: Includes hidden files and directories into search. Without it, they will be ignored.

- -p: Prints generated regex patterns for file paths. The first one must match, and the second one must not, or else the file path will be omitted.

- -l: Prints a list of files that will be copied.

- -v: Prints a list of script parameters and their values.

- -d: Disables files copying. Only useful for debugging.

- -h/--help: Prints README.md content and then exits without further actions.


# Requirements

This script is written for GNU bash version 5.1.16(1)-release (x86_64-pc-linux-gnu) installed on Ubuntu 22.04.4 LTS. It may or may not work properly on other Bash versions or operating systems.
