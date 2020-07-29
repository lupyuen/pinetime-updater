# pinetime-updater: Flash firmware to PineTime the wired way with OpenOCD

Requirements:

1.  Linux or macOS, connected to PineTime with [ST-Link v2 Compatible](https://www.aliexpress.com/wholesale?catId=0&initiative_id=SB_20180924134644&SearchText=st-link+v2&switch_new_app=y)

1.  Raspberry Pi with Raspberry Pi OS, connected to PineTime via SPI...

    ["Connect PineTime to Raspberry Pi"](https://github.com/lupyuen/visual-embedded-rust/blob/master/README.md#connect-pinetime-to-raspberry-pi)

To run:

```
# For Raspberry Pi Only: Enable SPI port
raspi-config

git clone https://github.com/lupyuen/pinetime-updater

cd pinetime-updater

./run.sh

```

## How It Works

See [`run.sh`](run.sh)

![](pinetime-updater.png)
