# NOTE: Based mostly from u-boot-zynq-scr.bb
SUMMARY = "U-boot boot scripts for Xilinx devices"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS = "u-boot-mkimage-native"

inherit deploy nopackages

PROVIDES = "virtual/u-boot-script"

INHIBIT_DEFAULT_DEPS = "1"

COMPATIBLE_MACHINE ?= "^$"
COMPATIBLE_MACHINE_zynqmp = "zynqmp"
COMPATIBLE_MACHINE_zynq = "zynq"
COMPATIBLE_MACHINE_versal = "versal"

# can be overridden by user to select the script
# can be absolute path
UBOOT_SCRIPT_SRC ?= "${THISDIR}/files/boot.cmd"

SRC_URI = " \
            file://${UBOOT_SCRIPT_SRC} \
            "
PACKAGE_ARCH = "${MACHINE_ARCH}"

do_configure[noexec] = "1"
do_install[noexec] = "1"

do_compile() {
    set -e
    mkimage -A arm -T script -C none -n "Boot script" -d "${UBOOT_SCRIPT_SRC}" boot.scr
}

do_deploy() {
    set -e
    install -d ${DEPLOYDIR}
    install -m 0644 boot.scr ${DEPLOYDIR}/boot.scr
}

addtask do_deploy after do_compile before do_build
