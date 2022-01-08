SUMMARY = "Place for tasks that don't belong to any package"
LICENSE = "CLOSED"

inherit deploy nopackages
inherit terminal

OE_TERMINAL_EXPORTS += "MACHINE DEPLOY_DIR_IMAGE"

do_configure[noexec] = "1"
do_install[noexec] = "1"
do_compile[noexec] = "1"


do_deploy() {
    # create a symlink to an easier to view directory
    symlink_dest="${KSD_TMP_CONF_DIR}/out"
    rm -f ${symlink_dest}
    ln -sfv ${DEPLOY_DIR_IMAGE} ${symlink_dest}
}

SRC_URI += " file://flash_image_script.sh "

addtask do_deploy after do_compile before do_build

python do_flash() {
    script_path=f"{d.getVar('WORKDIR')}/flash_image_script.sh"

    oe_terminal(f"bash '{script_path}'", "Image Flash", d)
}
addtask do_flash after do_deploy
do_flash[nostamp] = "1"

python do_vscode_to_deploy_dir() {
    oe_terminal("code ${DEPLOY_DIR_IMAGE}", "Vscode", d)
}
addtask do_vscode_to_deploy_dir after do_deploy
do_vscode_to_deploy_dir[nostamp] = "1"