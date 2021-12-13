SUMMARY = "Out of tree kernel drivers convenience installer"
# see classes/kernel-oot*.bbclass
# The actual class that extends modules is in kernel-oot-base.bbclass

## Using the out-of-tree module system
# Yocto BSP allows multiple kernels to be installed but out of tree modules only compile
# against the virtual/kernel provider target, even if the KERNEL_PACKAGE_NAME system.
#
# The kernel-oot* classes is used to allow arbitrary combinations of modules and kernels.
# To register a kernel for building against out of tree modules, use the following in your
# build local.conf:
#
# KERNEL_PROVIDERS[5.4] += "linux-intel-rt"
# KERNEL_PROVIDERS[5.9] += "linux-intel-dev"
#
# The "5.4" and "5.9" part is a string that acts as a tag to signify compatibility with
# modules marked # with a similar tag. The string itself holds no significance besides
# being used for string comparisons, and can be named arbitrarily, as long as it is
# compliant with the bitbake syntax.
#
# The "linux-intel-rt" and "linux-intel-dev" is the name of the kernel recipe associated
# with the alternate kernel. Although it is possible to specify
# ${PREFERRED_PROVIDER_virtual/kernel} in KERNEL_PROVIDERS, it should not be necessary since
# the Yocto BSP module class should already cover that.
#
# To register an out of tree module recipe for build, use the following in your build
# local.conf:
#
# KERNEL_PROVIDERS_EXTRA_MODULES[5.4] += "backport-iwlwifi sgx"
# KERNEL_PROVIDERS_EXTRA_MODULES[5.9] += "backport-iwlwifi-nextgen"
#
# In this case, backport-iwlwifi and sgx recipes will build against linux-intel-rt, but not
# against linux-intel-dev because of the "5.4" tag, vice versa for backport-iwlwifi-nextgen
# and linux-intel-dev.
#
# Using IMAGE_INSTALL:append = " packagegroup-kernel-oot" will install all modules and its
# combinations into the image. To install only a subset, use "packagegroup-kernel-oot-<tag>"
# where only modules under the similar tag will be installed.

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

PACKAGE_ARCH = "${MACHINE_ARCH}"
inherit packagegroup

do_package[vardeps] += "KERNEL_PROVIDERS_EXTRA_MODULES KERNEL_PROVIDERS"
python(){
    pn = d.getVar('PN')
    tags = d.getVarFlags('KERNEL_PROVIDERS') or ''
    pkgsdict = {}
    for tag in tags:
        # ${PN}-5.4
        pkgname = pn + '-' + tag
        modlist = d.getVarFlag('KERNEL_PROVIDERS_EXTRA_MODULES', tag) or ''
        kernels = d.getVarFlag('KERNEL_PROVIDERS', tag) or ''
        pkgsdict[pkgname] = []
        for k in kernels.strip().split():
            for m in modlist.strip().split():
                pkgsdict[pkgname].append('%s-%s' % (k, m))

    pkgkeys = sorted(pkgsdict)
    # PACKAGES += ${PN}-5.4 [...]
    d.setVar('PACKAGES', '%s %s' % (pn, ' '.join(pkgkeys)))
    # ALLOW_EMPTY:${PN} = "1"
    d.setVar('ALLOW_EMPTY:' + pn, '1')
    # RDEPENDS:${PN} += ${PN}-5.4 [...]
    d.setVar('RDEPENDS:' + pn, ' '.join(pkgkeys))

    for pkg in pkgkeys:
        # ALLOW_EMPTY:${PN}-5.4 = "1"
        d.setVar('ALLOW_EMPTY:' + pkg, '1')
        # RDEPENDS:${PN}-5.4 += <kernel>-<module> [...]
        d.setVar('RDEPENDS:' + pkg, ' '.join(sorted(pkgsdict[pkg])))
}
