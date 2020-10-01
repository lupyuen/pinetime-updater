#!/usr/bin/env bash
#  Flash to nRF52 with ST-Link and show Semihosting Log

set -e  #  Exit when any command fails.
set -x  #  Echo all commands.

xpack-openocd/bin/openocd
    -c ' set filename "firmware.bin" ' 
    -c ' set address  "0x0" ' 
    -c ' add_script_search_dir xpack-openocd/scripts '
    -f scripts/swd-stlink.ocd 
    -f scripts/flash-program.ocd
