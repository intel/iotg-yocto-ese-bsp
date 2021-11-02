# stub recipe
require ./linux-intel-ese-lts-5.10.inc
require ./linux-intel-ese-lts.inc
require ./yocto-kernel-cache.inc
require recipes-kernel/linux/linux-yocto.inc
require recipes-kernel/linux/meta-intel-compat-kernel.inc

########## copied from meta-intel
DEPENDS += "elfutils-native openssl-native util-linux-native"

# For Crystalforest and Romley
KERNEL_MODULE_AUTOLOAD:append_core2-32-intel-common = " uio"
KERNEL_MODULE_AUTOLOAD:append_corei7-64-intel-common = " uio"

# Functionality flags
KERNEL_EXTRA_FEATURES ?= "features/netfilter/netfilter.scc features/security/security.scc"

# Kernel config 'CONFIG_GPIO_LYNXPOINT' goes by a different name 'CONFIG_PINCTRL_LYNXPOINT' in
# linux-intel 5.4 specifically. This cause warning during kernel config audit. So suppress the
# harmless warning for now.
KCONF_BSP_AUDIT_LEVEL = "0"
