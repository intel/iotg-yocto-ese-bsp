# Compatibility symlinks for the removed kernel-sign.bbclass
# do not use together.
#
# All users should transition away from kernel-sign.bbclass
# to use ese-image-features.bbclass where the image is signed
# in image do_rootfs post-processing stage instead of as part
# of the kernel build step.
#
# Creates kernel-package-name symlinks so mender-grubconf has
# some consistent way of reaching them, regardless of versions
# and/or suffix names eg:
#
# symlink -> kernel image
# bzImag-kernel -> bzImage-5.4.66-intel-lts
# bzImage-${BPN}-kernel -> bzImage-5.4.66-intel-lts (where KERNEL_PACKAGE_NAME is "kernel")
# bzImage-linux-intel-ese-lts-rt-5.4-kernel -> bzImage-5.4.61-rt37-intel-preempt-rt
#
kernel_do_install:append() {
	ln -s "${KERNEL_IMAGETYPE}-${KERNEL_VERSION}" "${D}/${KERNEL_IMAGEDEST}/${KERNEL_IMAGETYPE}-${KERNEL_PACKAGE_NAME}"
	if test "${KERNEL_PACKAGE_NAME}" = "kernel"; then
		ln -s "${KERNEL_IMAGETYPE}-${KERNEL_VERSION}" "${D}/${KERNEL_IMAGEDEST}/${KERNEL_IMAGETYPE}-${BPN}-${KERNEL_PACKAGE_NAME}"
	fi
}
python(){
  kpn = d.getVar('KERNEL_PACKAGE_NAME')
  dest = d.getVar('KERNEL_IMAGEDEST')
  ktype = d.getVar('KERNEL_IMAGETYPE')
  bpn = d.getVar('BPN')
  package = 'FILES:%s-image-%s' % (kpn, ktype.lower())

  d.appendVar(package, " /%s/%s-%s" % (dest, ktype, kpn))
  if kpn == 'kernel':
    d.appendVar(package, " /%s/%s-%s-%s" % (dest, ktype, bpn, kpn))
}
