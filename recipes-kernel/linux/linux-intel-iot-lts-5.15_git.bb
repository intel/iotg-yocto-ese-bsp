require ./linux-intel-iot-lts-5.15.inc
require ./linux-intel-ese-lts.inc
require ./yocto-kernel-cache.inc
require ./linux-intel-ese.inc

LINUX_VERSION_EXTENSION:append = "-lts"
KERNEL_PACKAGE_NAME = "${PN}-kernel"
