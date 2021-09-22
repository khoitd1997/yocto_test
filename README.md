# Yocto test

## First time setup

```shell
./init_project.sh
```

## Notes

```shell
# create layer
yocto-layer create yannik
```

Overwriting system config files: https://stackoverflow.com/questions/54605656/how-to-overwrite-linux-system-files-into-the-yocto-filesystem

Add custom files: https://dornerworks.com/blog/including-custom-executables-and-libraries-in-your-embedded-linux-image-with-yocto/

## Needed Ubuntu packages

- datamash: For build plots