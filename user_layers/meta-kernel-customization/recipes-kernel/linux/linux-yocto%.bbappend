# xconfig needs qt
# do_menuconfig[depends] += "qtchooser-native:do_populate_sysroot"
# do_menuconfig[depends] += "nativesdk:do_populate_sysroot"
# do_menuconfig[depends] += "nativesdk-qttools-tools:do_populate_sysroot"

# KCONFIG_XCONFIG_COMMAND ??= "menuconfig"
# KCONFIG_XCONFIG_ROOTDIR ??= "${B}"

# python do_xconfig() {
#     env -i bash
#     import shutil

#     config = os.path.join(d.getVar('KCONFIG_XCONFIG_ROOTDIR'), ".config")
#     configorig = os.path.join(d.getVar('KCONFIG_XCONFIG_ROOTDIR'), ".config.orig")

#     try:
#         mtime = os.path.getmtime(config)
#         shutil.copy(config, configorig)
#     except OSError:
#         mtime = 0

#     import subprocess

#     subprocess.Popen(f"make -C {d.getVar('KCONFIG_XCONFIG_ROOTDIR')}", shell=True)


#     # FIXME this check can be removed when the minimum bitbake version has been bumped
#     if hasattr(bb.build, 'write_taint'):
#         try:
#             newmtime = os.path.getmtime(config)
#         except OSError:
#             newmtime = 0

#         if newmtime > mtime:
#             bb.note("Configuration changed, recompile will be forced")
#             bb.build.write_taint('do_compile', d)
# }
# do_xconfig[depends] += "qtbase-native:do_populate_sysroot"
# do_xconfig[depends] += "nativesdk-qtbase:do_populate_sysroot"
# # do_xconfig[depends] += "qtbase-native:do_populate_sysroot"

# do_xconfig[nostamp] = "1"
# do_xconfig[dirs] = "${KCONFIG_XCONFIG_ROOTDIR}"

# addtask xconfig after do_configure

do_savedefconfig_append() {
	bbplain "Copying kernel defconfig to:\n${KSD_TMP_CONF_DIR}\n"
    cp ${B}/defconfig ${KSD_TMP_CONF_DIR}
}

python do_diffconfig_append() {
    # TODO(kd): Rethink the workflow of this
    # if fragment exists then it means that there has ben changes
    # so copy the fragment, otw, truncate the fragment file
    destfragment = os.path.join(d.getVar('KSD_TMP_CONF_DIR'), "fragment.cfg")
    if os.path.exists(fragment):
        shutil.copy(fragment, destfragment)
        bb.plain("Config fragment has been copied to:\n %s" % destfragment)
    elif os.path.exists(destfragment):
        bb.plain("No difference in config so wiping out the current fragment\n")
        with open(destfragment, 'r+') as f:
            f.truncate(0)
}