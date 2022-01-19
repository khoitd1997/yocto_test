inherit deploy

SUMMARY = "PMU ROM"
DESCRIPTION = "Pmu ROM for use with QEMU"
SECTION = "devel"

LICENSE = "CLOSED"

COMPATIBLE_HOST = ".*"

# NOTE: pmu-rom.elf can obtained from an extracted .bsp file
# instruction:
# https://github.com/Xilinx/meta-xilinx/blob/master/meta-xilinx-bsp/README.qemu.md
SRC_URI = "file://pmu-rom.elf"

do_deploy () {
    install ${WORKDIR}/pmu-rom.elf ${DEPLOYDIR}
}

addtask deploy after do_compile before do_build