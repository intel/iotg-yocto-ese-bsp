DEPENDS:append = " linux-firmware"
SYSROOT_DIRS:append = " ${nonarch_base_libdir}/firmware"

inherit kernel-embed-fw

python do_put_fw:append(){
    import re
    import shutil

    fw_path = do_put_fw_getdir(d)
    ucode_path = d.expand("${STAGING_DIR_TARGET}/lib/firmware/i915")

    dest = os.path.join(fw_path, 'i915')
    if os.path.isdir(dest):
        shutil.rmtree(dest)
    shutil.copytree(ucode_path, dest)
}

