def do_put_fw_getdir(d):
    return d.expand("${WORKDIR}/fw-embed")

python do_put_fw_setup(){
    fw_path = do_put_fw_getdir(d)
    os.makedirs(fw_path, exist_ok=True)
}

# for callbacks to append
python do_put_fw(){
}

python do_put_fw_post(){
    import re
    import shutil

    fw_path = do_put_fw_getdir(d)
    cfgfile = d.expand("${B}/.config")
    cfgfile_temp = d.expand("${WORKDIR}/.config.fw")
    fw_list = []

    # build list of fw files
    cdir = os.getcwd()
    os.chdir(fw_path)
    for root, dirs, files in os.walk('.'):
        for fname in files:
            fw_list.append(re.sub(r'^\./', '', os.path.join(root, fname)))
    os.chdir(cdir)

    fw_str = " ".join(fw_list)

    cfg_in = open(cfgfile, 'r')
    cfg_out = os.open(cfgfile_temp, os.O_WRONLY|os.O_CREAT|os.O_TRUNC)

    for line in cfg_in:
        lineout = re.sub(r'@CONFIG_EXTRA_FIRMWARE@', fw_str, line)
        lineout = re.sub(r'@CONFIG_EXTRA_FIRMWARE_DIR@', fw_path, lineout)
        os.write(cfg_out, bytes(lineout, 'utf_8'))
    os.close(cfg_out)
    shutil.move(cfgfile_temp, cfgfile)
}

python(){
    d.appendVarFlag("do_kernel_configme", "postfuncs", " do_put_fw_setup do_put_fw do_put_fw_post")
    d.appendVar('SRC_URI', ' file://common/fw-embed.scc')
}
