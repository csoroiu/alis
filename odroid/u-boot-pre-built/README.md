# Packaging U-Boot 2012.07 for Odroid XU 
Files below were taken from [here][HardKernel-linux-fork]:
1. bl1.hardkernel.bin.signed
2. bl2.hardkernel.bin.signed
3. tzsw.hardkernel.bin.signed
4. u-boot.bin
5. sd_fusing.sh - merged with one from ArchLinux for other odroids

# Install U-boot
Run `sd_fusing.sh` having as parameter the device with the sd card.

# Steps to configure boot:
1. Take original `boot.ini` and rename to `boot.txt`.
2. Comment out line containing `ODROIDXU-UBOOT-CONFIG` string.
3. After each modification of `boot.txt` run `mkscr`.

[HardKernel-linux-fork]: https://github.com/hardkernel/linux/tree/odroidxu-3.4.y/tools/hardkernel/u-boot-pre-built