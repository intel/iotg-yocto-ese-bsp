PERF_SRC:append ?= "scripts/ \
             arch/${ARCH}/Makefile \
"

do_configure[prefuncs] += "copy_perf_source_from_kernel"
python copy_perf_source_from_kernel() {
    sources = (d.getVar("PERF_SRC") or "").split()
    src_dir = d.getVar("STAGING_KERNEL_DIR")
    dest_dir = d.getVar("S")
    bb.utils.mkdirhier(dest_dir)
    for s in sources:
        src = oe.path.join(src_dir, s)
        dest = oe.path.join(dest_dir, s)
        if not os.path.exists(src):
            bb.fatal("Path does not exist: %s. Maybe PERF_SRC does not match the kernel version." % src)
        if os.path.isdir(src):
            oe.path.copyhardlinktree(src, dest)
        else:
            src_path = os.path.dirname(s)
            os.makedirs(os.path.join(dest_dir,src_path),exist_ok=True)
            bb.utils.copyfile(src, dest)
}
