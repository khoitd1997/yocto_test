FILESEXTRAPATHS_prepend_my-ultra96-zynqmp := "${THISDIR}/files:"

EXTRA_OVERLAYS_append_my-ultra96-zynqmp = " top.dtsi "
# EXTRA_DT_FILES_append_my-ultra96-zynqmp = "${@bb.utils.contains('MACHINE_FEATURES', 'mipi',' mipi-support-ultra96.dtsi ', '', d)}"
