# NOTE: This file is intended to modify for files such as qemu-xilinx_2021.2 which
# mainly targets nativesdk

require qemu-xilinx-common.inc

# these files were appended by upstream Yocto specifically for upstream
# qemu nativesdk but xilinx qemu nativesdk doesn't use them and they also 
# trigger fetch errors so remove them
SRC_URI_remove_class-target = " file://cross.patch"
SRC_URI_remove_class-nativesdk = " file://cross.patch"

# Have to add all datadir to FILES so that QA doesn't error out
FILES_${PN} += "${datadir}/*"