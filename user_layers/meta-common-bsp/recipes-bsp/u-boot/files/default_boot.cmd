setenv bootargs $bootargs root=/dev/ram0 rw rootwait earlycon clk_ignore_unused
fatload mmc 0 0x19000000 fitImage
bootm 0x19000000