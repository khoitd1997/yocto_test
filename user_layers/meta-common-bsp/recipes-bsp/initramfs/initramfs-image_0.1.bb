# NOTE: Based heavily on core-image-minimal-initramfs.bb and core-image-minimal.bb
# the original one doesn't support aarch64 so we create our own

inherit core-image fitImage

SUMMARY = "An initramfs that basically functions as rootfs. This is different from core-image-minimal-initramfs.bb which functions like a traditional ramdisk on Ubuntu that does early boot preparation and then pass it onto the main rootfs."

IMAGE_FSTYPES += "cpio.zst"

IMAGE_INSTALL = "packagegroup-core-boot ${CORE_IMAGE_EXTRA_INSTALL}"

# IMAGE_INSTALL_append = " zeromq zstd "

IMAGE_LINGUAS = " "

LICENSE = "MIT"

IMAGE_ROOTFS_SIZE ?= "8192"
IMAGE_ROOTFS_EXTRA_SPACE_append = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " + 4096", "" ,d)}"