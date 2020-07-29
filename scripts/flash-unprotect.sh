#!/usr/bin/env bash
#  Remove Flash Protection on nRF52 with Raspberry Pi

set -e  #  Exit when any command fails.
set -x  #  Echo all commands.

openocd-spi/bin/openocd \
    -f scripts/swd-pi.ocd \
    -f scripts/flash-unprotect.ocd
