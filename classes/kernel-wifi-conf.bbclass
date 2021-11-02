python(){
  compatibles = d.getVar('KERNEL_PROVIDERS_EXTRA_MODULES_WIFI_COMPAT') or ''

  for c in sorted(compatibles.split()):
    kernels = d.getVarFlag('KERNEL_PROVIDERS', c) or ''
    for k in sorted(kernels.split()):
      d.setVar('DISTRO_FEATURES:append:pn-%s' % k, ' backport-iwlwifi')
}
