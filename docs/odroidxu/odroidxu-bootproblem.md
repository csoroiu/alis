# ODROID-XU Arch Linux boot problem
As stated [here][odroidxu-stuck-at-boot] there is a booting problem with the default 
[Arch Linux ARM][odroidxu-archlinux-tarball] installation package.

ODROID-XU features a sdcard slot and an emmc slot. Apparently the kernel
maps the sdcard to either mmc0 or mmc1 between 2 consecutive boots.

Also, the `boot.txt` u-boot file is configured to boot the linux kernel with the command:
```text
setenv bootrootfs "console=ttySAC2,115200n8 root=/dev/mmcblk1p2 rootwait rw"
```

Sample 1 - **mmc1** is assigned to 12220000:
```text
[alarm@odroid ~]$ ls -l /sys/devices/platform/soc/12220000.mmc/mmc_host/mmc?/
/sys/devices/platform/soc/12220000.mmc/mmc_host/mmc1/:
total 0
lrwxrwxrwx 1 root root    0 Nov 10 17:39 device -> ../../../12220000.mmc
drwxr-xr-x 4 root root    0 Nov 10 17:22 mmc1:aaaa
drwxr-xr-x 2 root root    0 Nov 10 17:39 power
lrwxrwxrwx 1 root root    0 Nov 10 17:22 subsystem -> ../../../../../../class/mmc_host
-rw-r--r-- 1 root root 4096 Nov 10 17:22 uevent
```

Sample 2 - **mmc0** is assigned to 12220000:
```text
[alarm@odroid ~]$ ls -l /sys/devices/platform/soc/12220000.mmc/mmc_host/mmc?/
/sys/devices/platform/soc/12220000.mmc/mmc_host/mmc0/:
total 0
lrwxrwxrwx 1 root root    0 Nov 10 17:43 device -> ../../../12220000.mmc
drwxr-xr-x 4 root root    0 Nov 10 17:42 mmc0:aaaa
drwxr-xr-x 2 root root    0 Nov 10 17:43 power
lrwxrwxrwx 1 root root    0 Nov 10 17:42 subsystem -> ../../../../../../class/mmc_host
-rw-r--r-- 1 root root 4096 Nov 10 17:42 uevent
```

There are 2 solutions to this problem:
- add aliases to `exynos5410-odroidxu.dtb` device tree:
```
aliases {
...
    mmc0 = "/soc/mmc@12200000";
    mmc1 = "/soc/mmc@12220000";
};
```
- change the boot command such that it uses `PARTUUID` for root partition 
and `fstab` such that it uses `PARTUUID` or `UUID` for boot partition
```text
setenv bootrootfs "console=ttySAC2,115200n8 root=PARTUUID=8477a483-02 rootwait rw
```
and 
```text
# Static information about the filesystems.
# See fstab(5) for details.

# <file system> <dir> <type> <options> <dump> <pass>
PARTUUID=8477a483-01  /boot   vfat    defaults        0       0
```
`PARTUUID`'s can be found by running `blkid` for the respective partition:
```shell
$ blkid /dev/sda1 -o export | grep PARTUUID
PARTUUID=8477a483-01
$ blkid /dev/sda2 -o export | grep PARTUUID
PARTUUID=8477a483-02
```

[odroidxu-archlinux-tarball]: https://archlinuxarm.org/platforms/armv7/samsung/odroid-xu
[odroidxu-stuck-at-boot]: https://archlinuxarm.org/forum/viewtopic.php?f=47&t=15645&sid=774fc0aa57a2750902ef86eaf1f75a40

