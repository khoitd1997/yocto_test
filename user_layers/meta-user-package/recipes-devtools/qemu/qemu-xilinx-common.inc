# the 2021.2 version of Xilinx qemu doesn't know how to handle these arguments
# so remove them, doesn't seem to affect any functionality
EXTRA_OECONF_remove = "--with-suffix=${BPN}"
EXTRA_OECONF_remove = "--meson=meson"