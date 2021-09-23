# Yocto test

## First time setup

```shell
./init_project.sh
```

## Notes

All `TODO` are in the form: `TODO(kd): ...`

```shell
# create layer
yocto-layer create yannik
```

Overwriting system config files: https://stackoverflow.com/questions/54605656/how-to-overwrite-linux-system-files-into-the-yocto-filesystem

Add custom files: https://dornerworks.com/blog/including-custom-executables-and-libraries-in-your-embedded-linux-image-with-yocto/

## Needed Ubuntu packages

- datamash: For build plots

From the Yocto quickstart:

```
gawk wget git-core diffstat unzip texinfo gcc-multilib
build-essential chrpath socat libsdl1.2-dev xterm python3 tar
```