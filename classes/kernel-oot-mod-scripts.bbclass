DEPENDS += "bc-native openssl-native"

# out of tree kernel module support (replaces make-mod-scripts for non default kernels)
# maps KERNEL_PACKAGE_NAME to recipe name so that oot modules can reliably depend and use them
do_multikernel_setup(){
	unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS
	oe_runmake CC="${KERNEL_CC}" LD="${KERNEL_LD}" AR="${KERNEL_AR}" \
	HOSTCC="${BUILD_CC} ${BUILD_CFLAGS} ${BUILD_LDFLAGS}" HOSTCPP="${BUILD_CPP}" \
	-C ${STAGING_KERNEL_DIR} O=${STAGING_KERNEL_BUILDDIR} scripts prepare

	mkdir -p "${TMPDIR}/work-shared/${MACHINE}/multikernel/${PN}"
        echo "${KERNEL_PACKAGE_NAME}" > "${STAGING_KERNEL_BUILDDIR}/kernel-package-name"
        rm -f "${TMPDIR}/work-shared/${MACHINE}/multikernel/${PN}/source" "${TMPDIR}/work-shared/${MACHINE}/multikernel/${PN}/build"
	ln -sfr "${STAGING_KERNEL_DIR}" "${TMPDIR}/work-shared/${MACHINE}/multikernel/${PN}/source"
	ln -sfr "${STAGING_KERNEL_BUILDDIR}" "${TMPDIR}/work-shared/${MACHINE}/multikernel/${PN}/build"
	ln -sf  "${KERNEL_PACKAGE_NAME}-abiversion" "${STAGING_KERNEL_BUILDDIR}/abiversion"
}
do_multikernel_setup[doc] = "Multikernel support task for out of tree kernel modules"

addtask multikernel_setup after do_compile_kernelmodules before do_install

python do_multikernel_clean(){
    import os
    import shutil
    root = d.expand('${TMPDIR}/work-shared/${MACHINE}/multikernel')
    dirs = os.path.join(root, d.getVar('PN'))
    if os.path.exists(dirs):
        shutil.rmtree(dirs)
    # remove if empty
    try:
        os.rmdir(root)
    except OSError:
        bb.note("%s not empty, ignoring")
}
CLEANFUNCS:append = " do_multikernel_clean"

# force make-mod-scripts to run first to avoid race condition if it is the default kernel
python(){
  if d.getVar('KERNEL_PACKAGE_NAME') == 'kernel':
    d.appendVarFlag('do_multikernel_setup', 'depends', ' make-mod-scripts:do_compile')
}
