SUMMARY = "Convenience packagegroup to pull in all kernels"
# KERNEL_IMAGE_INSTALL = "${PREFERRED_PROVIDER_virtual/kernel} linux-intel-ese-lts-rt-5.4 ..."

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

PACKAGE_ARCH = "${MACHINE_ARCH}"
inherit packagegroup

do_package[vardeps] += "KERNEL_IMAGE_INSTALL PREFERRED_PROVIDER_virtual/kernel IMAGE_FEATURES"
python(){
  kernels = d.getVar('KERNEL_IMAGE_INSTALL')
  vk = d.getVar('PREFERRED_PROVIDER_virtual/kernel')
  pn = d.getVar('PN')
  image_features = d.get('IMAGE_FEATURES')

  install = {
    pn + '-image': [],
    pn + '-dev' : [],
    pn + '-modules': [],
    pn + '-image-sblimage': []
  }
  for k in kernels.split() or []:
    if k == vk:
      k = 'kernel'
    else:
      k = k + '-kernel'
    install[pn + '-image'].append(k + '-image')
    install[pn + '-dev'].append(k + '-dev')
    install[pn + '-modules'].append(k + '-modules')
    install[pn + '-image-sblimage'].append(k + '-image-sblimage')

  subpackages = sorted(install.keys())
  d.setVar('PACKAGES', '%s %s' % (pn, ' '.join(sorted(subpackages))))
  for k in subpackages:
    d.setVar('ALLOW_EMPTY_' + k, '1')
    d.setVar('RDEPENDS_' + k, ' '.join(install[k]))

  rdepends = [pn + '-image', pn + '-modules']
  if 'dev-pkgs' in image_features:
    rdepends.append(pn + '-dev')
  if 'slimboot' in image_features:
    rdepends.append(pn + '-image-sblimage')
  d.setVar('RDEPENDS_' + pn, ' '.join(rdepends))
  d.setVar('ALLOW_EMPTY_' + pn, '1')
}

KERNEL_IMAGE_INSTALL ??= "${PREFERRED_PROVIDER_virtual/kernel}"
# linux-intel-ese-lts-rt-5.4 linux-intel-ese-lts-5.4-networkproxy linux-intel-ese-lts-rt-5.4-networkproxy"
