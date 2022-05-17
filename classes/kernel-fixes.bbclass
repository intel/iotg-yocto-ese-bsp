# Misc fixes
DEPENDS += "coreutils-native"
FILES:${KERNEL_PACKAGE_NAME}-base:append = " ${nonarch_base_libdir}/modules/${KERNEL_VERSION}/modules.builtin.modinfo"

# Fix "Nothing RPROVIDES" error when explicitly installing kernel module packages.
# Removing "virtual/kernel" from "PROVIDES" for all kernel recipes
# to which "KERNEL_PACKAGE_NAME" is not set to default "kernel".
python() {
  import re
  pn = d.getVar('PN')
  pref = d.getVar('PREFERRED_PROVIDER_virtual/kernel')
  kpn = d.getVar('KERNEL_PACKAGE_NAME')
  # Remove 'virtual/kernel' from PROVIDES
  if pref != pn and kpn != 'kernel':
    prov = d.getVar('PROVIDES')
    subprov = re.sub('virtual/kernel', '', prov)
    d.setVar('PROVIDES', subprov)
}
