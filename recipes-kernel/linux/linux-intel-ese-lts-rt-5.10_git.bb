require ./linux-intel-ese-lts-rt-5.10.inc
require ./linux-intel-ese-lts.inc
require ./yocto-kernel-cache.inc
require ./linux-intel-ese.inc

LINUX_VERSION_EXTENSION_append = "-lts-rt"
KERNEL_PACKAGE_NAME = "${PN}-kernel"

# RT specific configuration
SRC_URI_append = " file://bsp/${BSP_SUBTYPE}/rt.cfg"

# LTS2020 specific feature configuration
SRC_URI_append = " file://bsp/${BSP_SUBTYPE}/ipmi.scc"

