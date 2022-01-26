#!/bin/bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source "${script_dir}/common.sh"

source_oe_init_script

bitbake -c do_vscode_to_workspace_sources_dir misc-task