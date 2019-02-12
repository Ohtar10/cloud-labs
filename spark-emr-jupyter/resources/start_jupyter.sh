#!/usr/bin/env bash
#      _             _       _                   _            
#     | |           | |     (_)                 | |           
#  ___| |_ __ _ _ __| |_     _ _   _ _ __  _   _| |_ ___ _ __ 
# / __| __/ _` | '__| __|   | | | | | '_ \| | | | __/ _ \ '__|
# \__ \ || (_| | |  | |_    | | |_| | |_) | |_| | ||  __/ |   
# |___/\__\__,_|_|   \__|   | |\__,_| .__/ \__, |\__\___|_|   
#                          _/ |     | |     __/ |             
#                         |__/      |_|    |___/         
#
# Boilerplate for creating a simple bash script with some basic strictness
# checks, help features, easy debug printing.
#
# Usage:
#   start-jupyter argument
#
# Depends on:
#  list
#  of
#  programs
#  expected
#  in
#  environment
#
# Bash Boilerplate: https://github.com/alphabetum/bash-boilerplate
#
# Copyright (c) 2015 William Melody • hi@williammelody.com

# Notes #######################################################################

# Extensive descriptions are included for easy reference.
#
# Explicitness and clarity are generally preferable, especially since bash can
# be difficult to read. This leads to noisier, longer code, but should be
# easier to maintain. As a result, some general design preferences:
#
# - Use leading underscores on internal variable and function names in order
#   to avoid name collisions. For unintentionally global variables defined
#   without `local`, such as those defined outside of a function or
#   automatically through a `for` loop, prefix with double underscores.
# - Always use braces when referencing variables, preferring `${NAME}` instead
#   of `$NAME`. Braces are only required for variable references in some cases,
#   but the cognitive overhead involved in keeping track of which cases require
#   braces can be reduced by simply always using them.
# - Prefer `printf` over `echo`. For more information, see:
#   http://unix.stackexchange.com/a/65819
# - Prefer `$_explicit_variable_name` over names like `$var`.
# - Use the `#!/usr/bin/env bash` shebang in order to run the preferred
#   Bash version rather than hard-coding a `bash` executable path.
# - Prefer splitting statements across multiple lines rather than writing
#   one-liners.
# - Group related code into sections with large, easily scannable headers.
# - Describe behavior in comments as much as possible, assuming the reader is
#   a programmer familiar with the shell, but not necessarily experienced
#   writing shell scripts.

###############################################################################
# Strict Mode
###############################################################################

# Treat unset variables and parameters other than the special parameters ‘@’ or
# ‘*’ as an error when performing parameter expansion. An 'unbound variable'
# error message will be written to the standard error, and a non-interactive
# shell will exit.
#
# This requires using parameter expansion to test for unset variables.
#
# http://www.gnu.org/software/bash/manual/bashref.html#Shell-Parameter-Expansion
#
# The two approaches that are probably the most appropriate are:
#
# ${parameter:-word}
#   If parameter is unset or null, the expansion of word is substituted.
#   Otherwise, the value of parameter is substituted. In other words, "word"
#   acts as a default value when the value of "$parameter" is blank. If "word"
#   is not present, then the default is blank (essentially an empty string).
#
# ${parameter:?word}
#   If parameter is null or unset, the expansion of word (or a message to that
#   effect if word is not present) is written to the standard error and the
#   shell, if it is not interactive, exits. Otherwise, the value of parameter
#   is substituted.
#
# Examples
# ========
#
# Arrays:
#
#   ${some_array[@]:-}              # blank default value
#   ${some_array[*]:-}              # blank default value
#   ${some_array[0]:-}              # blank default value
#   ${some_array[0]:-default_value} # default value: the string 'default_value'
#
# Positional variables:
#
#   ${1:-alternative} # default value: the string 'alternative'
#   ${2:-}            # blank default value
#
# With an error message:
#
#   ${1:?'error message'}  # exit with 'error message' if variable is unbound
#
# Short form: set -u
set -o nounset

# Exit immediately if a pipeline returns non-zero.
#
# NOTE: this has issues. When using read -rd '' with a heredoc, the exit
# status is non-zero, even though there isn't an error, and this setting
# then causes the script to exit. read -rd '' is synonymous to read -d $'\0',
# which means read until it finds a NUL byte, but it reaches the EOF (end of
# heredoc) without finding one and exits with a 1 status. Therefore, when
# reading from heredocs with set -e, there are three potential solutions:
#
# Solution 1. set +e / set -e again:
#
# set +e
# read -rd '' variable <<EOF
# EOF
# set -e
#
# Solution 2. <<EOF || true:
#
# read -rd '' variable <<EOF || true
# EOF
#
# Solution 3. Don't use set -e or set -o errexit at all.
#
# More information:
#
# https://www.mail-archive.com/bug-bash@gnu.org/msg12170.html
#
# Short form: set -e
set -o errexit

# Print a helpful message if a pipeline with non-zero exit code causes the
# script to exit as described above.
trap 'echo "Aborting due to errexit on line $LINENO. Exit code: $?" >&2' ERR

# Allow the above trap be inherited by all functions in the script.
#
# Short form: set -E
set -o errtrace

# Return value of a pipeline is the value of the last (rightmost) command to
# exit with a non-zero status, or zero if all commands in the pipeline exit
# successfully.
set -o pipefail

# Set $IFS to only newline and tab.
#
# http://www.dwheeler.com/essays/filenames-in-shell.html
IFS=$'\n\t'

###############################################################################
# Environment
###############################################################################

# $_ME
#
# Set to the program's basename.
_ME=$(basename "${0}")

###############################################################################
# Debug
###############################################################################

# _debug()
#
# Usage:
#   _debug printf "Debug info. Variable: %s\n" "$0"
#
# A simple function for executing a specified command if the `$_USE_DEBUG`
# variable has been set. The command is expected to print a message and
# should typically be either `echo`, `printf`, or `cat`.
__DEBUG_COUNTER=0
_debug() {
  if [[ "${_USE_DEBUG:-"0"}" -eq 1 ]]
  then
    __DEBUG_COUNTER=$((__DEBUG_COUNTER+1))
    # Prefix debug message with "bug (U+1F41B)"
    printf "🐛  %s " "${__DEBUG_COUNTER}"
    "${@}"
    printf "――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――\\n"
  fi
}
# debug()
#
# Usage:
#   debug "Debug info. Variable: $0"
#
# Print the specified message if the `$_USE_DEBUG` variable has been set.
#
# This is a shortcut for the _debug() function that simply echos the message.
debug() {
  _debug echo "${@}"
}

###############################################################################
# Die
###############################################################################

# _die()
#
# Usage:
#   _die printf "Error message. Variable: %s\n" "$0"
#
# A simple function for exiting with an error after executing the specified
# command. The command is expected to print a message and should typically
# be either `echo`, `printf`, or `cat`.
_die() {
  # Prefix die message with "cross mark (U+274C)", often displayed as a red x.
  printf "❌  "
  "${@}" 1>&2
  exit 1
}
# die()
#
# Usage:
#   die "Error message. Variable: $0"
#
# Exit with an error and print the specified message.
#
# This is a shortcut for the _die() function that simply echos the message.
die() {
  _die echo "${@}"
}

###############################################################################
# Help
###############################################################################

# _print_help()
#
# Usage:
#   _print_help
#
# Print the program help information.
_print_help() {
  cat <<HEREDOC
      _             _       _                   _            
     | |           | |     (_)                 | |           
  ___| |_ __ _ _ __| |_     _ _   _ _ __  _   _| |_ ___ _ __ 
 / __| __/ _\` | '__| __|   | | | | | '_ \| | | | __/ _ \ '__|
 \__ \ || (_| | |  | |_    | | |_| | |_) | |_| | ||  __/ |   
 |___/\__\__,_|_|   \__|   | |\__,_| .__/ \__, |\__\___|_|   
                          _/ |     | |     __/ |             
                         |__/      |_|    |___/         


Boilerplate for creating a simple bash script with some basic strictness
checks and help features, and easy debug printing, and basic option handling.

Usage:
  ${_ME} [--options] [<arguments>]
  ${_ME} -h | --help

Options:
  -h --help                 Display this help information.
  -sh --spark-home          Set the spark home directory to use.
  -hcd --hadoop-conf-dir    Set the hadoop configuration files to use.
  -ip --listen-ip           Set the ip where jupyter will listen to http requests
  -d --detached             Set if jupyter should run in detached mode (no wait for the logs).
  
HEREDOC
}

###############################################################################
# Options
#
# NOTE: The `getops` builtin command only parses short options and BSD `getopt`
# does not support long arguments (GNU `getopt` does), so the most portable
# and clear way to parse options is often to just use a `while` loop.
#
# For a pure bash `getopt` function, try pure-getopt:
#   https://github.com/agriffis/pure-getopt
#
# More info:
#   http://wiki.bash-hackers.org/scripting/posparams
#   http://www.gnu.org/software/libc/manual/html_node/Argument-Syntax.html
#   http://stackoverflow.com/a/14203146
#   http://stackoverflow.com/a/7948533
#   https://stackoverflow.com/a/12026302
#   https://stackoverflow.com/a/402410
###############################################################################

# Parse Options ###############################################################

# Initialize program option variables.
_PRINT_HELP=0
_USE_DEBUG=0

# Initialize additional expected option variables.
_SPARK_HOME="/home/ubuntu/software/spark"
_HADOOP_CONF_DIR="/home/ubuntu/hadoop_conf"
_LISTEN_IP=""
_PYSPARK_PYTHON="/usr/bin/python3"
_PYSPARK_DRIVER_PYTHON="/usr/bin/python3"
_DETACHED=0

# _require_argument()
#
# Usage:
#   _require_argument <option> <argument>
#
# If <argument> is blank or another option, print an error message and  exit
# with status 1.
_require_argument() {
  # Set local variables from arguments.
  #
  # NOTE: 'local' is a non-POSIX bash feature and keeps the variable local to
  # the block of code, as defined by curly braces. It's easiest to just think
  # of them as local to a function.
  local _option="${1:-}"
  local _argument="${2:-}"

  if [[ -z "${_argument}" ]] || [[ "${_argument}" =~ ^- ]]
  then
    _die printf "Option requires a argument: %s\\n" "${_option}"
  fi
}

while [[ ${#} -gt 0 ]]
do
  __option="${1:-}"
  __maybe_param="${2:-}"
  case "${__option}" in
    -h|--help)
      _PRINT_HELP=1
      ;;
    --debug)
      _USE_DEBUG=1
      ;;
    -sh|--spark-home)
      _require_argument "${__option}" "${__maybe_param}"
      _SPARK_HOME="${__maybe_param}"
       shift
      ;;
    -hcd|--hadoop-conf-dir)
      _require_argument "${__option}" "${__maybe_param}"
      _HADOOP_CONF_DIR="${__maybe_param}"
       shift
      ;;
    -pp|--pyspark-python)
      _require_argument "${__option}" "${__maybe_param}"
      _PYSPARK_PYTHON="${__maybe_param}"
       shift
      ;;
    -pdp|--pyspark-driver-python)
      _require_argument "${__option}" "${__maybe_param}"
      _PYSPARK_DRIVER_PYTHON="${__maybe_param}"
       shift
      ;;
    -ip|--listen-ip)
      _require_argument "${__option}" "${__maybe_param}"
      _LISTEN_IP="${__maybe_param}"
       shift
      ;;
    -d|--detached)
      _DETACHED=1
      ;;
    --endopts)
      # Terminate option parsing.
      break
      ;;
    -*)
      _die printf "Unexpected option: %s\\n" "${__option}"
      ;;
  esac
  shift
done

###############################################################################
# Program Functions
###############################################################################

_start_jupyter() {
  _debug printf ">> Performing operation...\\n"

  export SPARK_HOME="${_SPARK_HOME}"
  export HADOOP_CONF_DIR="${_HADOOP_CONF_DIR}"
  export PYSPARK_PYTHON="${_PYSPARK_PYTHON}"
  export PYSPARK_DRIVER_PYTHON="${_PYSPARK_DRIVER_PYTHON}"

  additional_opts=""

  if ((_DETACHED))
    additional_opts="&"
  fi

  if [[ -n "${_LISTEN_IP}" ]]
  then
    jupyter notebook --no-browser --ip "${_LISTEN_IP}" $additional_opts
  else
    jupyter notebook --no-browser $additional_opts
  fi

}

###############################################################################
# Main
###############################################################################

# _main()
#
# Usage:
#   _main [<options>] [<arguments>]
#
# Description:
#   Entry point for the program, handling basic option parsing and dispatching.
_main() {
  if ((_PRINT_HELP))
  then
    _print_help
  else
    _start_jupyter "$@"
  fi
}

# Call `_main` after everything has been defined.
_main "$@"