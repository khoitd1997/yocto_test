SUMMARY = "Place for tasks that don't belong to any package"
LICENSE = "CLOSED"

inherit deploy nopackages

do_configure[noexec] = "1"
do_install[noexec] = "1"
do_compile[noexec] = "1"


do_deploy() {
    # create a symlink to an easier to view directory
    symlink_dest="${KSD_TMP_CONF_DIR}/out"
    rm -f ${symlink_dest}
    ln -sfv ${DEPLOY_DIR_IMAGE} ${symlink_dest}
}

addtask do_deploy after do_compile before do_build