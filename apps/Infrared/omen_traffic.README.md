# Omen Traffic

Working Omen app (GOST R 52289-2019 §7 + GKRCh ПНМ 433 MHz).

Copy `omen_traffic.fap` to:

`SD Card/apps/Infrared/omen_traffic.fap`

## Channels (default: all on)

| Channel | Details |
|---------|---------|
| **IR NEC** | Address `0x4F`, cmds `12`–`17` per colour. Learn IR overrides. |
| **GPIO** | PA7=Red, PA6=Yellow, PA4=Green |
| **Sub-GHz** | **433.92 MHz** Princeton OOK (AM650), key `0x4F4D00 \| cmd` — inside GKRCh ПНМ **433.05–434.79 MHz** |

## Menu

- Colours / GOST cycle / Learn IR / Output mode
- Modes: IR+GPIO+433, IR+GPIO, IR+433, GPIO+433, 433 only, IR only, GPIO only

Lab/DIY receivers only. Not for municipal traffic controllers.
