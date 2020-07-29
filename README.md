# pinetime-updater: Flash firmware to PineTime the friendly wired way with OpenOCD

![](pinetime-updater.png)

- Flash the __Latest Bootloader and Firmware__ (FreeRTOS) to PineTime Smart Watch with OpenOCD

- Installs [__xPack OpenOCD__](xpack.github.io/openocd/install/) automatically

- Uses [__`openocd-spi`__](https://github.com/lupyuen/openocd-spi) on Raspberry Pi

## Requirements

-   Linux or macOS, connected to PineTime with [ST-Link v2 Compatible](https://www.aliexpress.com/wholesale?catId=0&initiative_id=SB_20180924134644&SearchText=st-link+v2&switch_new_app=y)

-   Or Raspberry Pi with Raspberry Pi OS, connected to PineTime via the SPI port...

    ["Connect PineTime to Raspberry Pi"](https://github.com/lupyuen/visual-embedded-rust/blob/master/README.md#connect-pinetime-to-raspberry-pi)

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
