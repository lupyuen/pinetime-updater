#!/usr/bin/env bash
#  Flash Bootloader and Application Firmware to PineTime ROM (nRF52) with xPack OpenOCD (macOS / Linux with ST-Link) and openocd-spi (Raspberry Pi)

set -e  #  Exit when any command fails.
set -x  #  Echo all commands.

#  Fetch the latest bootloader and application firmware versions
git pull

function main {
    #  Install neofetch
    install_neofetch

    #  Get the machine model to check whether this a Raspberry Pi
    model="$(neofetch model)"; model="${model##*: }"
    set +x; echo; echo "----- Model is $model"; set -x

    #  Sets model to...
    #  Raspberry Pi 4 Model B Rev 1.1 
    #  Pine64 Pinebook Pro
    #  MacBookPro10,1

    #  Configure SWD Programmer
    local swd_device=
    local openocd=
    if [[ "$model" == Raspberry\ Pi* ]]; then
        #  If Raspberry Pi: Select openocd-spi as SWD Programmer
        openocd=openocd-spi/bin/openocd
        swd_device=scripts/swd-pi.ocd
        #  Download openocd-spi
        install_openocd_spi
    else
        #  If not Raspberry Pi: Select xPack OpenOCD with ST-Link v2 as SWD Programmer
        openocd=xpack-openocd/bin/openocd
        swd_device=scripts/swd-stlink.ocd
        #  Download xPack OpenOCD
        install_openocd
    fi

    #  Show menu
    local input=/tmp/pinetime-updater.$$
    dialog \
        --menu "What would you like to flash to PineTime today?" \
        0 0 0 \
        1 "Latest Bootloader (MCUBoot)" \
        2 "Latest Firmware (InfiniTime)" \
        3 "Download from URL" \
        4 "Downloaded file" \
        5 "Program bootloader logo" \
        2>$input
    local selection=$(<"$input")

    #  Set the URL, filename and address
    set +x  #  Disable command echo
    local url=
    local filename=
    local address=
    case "$selection" in
        1)  #  For Bootloader
            url=https://github.com/lupyuen/pinetime-rust-mynewt/releases/download/v4.1.7/mynewt_nosemi.elf.bin
            filename=/tmp/mynewt_nosemi.elf.bin
            address=0x0
            ;;
        2)  #  For Application Firmware
            url=https://github.com/JF002/Pinetime/releases/download/0.7.1/pinetime-mcuboot-app.img
            filename=/tmp/pinetime-mcuboot-app.img
            address=0x8000
            ;;
        3)  #  Download from URL
            dialog --inputbox \
                "URL to download:" \
                0 0 \
                2>$input
            url=$(<"$input")

            #  Extract the filename from the last part of the URL: "https//aaa/bb.c" becomes "/tmp/bb.c"
            filename=/tmp/`basename "$url"`

            dialog --inputbox \
                "Flash to address: (0x0 for bootloader)" \
                0 0 0x8000 \
                2>$input
            address=$(<"$input")
            ;;
        4)  #  Downloaded file
            dialog \
                --title "Press Up/Down, Space and Enter to select a file" \
                --fselect "$HOME/" \
                10 70 \
                2>$input
            filename=$(<"$input")

            dialog --inputbox \
                "Flash to address: (0x0 for bootloader)" \
                0 0 0x8000 \
                2>$input
            address=$(<"$input")
            ;;

        5) # Program bootloader logo
            dialog --msgbox \
                "The current firmware will be overridden with the logo loader. Wait for the logo to fully appear on the watch, this means the logo is programmed into the flash memory. Then you need to reprogram the bootloader and the application firmware." \
                0 0
            url=https://github.com/JF002/Pinetime/releases/download/0.7.1/pinetime-graphics.bin
            filename=/tmp/pinetime-graphics.bin
            address=0x0
            ;;

        *)  #  Cancel
            exit 0
    esac
    set -x  #  Enable command echo

    #  Quit if no file or address selected
    if [ -z "$filename" ]; then
        exit
    fi
    if [ -z "$address" ]; then
        exit
    fi

    #  Download the URL
    if [ ! -z "$url" ]; then
        #  TODO: If the URL is a GitHub Actions Artifact, prompt for GitHub Token
        set +x; echo; echo "----- Downloading $url to $filename... (If it stops here, URL is invalid)"; set -x
        wget -q $url -O $filename
    fi
    if [ ! -f "$filename" ]; then
        set +x; echo; echo "----- File not found: $filename"; set -x
        exit
    fi

    #  Flash the device    
    set +x; echo; echo "----- Flashing $filename to address $address..."; set -x
    "$openocd" \
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
    set +x; echo; echo "----- Installing xPack OpenOCD..."; set -x

    local version=0.10.0-14
    local os=
    if [[ $(uname) == Darwin ]]; then
        #  For macOS: https://github.com/xpack-dev-tools/openocd-xpack/releases/download/v0.10.0-14/xpack-openocd-0.10.0-14-darwin-x64.tar.gz
        os=darwin-x64
    elif [[ $(uname -m) == aarch32 ]]; then
        #  For Arm32: https://github.com/xpack-dev-tools/openocd-xpack/releases/download/v0.10.0-14/xpack-openocd-0.10.0-14-linux-arm.tar.gz
        os=linux-arm
    elif [[ $(uname -m) == aarch64 ]]; then
        #  For Arm64: https://github.com/xpack-dev-tools/openocd-xpack/releases/download/v0.10.0-14/xpack-openocd-0.10.0-14-linux-arm64.tar.gz
        os=linux-arm64
    elif [[ $(uname -m) == i686 ]]; then
        #  For x86: https://github.com/xpack-dev-tools/openocd-xpack/releases/download/v0.10.0-14/xpack-openocd-0.10.0-14-linux-x32.tar.gz
        os=linux-x32
    elif [[ $(uname -m) == x86_64 ]]; then
        #  For x64: https://github.com/xpack-dev-tools/openocd-xpack/releases/download/v0.10.0-14/xpack-openocd-0.10.0-14-linux-x64.tar.gz
        os=linux-x64
    fi
    #  TODO
    #  Win32: https://github.com/xpack-dev-tools/openocd-xpack/releases/download/v0.10.0-14/xpack-openocd-0.10.0-14-win32-x32.zip
    #  Win64: https://github.com/xpack-dev-tools/openocd-xpack/releases/download/v0.10.0-14/xpack-openocd-0.10.0-14-win32-x64.zip

    #  Download xPack OpenOCD to xpack-openocd
    if [ -f xpack-openocd-$version-$os.tar.gz ]; then
        rm xpack-openocd-$version-$os.tar.gz
    fi
    wget https://github.com/xpack-dev-tools/openocd-xpack/releases/download/v$version/xpack-openocd-$version-$os.tar.gz
    tar -xf xpack-openocd-$version-$os.tar.gz
    rm xpack-openocd-$version-$os.tar.gz
    mv xpack-openocd-$version xpack-openocd

    #  For Linux Only: Install UDEV Rules according to https://xpack.github.io/openocd/install/#udev
    if [ -d /etc/udev/rules.d ]; then
        set +x; echo; echo "----- Installing UDEV Rules for ST-Link..."; set -x
        sudo cp xpack-openocd/contrib/60-openocd.rules /etc/udev/rules.d/
        sudo udevadm control --reload-rules
    fi
}

#  Download and build openocd-spi from github.com/lupyuen/openocd-spi
function install_openocd_spi {
    #  Return if already installed
    if [ -e openocd-spi/bin/openocd ]; then
        return
    fi

    #  Modules to be installed
    local modules="wget git autoconf libtool make pkg-config libusb-1.0-0 libusb-1.0-0-dev libhidapi-dev libftdi-dev telnet raspi-config"
    set +x; echo; echo "----- Installing $modules..."; set -x
    if [[ $(uname) == Darwin ]]; then
        #  For macOS
        brew install $modules
    elif command -v apt &> /dev/null; then
        #  For Debian
        sudo apt update
        sudo apt upgrade
        sudo apt install -y $modules
    elif command -v pacman &> /dev/null; then
        #  For Arch Linux
        sudo pacman -Syyu $modules
    fi

    #  Download and build openocd-spi
    set +x; echo; echo "----- Installing openocd-spi..."; set -x
    if [ -d openocd-spi ]; then
        rm -r openocd-spi
    fi
    git clone https://github.com/lupyuen/openocd-spi
    pushd openocd-spi
    ./bootstrap
    ./configure --enable-sysfsgpio --enable-bcm2835spi --enable-cmsis-dap
    #  Don't use "make -j" on Raspberry Pi 3, it will run out of swap space
    make
    popd
    if [ ! -d openocd-spi/bin ]; then
        mkdir openocd-spi/bin
    fi
    cp openocd-spi/src/openocd openocd-spi/bin/
    cp -r openocd-spi/tcl openocd-spi/scripts
}

#  Install neofetch
function install_neofetch {
    #  Return if already installed
    if command -v dialog &> /dev/null; then
        if command -v git &> /dev/null; then
            if command -v neofetch &> /dev/null; then
                if command -v wget &> /dev/null; then
                    return
                fi
            fi
        fi
    fi
    #  Modules to be installed
    local modules="dialog git neofetch wget"
    set +x; echo; echo "----- Installing $modules..."; set -x

    if [[ $(uname) == Darwin ]]; then
        #  For macOS
        brew install $modules
    elif command -v apt &> /dev/null; then
        #  For Debian
        sudo apt update
        sudo apt upgrade
        sudo apt install -y $modules
    elif command -v pacman &> /dev/null; then
        #  For Arch Linux
        sudo pacman -Syyu $modules
    fi
}

#  Start the script
main
