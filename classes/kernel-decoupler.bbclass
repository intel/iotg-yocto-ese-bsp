# decouples kernel modules and bzImage depedencies
# and replace with dummy package (seems to be a problem with honister if it is empty)
RDEPENDS:${KERNEL_PACKAGE_NAME}-base = "${KERNEL_PACKAGE_NAME}-dummypackage"
PACKAGES:append = " ${KERNEL_PACKAGE_NAME}-dummypackage"
ALLOW_EMPTY:${KERNEL_PACKAGE_NAME}-dummypackage = "1"
