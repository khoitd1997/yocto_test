inherit xconfig

do_savedefconfig_append() {
    local defconfig_dest_path="${KSD_TMP_CONF_DIR}/${KSD_BUILD_ID_STR}_defconfig"
	bbplain "Copying kernel defconfig to:\n${defconfig_dest_path}\n"
    cp ${B}/defconfig ${defconfig_dest_path}
}

python do_diffconfig_append() {
    # TODO(kd): Rethink the workflow of this
    # if fragment exists then it means that there has been changes
    # so copy the fragment, otw, truncate the fragment file
    destfragment = os.path.join(
        d.getVar('KSD_TMP_CONF_DIR'), 
        f"{d.getVar('KSD_BUILD_ID_STR')}-fragment.cfg"
    )
    if os.path.exists(fragment):
        shutil.copy(fragment, destfragment)
        bb.plain("Config fragment has been copied to:\n %s" % destfragment)
    elif os.path.exists(destfragment):
        bb.plain("No difference in config so wiping out the current fragment\n")
        with open(destfragment, 'r+') as f:
            f.truncate(0)
}