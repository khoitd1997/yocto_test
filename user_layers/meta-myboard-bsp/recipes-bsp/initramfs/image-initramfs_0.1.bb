# NOTE: Based heavily on core-image-minimal-initramfs.bb and core-image-minimal.bb
# the original one doesn't support aarch64 so we create our own

inherit core-image

IMAGE_ROOTFS_SIZE = "8192"
IMAGE_ROOTFS_EXTRA_SPACE = "0"

SUMMARY = "An initramfs that basically functions as rootfs. This is different from core-image-minimal-initramfs.bb which functions like a traditional ramdisk on Ubuntu that does early boot preparation and then pass it onto the main rootfs."

export IMAGE_BASENAME = "${MLPREFIX}core-image-minimal-initramfs"
IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"
IMAGE_INSTALL = "packagegroup-core-boot ${CORE_IMAGE_EXTRA_INSTALL}"

IMAGE_LINGUAS = " "

LICENSE = "MIT"

inherit core-image

IMAGE_ROOTFS_SIZE ?= "8192"
IMAGE_ROOTFS_EXTRA_SPACE_append = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " + 4096", "" ,d)}"

COMPATIBLE_HOST = "${HOST_SYS}"
