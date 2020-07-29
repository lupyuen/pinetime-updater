#!/usr/bin/env bash
#  Flash Mynewt Application to nRF52 on macOS, Linux and Raspberry Pi

set -e  #  Exit when any command fails.
set -x  #  Echo all commands.

#  Configure SWD Programmer
#  Select ST-Link v2 as SWD Programmer
swd_device=scripts/swd-stlink.ocd

#  Select Raspberry Pi as SWD Programmer
#  swd_device=scripts/swd-pi.ocd

#  Flash the device
xpack-openocd/bin/openocd \
    -f $swd_device \
    -f scripts/flash.ocd
