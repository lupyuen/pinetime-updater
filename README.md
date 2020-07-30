# pinetime-updater: Flash firmware to PineTime the friendly wired way with OpenOCD

![](pinetime-updater.png)

-   Flash the [__Latest Bootloader (MCUBoot)__](https://lupyuen.github.io/pinetime-rust-mynewt/articles/mcuboot) and [__Firmware (FreeRTOS)__](https://github.com/JF002/Pinetime) to [__PineTime Smart Watch__](https://lupyuen.github.io/pinetime-rust-mynewt/articles/pinetime) the wired way

-   After the firmware has been flashed to PineTime via the SWD port, we may update the firmware wirelessly (over Bluetooth LE) with the [__nRF Connect__](https://www.nordicsemi.com/Software-and-tools/Development-Tools/nRF-Connect-for-mobile) mobile app

-   Installs [__xPack OpenOCD__](https://xpack.github.io/openocd/install/) automatically

-   Builds [__`openocd-spi`__](https://github.com/lupyuen/openocd-spi) on Raspberry Pi

## Requirements

-   Linux or macOS, connected to PineTime with [ST-Link v2 Compatible](https://www.aliexpress.com/wholesale?catId=0&initiative_id=SB_20180924134644&SearchText=st-link+v2&switch_new_app=y)

    [Video of PineTime Updater on macOS](https://youtu.be/2p4EZqevVJQ)

-   Or Raspberry Pi with Raspberry Pi OS (32-bit), connected to PineTime via the SPI port...

    ["Connect PineTime to Raspberry Pi"](https://github.com/lupyuen/visual-embedded-rust/blob/master/README.md#connect-pinetime-to-raspberry-pi)

    [Video of PineTime Updater on Raspberry Pi](https://youtu.be/PZ5NW8q8Zok)

## How To Run

```bash
# For macOS Only: Install brew according to https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# For Raspberry Pi Only: Enable SPI port with raspi-config
# Select Interfacing Options → SPI → Yes
sudo raspi-config

# Download the bash and OpenOCD scripts
git clone https://github.com/lupyuen/pinetime-updater

# Run the bash script
cd pinetime-updater
./run.sh

```

## Remove Flash ROM Protection

The above steps will fail when PineTime has Flash ROM Protection enabled.

To remove PineTime's Flash ROM Protection (with Raspberry Pi only)...

```bash
cd pinetime-updater
./scripts/flash-unprotect.sh
```

## How It Works

See [`run.sh`](run.sh)

Check the article ["PineTime doesn't run Linux... But that's OK!"](https://lupyuen.github.io/pinetime-rust-mynewt/articles/pinetime)