#!/usr/bin/env bash
#  Flash Mynewt Application to nRF52 on macOS, Linux and Raspberry Pi

set -e  #  Exit when any command fails.
set -x  #  Echo all commands.

#  TODO: git pull

function main {
    #  Configure SWD Programmer
    #  Select ST-Link v2 as SWD Programmer
    swd_device=scripts/swd-stlink.ocd

    #  Download xPack OpenOCD
    install_openocd

    #  Select Raspberry Pi as SWD Programmer
    #  swd_device=scripts/swd-pi.ocd

    #  Download openocd-spi
    #  install_openocd_spi

    #  dialog --menu "What would you like to flash to PineTime today?" 0 0 0 1 "Latest Bootloader" 2 "Latest Firmware (FreeRTOS)" 3 "Download from URL" 4 "Downloaded file"

    #  Flash the device
    filename="a.img"
    address=0x8000
    xpack-openocd/bin/openocd \
        -c " set filename \"$filename\" " \
        -c " set address \"$address\" " \
        -f $swd_device \
        -f scripts/flash-program.ocd
}

#  Download xPack OpenOCD from https://xpack.github.io/openocd/install/
function install_openocd {
    if [ -e xpack-openocd/bin/openocd ]; then
        return
    fi

    if [[ $(uname -m) == aarch64 ]]; then
        rm xpack-openocd-0.10.0-14-linux-arm64.tar.gz
        wget https://github.com/xpack-dev-tools/openocd-xpack/releases/download/v0.10.0-14/xpack-openocd-0.10.0-14-linux-arm64.tar.gz
        tar -xf xpack-openocd-0.10.0-14-linux-arm64.tar.gz
        rm xpack-openocd-0.10.0-14-linux-arm64.tar.gz
        mv xpack-openocd-0.10.0-14 xpack-openocd
    else
        echo TODO
    fi

    #  macOS:
    #  wget https://github.com/xpack-dev-tools/openocd-xpack/releases/download/v0.10.0-14/xpack-openocd-0.10.0-14-darwin-x64.tar.gz

    #  Linux Arm32:
    #  wget https://github.com/xpack-dev-tools/openocd-xpack/releases/download/v0.10.0-14/xpack-openocd-0.10.0-14-linux-arm.tar.gz

    #  Linux Arm64:
    #  wget https://github.com/xpack-dev-tools/openocd-xpack/releases/download/v0.10.0-14/xpack-openocd-0.10.0-14-linux-arm64.tar.gz

    #  Linux x32:
    #  wget https://github.com/xpack-dev-tools/openocd-xpack/releases/download/v0.10.0-14/xpack-openocd-0.10.0-14-linux-x32.tar.gz

    #  Linux x64:
    #  wget https://github.com/xpack-dev-tools/openocd-xpack/releases/download/v0.10.0-14/xpack-openocd-0.10.0-14-linux-x64.tar.gz

    #  Win32:
    #  https://github.com/xpack-dev-tools/openocd-xpack/releases/download/v0.10.0-14/xpack-openocd-0.10.0-14-win32-x32.zip

    #  Win64:
    #  https://github.com/xpack-dev-tools/openocd-xpack/releases/download/v0.10.0-14/xpack-openocd-0.10.0-14-win32-x64.zip
}

#  Start the script
main
