#!/usr/bin/env bash
#  Flash to PineTime ROM (nRF52) with xPack OpenOCD (macOS / Linux) and openocd-spi (Raspberry Pi)

set -e  #  Exit when any command fails.
set -x  #  Echo all commands.

#  TODO: Fetch the latest bootload and firmware versions
#  git pull

function main {
    #  Install neofetch
    install_neofetch

    #  TODO: Check whether this a Raspberry Pi
    #  model=`neofetch model`
    #  model: Raspberry Pi 4 Model B Rev 1.1 
    #  model: Pine64 Pinebook Pro
    #  model: MacBookPro10,1

    #  Configure SWD Programmer

    #  If Raspberry Pi:
    #  Select Raspberry Pi as SWD Programmer
    #  swd_device=scripts/swd-pi.ocd
    #  Download openocd-spi
    #  install_openocd_spi

    #  If not Raspberry Pi:
    #  Select ST-Link v2 as SWD Programmer
    swd_device=scripts/swd-stlink.ocd
    #  Download xPack OpenOCD
    install_openocd

    #  Show menu
    dialog \
        --menu "What would you like to flash to PineTime today?" \
        0 0 0 \
        1 "Latest Bootloader" \
        2 "Latest Firmware (FreeRTOS)" \
        3 "Download from URL" \
        4 "Downloaded file"

    #  TODO: Download the file
    #  For Bootloader:
    #  wget https://github.com/lupyuen/pinetime-rust-mynewt/releases/download/v4.1.7/mynewt_nosemi.elf.bin
    #  For Application Firmware:
    #  wget https://github.com/JF002/Pinetime/releases/download/0.7.1/pinetime-mcuboot-app.img

    #  TODO: If the URL is a GitHub Actions Artifact, prompt for GitHub Token

    #  TODO: Set the flash filename and address
    filename="a.img"
    #  For Bootloader:
    #  address=0x0
    #  For Application Firmware:
    address=0x8000

    #  Flash the device    

    #  If Raspberry Pi:
    #  openocd_spi/bin/openocd \
    #      -c " set filename \"$filename\" " \
    #      -c " set address  \"$address\" " \
    #      -f $swd_device \
    #      -f scripts/flash-program.ocd

    #  If not Rasperry Pi:
    xpack-openocd/bin/openocd \
        -c " set filename \"$filename\" " \
        -c " set address  \"$address\" " \
        -f $swd_device \
        -f scripts/flash-program.ocd
}

#  Download xPack OpenOCD from xpack.github.io/openocd/install/
function install_openocd {
    #  Return if already installed
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

#  Download and build openocd_spi from github.com/lupyuen/openocd-spi
function install_openocd_spi {
    #  Return if already installed
    if [ -e openocd_spi/bin/openocd ]; then
        return
    fi

    set +x; echo; echo "----- Installing build tools..."; set -x

    #  TODO: For Debian
    #  sudo apt install -y wget git autoconf libtool make pkg-config libusb-1.0-0 libusb-1.0-0-dev libhidapi-dev libftdi-dev telnet raspi-config

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

#  Install neofetch
function install_neofetch {
    #  Return if already installed
    if command -v neofetch &> /dev/null; then
        return
    fi
    set +x; echo; echo "----- Installing neofetch..."; set -x

    #  Modules to be installed
    local modules="git neofetch wget"
    if [[ $(uname) == Darwin ]]; then
        #  For macOS
        brew install $modules
    elif command -v apt &> /dev/null; then
        #  For Debian
        sudo apt install -y $modules
    elif command -v pacman &> /dev/null; then
        #  For Arch Linux
        sudo pacman -Syyu $modules
    fi
}

#  Start the script
main
