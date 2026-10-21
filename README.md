# Omen

Flipper Zero firmware. Base is Unleashed `1672f7c54`, API 88.22.

Radio, NFC and BadUSB stay Unleashed code. Omen changes the menu, the about screen and the package name.

## Install

Download `flipper-z-f7-update-omen.tgz` from the releases.

- qFlipper or the Flipper mobile app: update channel Custom, choose the `.tgz`.
- Or unpack it and open `update/f7-update-omen/update.fuf` on the device.

The package includes the Unleashed base apps and the current extra pack from all-the-plugins (built for API 88.21, runs on 88.22).

## Build

Put this repository next to the firmware folder `omen-src` (the folder that contains `fbt.cmd`). Then run `build-omen.bat`.

The script writes `Omen v1.0.0.X` next to itself. The last number increases when that folder already has a package. `build-omen.bat base` skips the extra pack.

If the firmware path contains a space, the script maps a free drive letter for the duration of the build and removes it afterwards.

## License

GPL-3.0-only. This is Unleashed and official Flipper code plus our changes. GPL allows use, modification and forks.
