KBRANCH = "5.10/yocto"
KMETA_BRANCH = "yocto-5.10"
SRCREV_meta = "eb09284047fec2f09d62068c338ae320c6681bd1"
SRCREV_machine ?= "5005cd852c63c986a0dde501f4159838b4e78758"
LINUX_VERSION ?= "5.10.26"
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

SRC_URI_append = " file://bsp/${BSP_SUBTYPE}/audio-adl.scc"
