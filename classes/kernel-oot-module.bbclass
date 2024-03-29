# TODO: Handle DEPENDS of ^kernel-module
# We can't know the ${KERNEL_PACKAGE_NAME}-modules-* until do_multikernel_setup has run
# use overrides style like DEPENDS:pn-linux-intel-mainline-5.4-backport-iwlwifi for now.

# See also kernel-oot-mod-scripts.bbclass
python multikernel_virtclass_handler() {
    import re
    if 'kernel-oot-module' not in d.getVar('BBCLASSEXTEND'):
        bb.fatal("Bad kernel-oot-module usage!")

    provider = d.getVar("BBEXTENDVARIANT")
    pn = d.getVar('PN')

    # fix up FILESEXTRAPATHS that depend on PN due to the rename later
    d.appendVar('FILESEXTRAPATHS', d.expand('${THISDIR}/${PN}:'))

    # new PN to allow parallel installs
    d.setVar('PN', provider + '-' + pn)

    # Check DEPENDS
    depends = d.getVar('DEPENDS')
    warn = 0
    for dep in depends.strip().split():
        if re.match('^kernel-modules-', dep):
            warn = 1

    if warn:
        bb.warn('%s has kernel-modules-* in DEPENDS, kernel-oot-module is currently not able to handle depedencies yet, please manually specify with DEPENDS:pn-%s-%s' % (pn, provider, pn))

    # force update variables to use symlink areas (created by kernel do_multikernel_setup task)
    newroot = d.expand('${TMPDIR}/work-shared/${MACHINE}/multikernel/%s' % provider)
    d.setVar('STAGING_KERNEL_DIR', '%s/source' % newroot)
    d.setVar('STAGING_KERNEL_BUILDDIR', '%s/build' % newroot)

    # wait for symlink
    d.appendVarFlag('do_configure', 'depends', ' %s:do_multikernel_setup' % provider)

    # KBUILD_EXTRA_SYMBOLS should no longer need to be modified if ${PN} is updated

    # assume users know what they're doing, workaround for dpdk-module that sets COMPATIBLE_MACHINE to null in meta-dpdk
    # but set to intel-corei7-64 in meta-intel. Unfortunately, meta-intel only sets the overrides for the unprefixed recipe.
    oot_message = """
***********************************************************************
*** Recipe mc:{1}:{0} sets COMPATIBLE_MACHINE to 'null' but the multikernel
*** out-of-tree system is used to extend it. The original recipe may have
*** it overidden elsewhere, overriding it to {3} in mc:{1}:{2}-{0}.
*** This may not be the right thing to do if this out of tree module
*** is not supposed to be built with {2} or {3}.
***********************************************************************
"""

    compat = d.getVar('COMPATIBLE_MACHINE')
    machine = d.getVar('MACHINE')
    mc = d.getVar('BB_CURRENT_MC')
    if compat == 'null':
      bb.warn(oot_message.format(pn, mc, provider, machine))
      d.setVar('COMPATIBLE_MACHINE', machine)
}

export KERNEL_VERSION = "${@oe.utils.read_file('${STAGING_KERNEL_BUILDDIR}/abiversion')}"
export KERNEL_PACKAGE_NAME = "${@oe.utils.read_file('${STAGING_KERNEL_BUILDDIR}/kernel-package-name')}"

addhandler multikernel_virtclass_handler
multikernel_virtclass_handler[eventmask] = "bb.event.RecipePreFinalise"
