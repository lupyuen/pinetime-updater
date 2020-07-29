#!/usr/bin/env bash
#  Flash Mynewt Application to nRF52 on macOS, Linux and Raspberry Pi

set -e  #  Exit when any command fails.
set -x  #  Echo all commands.

dialog --menu "What would you like to flash to PineTime today?" 0 0 0 1 "Latest Bootloader" 2 "Latest Firmware (FreeRTOS)" 3 "Download from URL" 4 "Downloaded file"

#  Configure SWD Programmer
#  Select ST-Link v2 as SWD Programmer
swd_device=scripts/swd-stlink.ocd

#  Select Raspberry Pi as SWD Programmer
#  swd_device=scripts/swd-pi.ocd

#  TODO: Download xPack OpenOCD

#  TODO: Build openocd-spi

#  Flash the device
xpack-openocd/bin/openocd \
    -f $swd_device \
    -f scripts/flash-app.ocd
