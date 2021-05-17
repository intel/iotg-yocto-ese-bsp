KBRANCH = "5.10/yocto"
KMETA_BRANCH = "yocto-5.10"
SRCREV_meta = "6eb23a018005ebef5a4265738f2643deedaba4e2"
SRCREV_machine ?= "387c8111b7a756797d8b3078fd9d7d7b2580e01a"
LINUX_VERSION ?= "5.10.32"
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

SRC_URI_append = " file://bsp/${BSP_SUBTYPE}/audio-adl.scc"
