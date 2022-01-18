# we are replacing xilinx's qemu-system-aarch64-multiarch file
# with our own since the default one doesn't work due to some
# logic bugs
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"