inherit features_check

REQUIRED_DISTRO_FEATURES = "dppsu"

inherit esw python3native

DEPENDS += "xilstandalone  video-common"

ESW_COMPONENT_SRC = "/XilinxProcessorIPLib/drivers/dppsu/src/"
ESW_COMPONENT_NAME = "libdppsu.a"

addtask do_generate_driver_data before do_configure after do_prepare_recipe_sysroot
do_prepare_recipe_sysroot[rdeptask] = "do_unpack"
