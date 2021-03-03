# overrides module-base and module class
python() {
  pn = d.getVar('PN')
  for tag in d.getVarFlags('KERNEL_PROVIDERS') or '':
    providers = d.getVarFlag('KERNEL_PROVIDERS', tag) or ''
    for prov in providers.strip().split():
      d.appendVar('BBCLASSEXTEND', ' kernel-oot-module:%s' % prov)
}
