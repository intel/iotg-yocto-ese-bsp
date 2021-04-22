KERNEL_SRC_URI ?= "git://gitlab.devtools.intel.com/linux-kernel-integration/kernel-lts-staging.git;protocol=https;branch=${KBRANCH};name=machine"
SRC_URI = "${KERNEL_SRC_URI}"
