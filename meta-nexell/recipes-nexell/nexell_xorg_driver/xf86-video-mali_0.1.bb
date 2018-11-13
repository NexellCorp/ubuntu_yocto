require xorg-driver-video.inc

SUMMARY = "X.Org X server -- Nexell Mali xorg driver"

DESCRIPTION = "Open-source X.org graphics driver for Nexell Mali graphics \
Currently relies on a closed-source submodule for EXA acceleration on \
the following chipsets: \
  + S5P4418 \
  + S5P6818 \
\
NOTE: this driver is work in progress..  you probably don't want to try \
and use it yet.  The API/ABI between driver and kernel, and driver and \
acceleration submodules is not stable yet.  This driver requires the \
nxpdrm kernel driver w/ GEM support. \
"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://COPYING;md5=b4267825b1a5171d3b3007059960d6f0"
DEPENDS += "virtual/libx11 libdrm xf86driproto"

SRCREV = "ae0394e687f1a77e966cf72f895da91840dffb8f"
PR = "${INC_PR}.3"

SRC_URI = "file://xf86-video-mali"

FILESEXTRAPATHS_prepend := "${THISDIR}:"

S = "${WORKDIR}/xf86-video-mali"

CFLAGS += " -I${STAGING_INCDIR}/xorg "
