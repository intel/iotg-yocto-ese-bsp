# kernel config cache
KERNEL_CONFIG_URI = "git://git.yoctoproject.org/yocto-kernel-cache;type=kmeta;name=meta;branch=${KMETA_BRANCH};destsuffix=${KMETA}"
KMETA = "kernel-meta"
SRC_URI_append = " ${KERNEL_CONFIG_URI}"
