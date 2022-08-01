# stub recipe
require ./linux-intel-ese-lts-rt-5.10.inc
require ./linux-intel-ese-lts.inc
require ./yocto-kernel-cache.inc
require recipes-kernel/linux/linux-yocto.inc
require recipes-kernel/linux/meta-intel-compat-kernel.inc

########## copied from meta-intel
DEPENDS += "elfutils-native openssl-native util-linux-native"
SRC_URI:append = " file://0001-menuconfig-mconf-cfg-Allow-specification-of-ncurses-.patch \
                   file://0001-regulator-consumer-Add-missing-stubs-to-regulator-co.patch \
                 "
