require libdrm.inc

SRC_URI = "file://libdrm-2.4.60"

FILESEXTRAPATHS_prepend := "${THISDIR}:"

S = "${WORKDIR}/libdrm-2.4.60"
