# Omen

Flipper Zero firmware. Base is [Unleashed](https://github.com/DarkFlippers/unleashed-firmware) `1672f7c54`, API 88.22.

Radio, NFC and BadUSB stay Unleashed code. Omen changes the menu, the about screen and the update package name.

## Install

Download `flipper-z-f7-update-omen.tgz` from the releases.

- qFlipper or the Flipper mobile app: update channel Custom, choose the `.tgz`.
- Or unpack it and open `update/f7-update-omen/update.fuf` on the device.

The package is the extra-apps build. It includes the Unleashed base apps and the current [all-the-plugins](https://github.com/xMasterX/all-the-plugins) extra pack (built for API 88.21, which runs on 88.22).

## Build

The tree has to sit at `D:\omen-src`. A path with a space makes the packager open `D:\Flipper` and stop.

```
build-omen.bat
```

That fetches the extra pack, builds `COMPACT=1 DEBUG=0`, and writes the `.tgz` to `D:\Flipper Zero\Omen\Omen v1.0.0.X`. The last number increases when the current folder already has a package. `build-omen.bat base` skips the extra pack.

## License

GPL-3.0-only. This is Unleashed and official Flipper code plus our changes. GPL lets other people use, modify and fork it. A ban on forking cannot be added on top.
