#!/usr/bin/env bash

: ' Insert the description of the script here

    # exit(s) status code(s)
    0 - success
    1 - fail
    '

# check if debug flag is set
if [ "${DEBUG}" = true ]; then

  set -x # enable print commands and their arguments as they are executed.
  export # show all declared variables (includes system variables)
  whoami # print current user

else

  # unset if flag is not set
  unset DEBUG

fi

# bash default parameters
set -o errexit  # make your script exit when a command fails
set -o pipefail # exit status of the last command that threw a non-zero exit code is returned
set -o nounset  # exit when your script tries to use undeclared variables

# check binaries
__HEAD=$(which head)
__TR=$(which tr)
__CUT=$(which cut)
__WHOAMI=$(which whoami)
__TAR=$(which tar)
__GPG=$(which gpg)

# warning, this will delete the original files
__remove_original=${1:-"true"}
__path=${2:-"./data"}

# generate random passphrase
readonly __passphrase=$( 
    ${__HEAD} /dev/urandom --lines 50 | 
    ${__TR} --delete --complement '[:alnum:]' | 
    ${__CUT} --characters -31
)

if [ ! -e "${__path}" ]; then

    # invalid path, exit with error
    echo "${__path}: path not found"
    exit 1

fi

# encrypt files
readonly __tar_file="${__path}/files.tar"
${__TAR} --create --file "${__tar_file}" ${__path}/* &> /dev/null || true
${__GPG} --batch --passphrase "${__passphrase}" --symmetric "${__tar_file}" &> /dev/null || true


if [ "${__remove_original}" = "true" ]; then

    # remove original files
    find data -mindepth 1 -maxdepth 1 -not -name "*.gpg" | xargs -I{} rm -rf {}

fi

echo ${__passphrase}
