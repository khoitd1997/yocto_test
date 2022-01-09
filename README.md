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

```shell
run ./install_deps.sh to install deps
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

## Notes about using Kconfig

You should read this first: [Yocto reference on kernel customization](https://www.yoctoproject.org/docs/latest/kernel-dev/kernel-dev.html#configuring-the-kernel)

The final .config configuration is assembled from multiple sources(unlike in Buildroot where it's just from defconfig)

To make sure configurations aren't accidentally lost, here are some facts about how the various configuration sources are applied:

1. The defconfig file(usually come from the default of the kernel tree or come from the recipe if specified), applies first, forming the original .config file
2. Configurations fragments(ie .scc files, .cfg files) are then applied to the .config file. We will call this .config file "config A"
3. Interactive modifications using menuconfig/xconfig on top of config A, creating "config B", config B is used for compiling the code. Config B is also run through a config checker to make sure that all the configs you specified in .scc files are in the final config, if they are not, the list of configs that didn't make it will be printed out. NOTE THAT IF SOMETHING DIDN'T MAKE IT INTO THE FINAL CONFIG, IT'S NOT AN ERROR, SO MAKE SURE TO READ THE LIST CAREFULLY

config A is only regenerated when things in 1 and 2 change(ie when you modify/add defconfig files or any files related to the .scc files). WHEN CONFIG A IS REGENERATED, ALL YOUR MODIFICATIONS IN STEP 3 WILL BE WIPED OUT. To avoid this, DO NOT MODIFY THE CONFIG INTERACTIVELY AT THE SAME TIME AS MODIFYING IT TEXTUALLY(ie modifying scc, defconfig files). To switch from one mode of modifications to another, you should save your current configuration first(either as an scc configuration fragment or as defconfig file), you can do this using the various commands in `common.sh` like `generate_kernel_cfg_fragment`, `generate_kernel_defconfig`

While there are 2 ways to save your configs(defconfig vs scc files), in practice, you should exclusively use scc files, this is because:

- scc files group configs into logical features(ie like enable Etherent or customizing debug level), making maintenance easier. More info about sccc files can be found in [this chapter of Yocto Kernel Dev Manual](https://www.yoctoproject.org/docs/latest/kernel-dev/kernel-dev.html#kernel-dev-advanced)
- mixing scc files and defconfig is a bad idea since the configs will be duplicated. For example, if you have both custom configs in defconfig and fragments, the next time a new defconfig is generated, it will include not only the customizations of the original defconfig but also ones from the scc files, this is because defconfig is generated with respect to the kernel default config, not with respect to your previous config

Note that even if you don't use any scc files yourselves, third party layers almost definitely do so most of the time you are essentially forced to use the scc flow

Here is the scc flow for kernel customizations:

1. Run `show_kernel_xconfig`(replace "kernel" with things are you customizing, DO NOT USE MENUCONFIG, more on that below) from `common.sh` to get the xconfig screen
2. Make your customizations
3. Run a normal build, the kernel will be rebuilt with the option you just add, at this point you can flash the new build to the board to check out the new config
4. Repeat step 2->3 untill you are satisfied with the config
5. Run `generate_kernel_cfg_fragment` from `common.sh`, the command will print out the location of the generated fragment. After this is run, the target .config WILL BE RESET TO THE STATE WITHOUT THE JUST GENERATED FRAGMENT SO IF YOU WANT THE FRAGMENT IN THE NEXT BUILD, immediately create a .scc file for it and add it to list of scc files to be processed

The behavior of xconfig and menuconfig is different since not only is xconfig not part of the stock Yocto, it also has customizations that make generating fragment more intuitive. The difference is the files used for diffing when generating the fragment. Example:

- Menuconfig: Every time you run menuconfig, the file to diff against is updated, example
  - Start with config A, after your menuconfig, this generate config B, if fragment is generated at this point it's from A diff with B
  - Assuming fragment isn't generated in the last step, if you run menuconfig again, generating config C and fragment is generated at this point it is from C diff with B
  - As can be seen, this behavior is only helpful when you are doing a single menuconfig run per fragment, if you run menuconfig more than once before generating a fragment, the generated fragment will be missing configs since it only includes configs from the last menuconfig run

- Xconfig: The file to diff against is only updated when you generate the fragment
  - Start with config A, after your xconfig, this will generate config B, if fragment is generated at this point it's from A diff with B
  - Assuming fragment isn't generated in the last step, if you run xconfig again, generating config C and fragment is generated at this point it is from C diff with A
  - This time, you are sure that when you do generate fragment, all the configs from the last time fragment is generated are in the newly generated one
