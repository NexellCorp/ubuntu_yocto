#!/bin/bash

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation version 2.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>

# set some defaults
arch=armv7a
# gcc-4.9.3
external_url="http://releases.linaro.org/15.05/components/toolchain/binaries/arm-linux-gnueabihf/gcc-linaro-4.9-2015.05-x86_64_arm-linux-gnueabihf.tar.xz"
k_option=""
c_option=""

source $(dirname $0)/functions.sh

while getopts “ha:u:c:k” OPTION
do
	case $OPTION in
		h)
			usage
			exit
			;;
		a)
			arch=$OPTARG
			;;
		u)
			external_url=$OPTARG
			;;
        k)
            k_option="-k"
            ;;
        c)
            c_option="-c $OPTARG"
            ;;
	esac
done

shift $(( OPTIND-1 ))

show_setup

init_env

bitbake ${k_option} ${c_option} $@
