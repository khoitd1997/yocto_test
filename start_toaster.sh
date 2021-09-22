#!/bin/bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source ${script_dir}/common.sh

source toaster stop ${toaster_args}

source toaster start ${toaster_args}
firefox ${toaster_url}