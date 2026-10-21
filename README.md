# Omen

Flipper Zero firmware. Base is Unleashed `1672f7c54`, API 88.22.

<p align="center"><img src="banner.png" alt="Omen" width="100%"><br><img src="logo.png" alt="Omen" width="280"></p>

## Install

The only install file is the latest release: `flipper-z-f7-update-omen.tgz`.

qFlipper or the Flipper mobile app, channel Custom. Or unpack the archive and open `update/f7-update-omen/update.fuf` on the device.

## Where files go

After the first boot these folders are on the card. Put each kind of file only there:

| Folder | What goes in |
| --- | --- |
| `subghz` | Sub-GHz remotes, `.sub` |
| `nfc` | NFC cards |
| `lfrfid` | 125 kHz RFID |
| `infrared` | Infrared remotes |
| `ibutton` | iButton keys |
| `badusb` | Bad USB scripts |
| `apps` | Applications, already sorted: Sub-GHz, NFC, RFID, Infrared, GPIO, USB, Bluetooth, Games, Tools, Media |

Timer is in the main menu. One background timer at a time. Its time stays on the top bar.

## Build

Put this folder next to `omen-src` (the folder with `fbt.cmd`) and run `build-omen.bat`. The package is written next to the script as `Omen v1.0.0.X`. The last number increases when that folder already has a package. `build-omen.bat base` skips the extra pack.

## License

GPL-3.0-only.