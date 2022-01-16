# add extra path so we have access to the boot.cmd file
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
# set this to path of boot.cmd file
UBOOT_BOOT_SCRIPT ??= "default_boot.cmd"

SRC_URI += " \
            file://${UBOOT_BOOT_SCRIPT} \
            "

# the original do_compile from xilinx is very rigid and force you to use their scripts
# we define a custom one to be more flexible in taking in custom script
do_compile() {
    mkimage -A arm -T script -C none -n "Boot script" -d "${WORKDIR}/$(basename ${UBOOT_BOOT_SCRIPT})" boot.scr
}

# the original do_deploy also tries to install pxe and other stuffs that we don't need
# so make our own that only installs what we need
do_deploy() {
    install -d ${DEPLOYDIR}
    install -m 0644 boot.scr ${DEPLOYDIR}/${UBOOTSCR_BASE_NAME}.scr
    ln -sf ${UBOOTSCR_BASE_NAME}.scr ${DEPLOYDIR}/boot.scr
}