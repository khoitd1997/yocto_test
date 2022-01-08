setenv bootargs $bootargs console=ttyPS0,115200 root=/dev/mmcblk0p2 rw rootwait earlycon clk_ignore_unused
# setenv bootargs $bootargs console=ttyPS0,115200 root=/dev/ram0 rw rootwait earlycon clk_ignore_unused
fatload mmc 0 0x19000000 fitImage-initramfs
bootm 0x19000000