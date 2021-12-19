inherit deploy

SUMMARY = "PMU ROM"
DESCRIPTION = "Pmu ROM for use with QEMU"
SECTION = "devel"

LICENSE = "CLOSED"

SRC_URI = "file://pmu-rom.elf"

do_deploy () {
    install ${WORKDIR}/pmu-rom.elf ${DEPLOYDIR}
}

addtask deploy after do_compile