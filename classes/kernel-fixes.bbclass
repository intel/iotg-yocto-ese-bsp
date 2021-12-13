# Misc fixes
DEPENDS += "coreutils-native"
FILES:${KERNEL_PACKAGE_NAME}-base:append = " ${nonarch_base_libdir}/modules/${KERNEL_VERSION}/modules.builtin.modinfo"
