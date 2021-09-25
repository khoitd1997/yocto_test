#!/bin/bash

set -e

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source ${script_dir}/common.sh

# TODO: Right now credentials have to be stored in file
# Try to find a way to do this more securely
function upload_folder {
    local folder_name="${1}"
    local cd_path="${2}"

    cd ${cd_path}
    # NOTE: If the upload fails for example because the user doesn't have permissions
    # the script doens't seem to fail
    find ${folder_name} -type f -exec curl --netrc-file $script_dir/nexus_credential.txt --ftp-create-dirs -T {} http://localhost:8081/repository/test_1/{} \;
}

# upload_folder "dl" "${dl_dir}"
upload_folder "sstate" "${script_dir}"