python(){
    pn = d.getVar('PN')
    tags = d.getVarFlags('KERNEL_PROVIDERS') or ''
    for tag in tags:
        modlist = d.getVarFlag('KERNEL_PROVIDERS_EXTRA_MODULES', tag) or ''
        kernels = d.getVarFlag('KERNEL_PROVIDERS', tag) or ''
        for k in kernels.strip().split():
            for m in modlist.strip().split():
                pkgname = k + '-' + m
                if pn == pkgname:
                   d.appendVarFlag('do_create_runtime_spdx', 'depends', ' %s:do_create_spdx' % k)
}
