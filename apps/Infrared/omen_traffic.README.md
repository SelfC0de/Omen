# Omen Traffic

Working Omen app (GOST R 52289-2019 §7 + unlocked ISM TX).

`SD Card/apps/Infrared/omen_traffic.fap`

## Channels (default: all)

- **IR NEC** — addr `0x4F`, cmds `12`–`17`, Learn IR
- **GPIO** — PA7=R, PA6=Y, PA4=G
- **Sub-GHz** — Princeton OOK, key `0x4F4D00|cmd`

## Frequencies (unlocked immediately)

Menu **Freq:** 315.00 / **433.92** / 868.35 / 915.00 MHz

Omen firmware allows TX on the full CC1101 hardware range. App also writes `/ext/subghz/assets/dangerous_settings` so extended range stays on.

Lab/DIY only.
