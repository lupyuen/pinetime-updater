# pinetime-updater: Flash firmware to PineTime the wired way with OpenOCD

Requirements:

1.  Linux or macOS, connected to PineTime with [ST-Link v2 Compatible](https://www.aliexpress.com/wholesale?catId=0&initiative_id=SB_20180924134644&SearchText=st-link+v2&switch_new_app=y)

1.  Raspberry Pi with Raspberry Pi OS, connected to PineTime via the SPI port...

    ["Connect PineTime to Raspberry Pi"](https://github.com/lupyuen/visual-embedded-rust/blob/master/README.md#connect-pinetime-to-raspberry-pi)

PineTime's Flash ROM Protection should have been disabled.

To run:

```bash
# For Raspberry Pi Only: Enable SPI port with raspi-config
raspi-config

# For macOS Only: Install brew according to https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Download the bash and OpenOCD scripts
git clone https://github.com/lupyuen/pinetime-updater

# Run the bash script
cd pinetime-updater
./run.sh

```

## How It Works

See [`run.sh`](run.sh)

![](pinetime-updater.png)
