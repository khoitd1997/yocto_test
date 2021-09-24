# Yocto test

## First time setup

```shell
./init_project.sh
```

## Notes

**When a build is running, bitbake is not usable**

All `TODO` are in the form: `TODO(kd): ...`

```shell
# create layer
yocto-layer create yannik
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

```
gawk wget git-core diffstat unzip texinfo gcc-multilib
build-essential chrpath socat libsdl1.2-dev xterm python3 tar
```