# decouples kernel modules and bzImage depedencies
RDEPENDS:${KERNEL_PACKAGE_NAME}-base:remove = "${KERNEL_PACKAGE_NAME}-image"
