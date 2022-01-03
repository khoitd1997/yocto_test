#!/bin/bash
# NOTE: This should be used most of the time for nuclear clean build
# since it wipes out most of the cache without wiping out
# the downloaded files which should rarely ever change
# and save time from having to redownload things

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source "${script_dir}/common.sh"

clean_sstate