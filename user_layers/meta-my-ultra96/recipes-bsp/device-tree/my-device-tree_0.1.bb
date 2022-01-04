# NOTE: based heavily from: 
# third_party_layers/meta-xilinx/meta-xilinx-bsp/recipes-bsp/device-tree/device-tree.bb
# third_party_layers/meta-xilinx-tools/recipes-bsp/device-tree/device-tree.bbappend
SUMMARY = "My BSP device trees"
DESCRIPTION = "Custom Device tree for my board"
SECTION = "bsp"

# the device trees from within the layer are licensed as MIT, kernel includes are GPL
LICENSE = "MIT & GPLv2"
LIC_FILES_CHKSUM = " \
		file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302 \
		file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6 \
		"

inherit devicetree
# We only want to add the bootbin setup for Linux based builds
# For instance, baremetal won't support this
BOOTBININHERIT = "${@'bootbin-component' if d.getVar('TARGET_OS').startswith('linux') else ''}"
inherit xsctdt xsctyaml ${BOOTBININHERIT}

DEPENDS += "python3-dtc-native"

PROVIDES = "virtual/dtb"

BOOTBIN_BIF_FRAGMENT_zynqmp = "load=0x100000"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

S = "${WORKDIR}/git"

REPO ??= "git://github.com/xilinx/device-tree-xlnx.git;protocol=https"
BRANCH ??= "master"
BRANCHARG = "${@['nobranch=1', 'branch=${BRANCH}'][d.getVar('BRANCH') != '']}"

SRC_URI = " \
            ${REPO};${BRANCHARG} \
            file://top.dts \
            "
SRC_URI_append_my-ultra96-zynqmp = "${@bb.utils.contains('MACHINE_FEATURES', 'mipi', ' file://mipi-support-ultra96.dtsi', '', d)}"

#Based on xilinx-v2020.1
SRCREV ??= "bc8445833318e9320bf485ea125921eecc3dc97a"

DT_VERSION_EXTENSION ?= "xilinx-${XILINX_RELEASE_VERSION}"
PV = "${DT_VERSION_EXTENSION}+git${SRCPV}"

XSCTH_BUILD_CONFIG = ""
YAML_COMPILER_FLAGS ?= ""
XSCTH_APP = "device-tree"
XSCTH_MISC = " -hdf_type ${HDF_EXT}"

YAML_MAIN_MEMORY_CONFIG_my-ultra96-zynqmp ?= "psu_ddr_0"
YAML_CONSOLE_DEVICE_CONFIG_my-ultra96-zynqmp ?= "psu_uart_1"

YAML_DT_BOARD_FLAGS_my-ultra96-zynqmp ?= "{BOARD avnet-ultra96-rev1}"
YAML_DT_BOARD_FLAGS_zcu102-zynqmp ?= "{BOARD zcu102-rev1.0}"
YAML_DT_BOARD_FLAGS_zcu106-zynqmp ?= "{BOARD zcu106-reva}"
YAML_DT_BOARD_FLAGS_zcu104-zynqmp ?= "{BOARD zcu104-revc}"
YAML_DT_BOARD_FLAGS_zcu111-zynqmp ?= "{BOARD zcu111-reva}"
YAML_DT_BOARD_FLAGS_zcu1275-zynqmp ?= "{BOARD zcu1275-revb}"
YAML_DT_BOARD_FLAGS_zcu1285-zynqmp ?= "{BOARD zcu1285-reva}"
YAML_DT_BOARD_FLAGS_zcu216-zynqmp ?= "{BOARD zcu216-reva}"
YAML_DT_BOARD_FLAGS_zcu208-zynqmp ?= "{BOARD zcu208-reva}"

YAML_OVERLAY_CUSTOM_DTS = "pl-final.dts"
CUSTOM_PL_INCLUDE_DTSI ?= ""

DT_FILES_PATH = "${WORKDIR}"
DT_PADDING_SIZE = "0x1000"
DTC_FLAGS_append = "${@['', ' -@'][d.getVar('YAML_ENABLE_DT_OVERLAY') == '1']}"
KERNEL_INCLUDE_append = " ${STAGING_KERNEL_DIR}/include"

COMPATIBLE_MACHINE_zynqmp = ".*"

DT_INCLUDE_append += " ${DT_FILES_PATH} ${KERNEL_INCLUDE} ${XSCTH_WS}/${XSCTH_PROJ} "

do_configure_append () {
    if [ -n "${CUSTOM_PL_INCLUDE_DTSI}" ]; then
        [ ! -f "${CUSTOM_PL_INCLUDE_DTSI}" ] && bbfatal "Please check that the correct filepath was provided using CUSTOM_PL_INCLUDE_DTSI"
        cp ${CUSTOM_PL_INCLUDE_DTSI} ${XSCTH_WS}/${XSCTH_PROJ}/pl-custom.dtsi
    fi
}

DTB_BASE_NAME ?= "${MACHINE}-system-${DATETIME}"
DTB_BASE_NAME[vardepsexclude] = "DATETIME"

do_deploy() {
	for DTB_FILE in `ls *.dtb *.dtbo`; do
		install -Dm 0644 ${B}/${DTB_FILE} ${DEPLOYDIR}/${DTB_BASE_NAME}.${DTB_FILE#*.}
		ln -sf ${DTB_BASE_NAME}.${DTB_FILE#*.} ${DEPLOYDIR}/${MACHINE}-system.${DTB_FILE#*.}
		ln -sf ${DTB_BASE_NAME}.${DTB_FILE#*.} ${DEPLOYDIR}/system.${DTB_FILE#*.}
	done
}

EXTERNALSRC_SYMLINKS = ""