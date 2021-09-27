# Yocto test

## First time setup

This repo uses git submodule to mange layers, after clone do:

```shell
git submodule init
git submodule update
```

## Notes

**When a build is running, bitbake is not usable**

All `TODO` are in the form: `TODO(kd): ...`

```shell
# create layer
bitbake-layers create-layer path-to-layer
```

Overwriting system config files: https://stackoverflow.com/questions/54605656/how-to-overwrite-linux-system-files-into-the-yocto-filesystem

Add custom files: https://dornerworks.com/blog/including-custom-executables-and-libraries-in-your-embedded-linux-image-with-yocto/

Unlike Buildroot, Yocto rebuild mechanisms is a little smarter about when to rebuild, since even all the overlay files need to be tracked in fs-overlay_0.1.bb, Yocto knows when anything changes

### Build time Result

`bitbake world` is the command to build all the possible recipes in Yocto. This is used to estimate how much size we would need if we are to host a mirror serving both src and sstate

With these layers:

- meta
- meta-poky
- meta-yocto-bsp
- meta-oe
- meta-filesystems
- meta-python
- meta-networking
- meta-fs-overlay

When about 1/3 of a task is finished, the size usage(including everything like `dl` and `sstate`) seems to be about 200 GB, with more layers, the total size would probably be `~800 GB`

For fresh build with no cache(both ssstate and dl), it takes about 75 mins with some packges for kernel+rootfs

## Needed Ubuntu packages

- datamash: For build plots

From the Yocto quickstart:

```shell
gawk wget git-core diffstat unzip texinfo gcc-multilib
build-essential chrpath socat libsdl1.2-dev xterm python3 tar texinfo
```

## Usage instructions

```shell
cd path-to-this-repo
source init_env.sh # set necessary variables and sourcing the command list
```

Due to the complexity of the build system, users are heavily encouraged to use the util functions and scripts to do what they want, for example:

```shell
# BAD EXAMPLE:
# this went around bitbake so it might break things
cd path-to-kernel-src
make xconfig

# GOOD EXAMPLE:
. init_env.sh
show_kernel_xconfig
```

Kernel customizations are now organized through kernel features(aka .scc files), thus, the defconfig files are no longer as important and is mostly generated for debugging purposes or as an intermediate step to generate .scc files. Below are some commands to generate fragments and defconfig files

```shell
. init_env.sh

# generate the current kernel defconfig to conf/tmp/defconfig
generate_kernel_defconfig

# generate the diff fragment to conf/tmp/fragment.cfg
generate_kernel_cfg_fragment
```

The `expert_scripts/` directory contains scripts geared more towards expert users that go beyond simple building and config changes

TODO(kd): U-boot build doesn't seem to be in the standard Yocto, seems like every BSP does it differently:
https://git.yoctoproject.org/cgit/cgit.cgi/meta-freescale/tree/recipes-bsp/u-boot/u-boot-imx_2017.03.bb?h=rocko
https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841883/Yocto