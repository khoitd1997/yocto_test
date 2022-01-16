# NOTE: based heavily on kernel-fitimage.bbclass
# the original class provides good guideline on how to assemble fit
# but we want to customize so create our own

# need some variables from uboot-config
inherit uboot-config

DEPENDS += " \
            u-boot-tools-native \
            dtc-native \
            "

COMPATIBLE_HOST = "${HOST_SYS}"

# Options for the device tree compiler passed to mkimage '-D' feature:
UBOOT_MKIMAGE_DTCOPTS ??= ""

# fitImage Hash Algo
FIT_HASH_ALG ?= "sha256"

# fitImage Signature Algo
FIT_SIGN_ALG ?= "rsa2048"

#
# Emit the fitImage ITS header
#
# $1 ... .its filename
fitimage_emit_fit_header() {
	cat << EOF >> ${1}
/dts-v1/;

/ {
        description = "U-Boot fitImage for ${DISTRO_NAME}/${PV}/${MACHINE}";
        #address-cells = <1>;
EOF
}

#
# Emit the fitImage section bits
#
# $1 ... .its filename
# $2 ... Section bit type: imagestart - image section start
#                          confstart  - configuration section start
#                          sectend    - section end
#                          fitend     - fitimage end
#
fitimage_emit_section_maint() {
	case $2 in
	imagestart)
		cat << EOF >> ${1}

        images {
EOF
	;;
	confstart)
		cat << EOF >> ${1}

        configurations {
EOF
	;;
	sectend)
		cat << EOF >> ${1}
	};
EOF
	;;
	fitend)
		cat << EOF >> ${1}
};
EOF
	;;
	esac
}

#
# Emit the fitImage ITS kernel section
#
# $1 ... .its filename
# $2 ... Image counter
# $3 ... Path to kernel image
# $4 ... Compression type
fitimage_emit_section_kernel() {

	kernel_csum="${FIT_HASH_ALG}"

	ENTRYPOINT="${UBOOT_ENTRYPOINT}"
	if [ -n "${UBOOT_ENTRYSYMBOL}" ]; then
		ENTRYPOINT=`${HOST_PREFIX}nm vmlinux | \
			awk '$3=="${UBOOT_ENTRYSYMBOL}" {print "0x"$1;exit}'`
	fi

	cat << EOF >> ${1}
                kernel_${2} {
                        description = "Linux kernel";
                        data = /incbin/("${3}");
                        type = "kernel";
                        arch = "${UBOOT_ARCH}";
                        os = "linux";
                        compression = "${4}";
                        load = <${UBOOT_LOADADDRESS}>;
                        entry = <${ENTRYPOINT}>;
                        hash {
                                algo = "${kernel_csum}";
                        };
                };
EOF
}

#
# Emit the fitImage ITS DTB section
#
# $1 ... .its filename
# $2 ... Image counter
# $3 ... Path to DTB image
fitimage_emit_section_dtb() {

	dtb_csum="${FIT_HASH_ALG}"

	dtb_loadline=""
	dtb_ext=${DTB##*.}
	if [ "${dtb_ext}" = "dtbo" ]; then
		if [ -n "${UBOOT_DTBO_LOADADDRESS}" ]; then
			dtb_loadline="load = <${UBOOT_DTBO_LOADADDRESS}>;"
		fi
	elif [ -n "${UBOOT_DTB_LOADADDRESS}" ]; then
		dtb_loadline="load = <${UBOOT_DTB_LOADADDRESS}>;"
	fi
	cat << EOF >> ${1}
                fdt_${2} {
                        description = "Flattened Device Tree blob";
                        data = /incbin/("${3}");
                        type = "flat_dt";
                        arch = "${UBOOT_ARCH}";
                        compression = "none";
                        ${dtb_loadline}
                        hash {
                                algo = "${dtb_csum}";
                        };
                };
EOF
}

#
# Emit the fitImage ITS ramdisk section
#
# $1 ... .its filename
# $2 ... Image counter
# $3 ... Path to ramdisk image
fitimage_emit_section_ramdisk() {

	ramdisk_csum="${FIT_HASH_ALG}"
	ramdisk_loadline=""
	ramdisk_entryline=""

	if [ -n "${UBOOT_RD_LOADADDRESS}" ]; then
		ramdisk_loadline="load = <${UBOOT_RD_LOADADDRESS}>;"
	fi
	if [ -n "${UBOOT_RD_ENTRYPOINT}" ]; then
		ramdisk_entryline="entry = <${UBOOT_RD_ENTRYPOINT}>;"
	fi

	cat << EOF >> ${1}
                ramdisk_${2} {
                        description = "${IMAGE_BASENAME}";
                        data = /incbin/("${3}");
                        type = "ramdisk";
                        arch = "${UBOOT_ARCH}";
                        os = "linux";
                        compression = "none";
                        ${ramdisk_loadline}
                        ${ramdisk_entryline}
                        hash {
                                algo = "${ramdisk_csum}";
                        };
                };
EOF
}

#
# Emit the fitImage ITS configuration section
#
# $1 ... .its filename
# $2 ... Linux kernel ID
# $3 ... DTB image name
# $4 ... ramdisk ID
# $5 ... config ID
# $6 ... default flag
fitimage_emit_section_config() {

	conf_csum="${FIT_HASH_ALG}"
	conf_sign_algo="${FIT_SIGN_ALG}"
	if [ -n "${UBOOT_SIGN_ENABLE}" ] ; then
		conf_sign_keyname="${UBOOT_SIGN_KEYNAME}"
	fi

	# Test if we have any DTBs at all
	sep=""
	conf_desc=""
	kernel_line=""
	fdt_line=""
	ramdisk_line=""
	setup_line=""
	default_line=""
    conf_name="${3%%.*}"

	if [ -n "${2}" ]; then
		conf_desc="Linux kernel"
		sep=", "
		kernel_line="kernel = \"kernel_${2}\";"
	fi

	if [ -n "${3}" ]; then
		conf_desc="${conf_desc}${sep}FDT blob"
		sep=", "
		fdt_line="fdt = \"fdt_${3}\";"
	fi

	if [ -n "${4}" ]; then
		conf_desc="${conf_desc}${sep}ramdisk"
		conf_name="${conf_name}_with_ramdisk"
		sep=", "
		ramdisk_line="ramdisk = \"ramdisk_${4}\";"
    else
		conf_name="${conf_name}_without_ramdisk"
	fi

	if [ -n "${5}" ]; then
		conf_desc="${conf_desc}${sep}setup"
		setup_line="setup = \"setup@${5}\";"
	fi

	if [ "${6}" = "1" ]; then
		default_line="default = \"${conf_name}\";"
	fi

	cat << EOF >> ${1}
                ${default_line}
                ${conf_name} {
			description = "${6} ${conf_desc}";
			${kernel_line}
			${fdt_line}
			${ramdisk_line}
			${setup_line}
                        hash {
                                algo = "${conf_csum}";
                        };
EOF

	if [ ! -z "${conf_sign_keyname}" ] ; then

		sign_line="sign-images = "
		sep=""

		if [ -n "${2}" ]; then
			sign_line="${sign_line}${sep}\"kernel\""
			sep=", "
		fi

		if [ -n "${3}" ]; then
			sign_line="${sign_line}${sep}\"fdt\""
			sep=", "
		fi

		if [ -n "${4}" ]; then
			sign_line="${sign_line}${sep}\"ramdisk\""
			sep=", "
		fi

		if [ -n "${5}" ]; then
			sign_line="${sign_line}${sep}\"setup\""
		fi

		sign_line="${sign_line};"

		cat << EOF >> ${1}
                        signature@1 {
                                algo = "${conf_csum},${conf_sign_algo}";
                                key-name-hint = "${conf_sign_keyname}";
				${sign_line}
                        };
EOF
	fi

	cat << EOF >> ${1}
                };
EOF
}

#
# Assemble fitImage
#
# $1 ... .its filename
# $2 ... fitImage name
# $3 ... include ramdisk
fitimage_assemble() {
    set -x
	kernelcount=1
	dtbcount="1"
	DTBS=""
	ramdiskcount=${3}
	setupcount=""

    rm -f ${1}
	fitimage_emit_fit_header ${1}

	#
	# Step 1: Prepare a kernel image section.
	#
	fitimage_emit_section_maint ${1} imagestart

	fitimage_emit_section_kernel ${1} "${kernelcount}" "${DEPLOY_DIR_IMAGE}/Image" "${FITIMAGE_KERNEL_COMPRESSION}"

	#
	# Step 2: Prepare a DTB image section
	# we use device trees installed by recipes inherit from devicetree.bbclass
    # instead of KERNEL_DEVICETREE since we want to use custom device tree
    for DTB_PATH in `ls ${DEPLOY_DIR_IMAGE}/devicetree/*.dtb`; do
        DTB=`basename "${DTB_PATH}" | sed 's,\.dts$,.dtb,g'`

        DTB=$(echo "${DTB}" | tr '/' '_')
        DTBS="${DTBS} ${DTB}"
        fitimage_emit_section_dtb ${1} ${DTB} "${DTB_PATH}"
    done

	#
	# Step 4: Prepare a ramdisk section.
	#
	if [ "x${ramdiskcount}" = "x1" ] ; then
		# Find and use the first initramfs image archive type we find
		for img in cpio.lz4 cpio.lzo cpio.lzma cpio.xz cpio.gz ext2.gz cpio; do
			initramfs_path="${IMGDEPLOYDIR}/${IMAGE_BASENAME}-${MACHINE}.${img}"
			echo "Using $initramfs_path"
			if [ -e "${initramfs_path}" ]; then
				fitimage_emit_section_ramdisk ${1} "${ramdiskcount}" "${initramfs_path}"
				break
			fi
		done
	fi
    echo "Done with ramdisk"

	fitimage_emit_section_maint ${1} sectend

	# Force the first Kernel and DTB in the default config
	kernelcount=1
	if [ -n "${dtbcount}" ]; then
		dtbcount=1
	fi

	#
	# Step 5: Prepare a configurations section
	#
	fitimage_emit_section_maint ${1} confstart

	if [ -n "${DTBS}" ]; then
		counter=1
		for DTB in ${DTBS}; do
			dtb_ext=${DTB##*.}
			if [ "${dtb_ext}" = "dtbo" ]; then
				fitimage_emit_section_config ${1} "" "${DTB}" "" "" "`expr ${counter} = ${dtbcount}`"
			else
				fitimage_emit_section_config ${1} "${kernelcount}" "${DTB}" "${ramdiskcount}" "${setupcount}" "`expr ${counter} = ${dtbcount}`"
                # emit a config without ramdisk
                fitimage_emit_section_config ${1} "${kernelcount}" "${DTB}" "" "${setupcount}" ""
			fi
			counter=`expr ${counter} + 1`
		done
	fi

	fitimage_emit_section_maint ${1} sectend

	fitimage_emit_section_maint ${1} fitend

	#
	# Step 6: Assemble the image
	#
	${UBOOT_MKIMAGE} \
        ${@'-D "${UBOOT_MKIMAGE_DTCOPTS}"' if len('${UBOOT_MKIMAGE_DTCOPTS}') else ''} \
		-f "${1}" \
		"${2}"

	#
    # TODO(kd): Do more research about signing image
	# Step 7: Sign the image and add public key to U-Boot dtb
	#
	# if [ "x${UBOOT_SIGN_ENABLE}" = "x1" ] ; then
	# 	add_key_to_u_boot=""
	# 	if [ -n "${UBOOT_DTB_BINARY}" ]; then
	# 		# The u-boot.dtb is a symlink to UBOOT_DTB_IMAGE, so we need copy
	# 		# both of them, and don't dereference the symlink.
	# 		cp -P ${STAGING_DATADIR}/u-boot*.dtb ${B}
	# 		add_key_to_u_boot="-K ${B}/${UBOOT_DTB_BINARY}"
	# 	fi
	# 	uboot-mkimage \
	# 		${@'-D "${UBOOT_MKIMAGE_DTCOPTS}"' if len('${UBOOT_MKIMAGE_DTCOPTS}') else ''} \
	# 		-F -k "${UBOOT_SIGN_KEYDIR}" \
	# 		$add_key_to_u_boot \
	# 		-r arch/${ARCH}/boot/${2}
	# fi
}

assemble_fitimage_initramfs() {
    fitImage_long_name="fitImage-${IMAGE_BASENAME}"

    fitimage_assemble fit-image-initramfs-${IMAGE_BASENAME}.its ${fitImage_long_name} 1
    ln -sfv "${DEPLOY_DIR_IMAGE}/${fitImage_long_name}" "${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.itb"
    ln -sfv "${DEPLOY_DIR_IMAGE}/${fitImage_long_name}" "${DEPLOY_DIR_IMAGE}/fitImage"
}

FIT_LINK_NAME ?= "linkName"

do_create_fit_image() {
    assemble_fitimage_initramfs
}
addtask do_create_fit_image before do_image_wic
do_build[depends] += "${PN}:do_create_fit_image"

do_image_wic[depends] += "${PN}:do_create_fit_image"

do_create_fit_image[dirs] = "${DEPLOY_DIR_IMAGE}"
do_create_fit_image[depends] += "${PN}:do_image_cpio"
do_create_fit_image[depends] += "virtual/kernel:do_deploy"
do_create_fit_image[depends] += "virtual/dtb:do_deploy"