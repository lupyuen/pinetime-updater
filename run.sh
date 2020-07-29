#!/usr/bin/env bash
#  Flash to PineTime ROM (nRF52) with xPack OpenOCD (macOS / Linux) and openocd-spi (Raspberry Pi)

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

    #  Show menu
    dialog \
        --menu "What would you like to flash to PineTime today?" \
        0 0 0 \
        1 "Latest Bootloader" \
        2 "Latest Firmware (FreeRTOS)" \
        3 "Download from URL" \
        4 "Downloaded file"

    #  TODO: Download the file

    #  Flash the device
    filename="a.img"
    address=0x8000
    xpack-openocd/bin/openocd \
        -c " set filename \"$filename\" " \
        -c " set address  \"$address\" " \
        -f $swd_device \
        -f scripts/flash-program.ocd
}

#  Download xPack OpenOCD from xpack.github.io/openocd/install/
function install_openocd {
    #  Exit if already installed
    if [ -e xpack-openocd/bin/openocd ]; then
        return
    fi

    #  TODO: For Ubuntu
    sudo apt install -y wget git
    #  TODO: For Arch Linux
    #  sudo pacman -Syyu

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

#  Download and build openocd_spi from github.com/lupyuen/openocd-spi
function install_openocd_spi {
    #  Exit if already installed
    if [ -e openocd_spi/bin/openocd ]; then
        return
    fi

    set +x; echo; echo "----- Installing build tools..."; set -x
    #  TODO: For Ubuntu
    sudo apt install -y wget git autoconf libtool make pkg-config libusb-1.0-0 libusb-1.0-0-dev libhidapi-dev libftdi-dev telnet raspi-config
    #  TODO: For Arch Linux
    #  sudo pacman -Syyu raspi-config

    #  TODO: raspi-config to enable SPI

    git clone https://github.com/lupyuen/openocd-spi
    pushd openocd-spi
    ./bootstrap
    ./configure --enable-sysfsgpio --enable-bcm2835spi --enable-cmsis-dap
    make
    popd
}

#  Start the script
main
