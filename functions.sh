#!/bin/bash

unset sync

usage()
{
    cat << EOF
usage: $0 options

This script initialize and run Nexell Yocto builds with Linaro Toolchain.

OPTIONS:
-h      Show this message
-a      Target architecture (armv7a or armv8)
-u      External Linaro toolchain URL
EOF
}

show_setup()
{
    echo ""
    echo "Target architecture: $arch"
    echo "External toolchain URL: $external_url"
    echo ""
}

conf_bblayers()
{
    local cur_dir=$(pwd)
    cat > conf/bblayers.conf <<EOF
# LAYER_CONF_VERSION is increased each time build/conf/bblayers.conf
# changes incompatibly
LCONF_VERSION = "6"

BBPATH = "\${TOPDIR}"
BBFILES ?= ""

BBLAYERS_NON_REMOVABLE ?= " \
  '`realpath $PWD/../meta`' \
  '`realpath $PWD/../meta-yocto`' \
  "
BBLAYERS  = '`realpath $PWD/../meta`'
BBLAYERS += '`realpath $PWD/../meta-yocto`'
BBLAYERS += '`realpath $PWD/../meta-yocto-bsp`'
BBLAYERS += '`realpath $PWD/../meta-linaro-toolchain`'
BBLAYERS += '`realpath $PWD/../meta-nexell`'
EOF
}

conf_siteconf()
{
    machinearch="nexell${arch}"
    #machinearch="generic${arch}"

    cat > conf/site.conf <<EOF
SCONF_VERSION = "1"
IMAGE_ROOTFS_ALIGNMENT = "2048"
INHERIT += "rm_work"
INHERIT += "buildhistory"
MACHINE ?= "${machinearch}"
# Prefer hardfloat, the OE default is softfp for cortex-A class devices
#DEFAULTTUNE_nexellarmv7a ?= "armv7athf"
DEFAULTTUNE_nexellarmv7a ?= "armv7ahf"

IMAGE_FSTYPES = "tar.gz"

GCCVERSION       ?= "linaro-4.9"
SDKGCCVERSION    ?= "linaro-4.9"
BINUVERSION      ?= "linaro-2.%"
GLIBCVERSION     = "linaro-2.20"
LINUXLIBCVERSION = "3.18"

PREFERRED_VERSION_gcc-source ?= ""

PREFERRED_PROVIDER_jpeg = "libjpeg-turbo"

PREFERRED_PROVIDER_libevent = "libevent-fb"
PREFERRED_VERSION_libmemcached = "1.0.7"

TCLIBC = "glibc"

LICENSE_FLAGS_WHITELIST = "non-commercial"

PREFERRED_VERSION_openvswitch = "2.1.3"

DISTRO_FEATURES = "pam x11 alsa argp ext2 largefile usbgadget usbhost xattr nfs zeroconf opengl ${DISTRO_FEATURES_LIBC} systemd"
EOF
}

conf_localconf()
{
    sed -i -e "s/^MACHINE.*//g" \
           -e "/PACKAGECONFIG_pn-qemu-native/d" \
           conf/local.conf
    sed -i -e "s/package_rpm/package_deb/g" conf/local.conf
    #echo "PACKAGE_ARCH = \${MACHINE_ARCH}" >> conf/local.conf
    echo 'DPKG_ARCH = "armhf"' >> conf/local.conf
}

conf_toolchain()
{
    set -xe
    echo 'TCMODE = "external-linaro"' >>conf/site.conf 
    echo 'PNBLACKLIST[glibc] = "Using external toolchain"' >>conf/site.conf
    echo 'PNBLACKLIST[libgcc] = "Using external toolchain"' >>conf/site.conf
    echo 'PNBLACKLIST[gcc-cross] = "Using external toolchain"' >>conf/site.conf

    tarball_name=`basename $external_url`

    mkdir -p toolchain
    local_tarball_name=toolchain/$tarball_name

    if [ ! -e $local_tarball_name ]; then
        # wget -cv $external_url -O $local_tarball_name
        cp ../$tarball_name toolchain
    fi
    md5sum $local_tarball_name
    local toolchain_path=$(echo $local_tarball_name | sed -e 's/\(.*\)\.tar..*/\1/g')
    echo "toolchain_path --- $toolchain_path"
    if [ ! -e ${toolchain_path} ]; then
        tar xf $local_tarball_name -C toolchain
    fi

    echo "EXTERNAL_TOOLCHAIN = \"`pwd`/toolchain/`echo $tarball_name|sed -e 's/\(.*\)\.tar..*/\1/g'`\"" >> conf/site.conf
    case $arch in
        armv7a)
            echo 'ELT_TARGET_SYS = "arm-linux-gnueabihf"' >>conf/site.conf
            ;;
        armv8)
            echo 'ELT_TARGET_SYS = "aarch64-linux-gnu"' >>conf/site.conf
            ;;
    esac
    set +xe
}

init_env()
{
    . ./oe-init-build-env build

    conf_bblayers
    conf_siteconf
    conf_localconf
    conf_toolchain
}
