SUMMARY = "Place for tasks that don't belong to any package"
LICENSE = "CLOSED"

inherit deploy nopackages
inherit terminal

OE_TERMINAL_EXPORTS += ""

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
python do_flash() {
    script_path=f"{d.getVar('WORKDIR')}/flash_image_script.sh"
    image_path=d.expand("${DEPLOY_DIR_IMAGE}/initramfs-image-${MACHINE}.tar.gz")

    oe_terminal(f"bash '{script_path}' '{image_path}'", "Image Flash", d)
}

addtask do_deploy after do_compile before do_build

addtask do_flash after do_deploy
do_flash[nostamp] = "1"