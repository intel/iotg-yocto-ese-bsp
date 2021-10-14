# stub recipe
require ./linux-intel-ese-lts-rt-5.10.inc
require ./linux-intel-ese-lts.inc
require ./yocto-kernel-cache.inc
require recipes-kernel/linux/linux-yocto.inc
require recipes-kernel/linux/meta-intel-compat-kernel.inc

KERNEL_SRC_URI = "git://github.com/sys-oak/linux-intel-restricted-adl-beta.git;protocol=ssh;branch=${KBRANCH};name=machine"
SRC_URI = "${KERNEL_SRC_URI}"

########## copied from meta-intel
DEPENDS += "elfutils-native openssl-native util-linux-native"

