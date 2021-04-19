KBRANCH = "5.10/preempt-rt"
KMETA_BRANCH = "yocto-5.10"
SRCREV_meta = "eb09284047fec2f09d62068c338ae320c6681bd1"
SRCREV_machine ?= "2670feac93f6584edd9bdf8d85fa315c6eafa9bd"
LINUX_VERSION ?= "5.10.25"
LINUX_KERNEL_TYPE = "preempt-rt"
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

SRC_URI_append = " file://bsp/${BSP_SUBTYPE}/audio-adl.scc"
