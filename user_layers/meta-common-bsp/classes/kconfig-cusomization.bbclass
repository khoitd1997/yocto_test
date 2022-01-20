inherit terminal

OE_TERMINAL_EXPORTS += "HOST_EXTRACFLAGS HOSTLDFLAGS TERMINFO PKG_CONFIG_PATH PKG_CONFIG_SYSROOT_DIR "
TERMINFO = "${STAGING_DATADIR_NATIVE}/terminfo"

# have to use host qt5 since the qt5-native package doesn't have enough dependency
PKG_CONFIG_PATH = "/usr/lib/x86_64-linux-gnu/pkgconfig"
HOST_EXTRACFLAGS = "${BUILD_CFLAGS} ${BUILD_LDFLAGS}"
HOSTLDFLAGS = "${BUILD_LDFLAGS}"
# per documentation in https://linux.die.net/man/1/pkg-config
# include path, etc will be prefixed with PKG_CONFIG_SYSROOT_DIR
# which is not what we want when building for host
PKG_CONFIG_SYSROOT_DIR = ""

# specify where to store config files are reference when diffing against
# when generating fragment files
KCONFIG_CACHE_DIR ?= "${B}"
CONFIG_CACHE_PATH ?= "${KCONFIG_CACHE_DIR}/.config_${P}_${MACHINE}"

DEFCONFIG_SAVE_PATH ?= "${KCONFIG_CACHE_DIR}/defconfig_${P}_${MACHINE}"

# NOTE: This function is heavily based on do_menuconfig from cml1.bbclass
python do_xconfig() {
    import shutil

    if d.getVar('KCONFIG_CACHE_DIR') == "":
        raise RuntimeError("Error: KCONFIG_CACHE_DIR is empty!")

    config = os.path.join(d.getVar('KCONFIG_CONFIG_ROOTDIR'), ".config")

    try:
        mtime = os.path.getmtime(config)
    except OSError:
        mtime = 0

    # instead of using the previous .config file as reference for diff like menuconfig, 
    # we use the one cached by copying the cached one to be .config.orig
    # which is used by the diffconfig task to genereate fragment
    cached_config = d.getVar('CONFIG_CACHE_PATH')
    config_orig = os.path.join(d.getVar('KCONFIG_CONFIG_ROOTDIR'), ".config.orig")

    # .config isn't cached yet so generate one
    if not os.path.exists(cached_config):
        bb.note("No saved .config found, generating one from current .config")
        shutil.copy(config, cached_config) 

    shutil.copy(cached_config, config_orig)

    oe_terminal("sh -c \"pkg-config --debug --cflags Qt5Core; make %s; if [ \\$? -ne 0 ]; then echo 'Command failed.'; printf 'Press any key to continue... '; read r; fi\"" % "xconfig",
                d.getVar('PN') + ' Configuration', d)

    # FIXME this check can be removed when the minimum bitbake version has been bumped
    if hasattr(bb.build, 'write_taint'):
        try:
            newmtime = os.path.getmtime(config)
        except OSError:
            newmtime = 0

        if newmtime > mtime:
            bb.note("Configuration changed, recompile will be forced")
            bb.build.write_taint('do_compile', d)
}
do_xconfig[nostamp] = "1"
do_xconfig[dirs] = "${KCONFIG_CONFIG_ROOTDIR}"

addtask xconfig after do_configure

do_savedefconfig_append() {
    bbplain "Saving defconfig to:\n${DEFCONFIG_SAVE_PATH}\n"
    cp ${B}/defconfig ${DEFCONFIG_SAVE_PATH}
}

python do_diffconfig_append() {
    import shutil

    # TODO(kd): Rethink the workflow of this
    # if fragment exists then it means that there has been changes
    # so copy the fragment, otw, truncate the fragment file
    destfragment = os.path.join(
        d.getVar('KSD_TMP_CONF_DIR'), 
        f"{d.getVar('KSD_BUILD_ID_STR')}-fragment.cfg"
    )

    bb.plain(f"\nCaching .config\n")
    shutil.copy(f"{d.getVar('B')}/.config", d.getVar('CONFIG_CACHE_PATH'))

    if os.path.exists(fragment):
        shutil.copy(fragment, destfragment)
        bb.plain("Config fragment location:\n %s" % destfragment)
    elif os.path.exists(destfragment):
        bb.warn("\nNo difference in config so wiping out the current fragment\n")
        with open(destfragment, 'r+') as f:
            f.truncate(0)

    # in do_diffconfig, after the dif is generated, they overwrite .config with the cached one
    # while a little unintuitive, it's best practice since it forces user to immediately process
    # the just generated fragment
    bb.warn("\n.config HAS BEEN RESET TO STATE THAT DOES NOT CONTAIN THE CURRENT GENERATED FRAGMENT\n")
}