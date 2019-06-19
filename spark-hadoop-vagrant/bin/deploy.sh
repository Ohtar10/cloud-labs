#!/usr/bin/env bash

printf "\\n\e[1m%s\e[0m\\n\\n" "Deploying Hadoop-Spark lab..."

cd "$( dirname "${BASH_SOURCE:-$0}")"
_SOURCE="${BASH_SOURCE[0]}"
while [ -h "$_SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  _DIR="$( cd -P "$( dirname "$_SOURCE" )" >/dev/null 2>&1 && pwd )"
  _SOURCE="$(readlink "$_SOURCE")"
  [[ $_SOURCE != /* ]] && _SOURCE="$_DIR/$_SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
_DIR="$( cd -P "$( dirname "$_SOURCE" )" >/dev/null 2>&1 && pwd )"

