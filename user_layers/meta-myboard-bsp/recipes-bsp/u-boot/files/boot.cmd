echo "NICEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEe"

setenv bootargs $bootargs root=/dev/mmcblk0p2 rw rootwait earlycon clk_ignore_unused
fatload mmc $sdbootdev:$partid @@KERNEL_LOAD_ADDRESS@@ @@KERNEL_IMAGETYPE@@
@@KERNEL_BOOTCMD@@ @@KERNEL_LOAD_ADDRESS@@ - @@DEVICETREE_ADDRESS@@

