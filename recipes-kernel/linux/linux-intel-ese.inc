require recipes-kernel/linux/linux-yocto.inc
require recipes-kernel/linux/meta-intel-compat-kernel.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-config:${THISDIR}/files:"

LINUX_KERNEL_TYPE = "standard"
LINUX_VERSION_EXTENSION = "-intel-ese-${LINUX_KERNEL_TYPE}"
PV = "${LINUX_VERSION}+git${SRCPV}"

DEPENDS += "util-linux-native openssl-native elfutils-native lz4-native"

# To fix do_configure issue
do_kernel_configme[depends] += "${PN}:do_prepare_recipe_sysroot"

BSPSUBTYPE_x86-64 = "x86"
BSP_SUBTYPE ??= "${BSPSUBTYPE}"

### workaround to prevent signed modules from being stripped
INHIBIT_PACKAGE_STRIP = "${@bb.utils.contains('DISTRO_FEATURES', 'hardened', '1', '0', d)}"

########
# from yocto kernel cache
########

KERNEL_FEATURES_append_x86-64 = " bsp/intel-x86/intel-x86.scc"

KERNEL_FEATURES_append_x86-64 = " \
cfg/paravirt_kvm.scc \
cgl/cfg/iscsi.scc \
features/criu/criu-enable.scc \
features/debug/printk.scc \
features/intel-persistent-memory/intel-x86-64-pmem.scc \
features/kvm/qemu-kvm-enable.scc \
features/latencytop/latencytop.scc \
features/module-signing/signing.scc \
features/mpx/mpx.scc \
features/netfilter/netfilter.scc \
features/nf_tables/nf_tables.scc \
features/security/security.scc \
features/taskstats/taskstats.scc \
"

##########
# x86_64
##########
KERNEL_FEATURES_append_x86-64 = " bsp/${BSP_SUBTYPE}/intel-dev.scc"

# qemu virtio guest
KERNEL_FEATURES_append_x86-64 = " bsp/${BSP_SUBTYPE}/virtio-guest.scc"

# kernel security harderning that may interfere with debugging
DEPENDS_append_x86-64 = " openssl-native"
INHIBIT_PACKAGE_STRIP = "1"

# are we using backport-iwlwifi?
KERNEL_FEATURES_append_x86-64 = " ${@bb.utils.contains("DISTRO_FEATURES","backport-iwlwifi", "bsp/${BSP_SUBTYPE}/no-wifi.cfg", "bsp/${BSP_SUBTYPE}/yes-wifi.cfg", d)}"

# do we want TPM?
KERNEL_FEATURES_append_x86-64 = " ${@bb.utils.contains("MACHINE_FEATURES","tpm", "bsp/${BSP_SUBTYPE}/yes-tpm.cfg", "bsp/${BSP_SUBTYPE}/no-tpm.cfg", d)}"

# from meta-virtualization, optional for zeus
include ${@bb.utils.contains('LAYERSERIES_CORENAMES', 'zeus', 'recipes-kernel/linux/linux-yocto_virtualization.inc', '', d)}

#########
# common
#########

KERNEL_FEATURES_append = "${@bb.utils.contains('DISTRO_FEATURES', 'dm-verity', ' dmverity.cfg', '', d)}"
KERNEL_FEATURES_append = "${@bb.utils.contains('DISTRO_FEATURES', 'smack', ' lsm-stacking.cfg', '', d)}"
KERNEL_FEATURES_append = "${@bb.utils.contains('DISTRO_FEATURES', 'lsm-debug', ' lsm-debug.cfg', '', d)}"
KERNEL_FEATURES_append = " common/devmem.cfg common/mod-versions.cfg"
KERNEL_FEATURES_append = " bsp/${BSP_SUBTYPE}/ipu-5-10.scc"
KERNEL_FEATURES_append = " bsp/${BSP_SUBTYPE}/vmd.scc"
KERNEL_FEATURES_append = " bsp/${BSP_SUBTYPE}/amt.scc"
KERNEL_FEATURES_append = " bsp/${BSP_SUBTYPE}/itbm.scc"

#########
# optional stub settings
#########
include recipes-kernel/linux/linux-intel-ese-internal.inc

########
# Networkproxy variant
########
BBCLASSEXTEND_append = " kernel-networkproxy:"

########
# Network boot support
########
KERNEL_FEATURES_append = "${@bb.utils.contains('MACHINE_FEATURES', 'kernel-isci-boot', ' common/isci-boot.cfg', '', d)}"
KERNEL_FEATURES_append = "${@bb.utils.contains('MACHINE_FEATURES', 'kernel-builtin-ethernet', ' common/builtin-ethernet.cfg', '', d)}"

########
# External GPUs
########
KERNEL_FEATURES_append_x86-64 = "${@bb.utils.contains('MACHINE_FEATURES', 'external-gpus', ' bsp/${BSP_SUBTYPE}/external-gpus.cfg', '', d)}"

########
# debug data, will cause huge size increase, module compression recommended
########
KERNEL_FEATURES_append = "${@bb.utils.contains('DISTRO_FEATURES', 'kernel-debug', ' common/kenel-debug.cfg', '', d)}"

########
# compress modules
########
KERNEL_FEATURES_append_x86-64 = "${@bb.utils.contains('DISTRO_FEATURES', 'kernel-compress-modules', ' common/module-compress.cfg', '', d)}"

########
# force dummy file to be pulled in so that scc can find linux-config/ files via KERNEL_FEATURES
########
SRC_URI_append = " file://dummy.scc"
