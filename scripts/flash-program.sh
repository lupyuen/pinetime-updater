#!/usr/bin/env bash
#  Flash to nRF52 with ST-Link

set -e  #  Exit when any command fails.
set -x  #  Echo all commands.

xpack-openocd/bin/openocd \
    -f scripts/swd-stlink.ocd \
    -f scripts/flash-program.ocd
