FILESEXTRAPATHS_prepend_my-ultra96-zynqmp := "${THISDIR}/files:"

EXTRA_OVERLAYS_append_my-ultra96-zynqmp = " top.dtsi "

SRC_URI_append_my-ultra96-zynqmp = " ${@bb.utils.contains('MACHINE_FEATURES', 'mipi','file://mipi-support-ultra96.dtsi', '', d)} "
DTC_PPFLAGS_append_my-ultra96-zynqmp = "${@bb.utils.contains('MACHINE_FEATURES', 'mipi',' -DENABLE_MIPI ', '', d)}"