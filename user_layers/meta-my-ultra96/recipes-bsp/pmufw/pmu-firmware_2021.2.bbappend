YAML_COMPILER_FLAGS_append_my-ultra96-zynqmp = " -DENABLE_MOD_my-ultra96-zynqmp ${@bb.utils.contains('ULTRA96_VERSION', '2', ' -DULTRA96_VERSION=2 ', ' -DULTRA96_VERSION=1 ', d)}"