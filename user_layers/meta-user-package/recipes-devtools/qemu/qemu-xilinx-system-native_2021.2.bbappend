# for version 2021.2, the Xilinx qemu recipes remove the wrong files
# since they remove from ${D}${datadir}/${BPN} which doesn't exist
# so we add in correct commands to remove them
do_install_append() {
    rm -f ${D}${datadir}/qemu/trace-events-all
    rm -rf ${D}${datadir}/qemu/keymaps
    rm -rf ${D}${datadir}/icons
}