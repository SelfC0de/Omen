# Omen Traffic

Working Omen Infrared app (GOST R 52289-2019 §7). Not a mockup.

Copy `omen_traffic.fap` to:

`SD Card/apps/Infrared/omen_traffic.fap`

## What it does

Pick a colour → Flipper **sends IR** and/or **drives GPIO LEDs**.

### IR (built-in NEC)
- Address `0x4F`
- Commands: Red `0x12`, Yellow `0x13`, Green `0x14`, Red+Yellow `0x15`, Green blink `0x16`, Off `0x17`
- Point Flipper IR LED at your IR-controlled light / Arduino receiver
- **Learn IR**: replace any colour with a code from your own remote (saved in `/ext/apps_data/omen_traffic/codes.txt`)

### GPIO LEDs (Flipper header)
| Colour | Pin |
|--------|-----|
| Red | PA7 |
| Yellow | PA6 |
| Green | PA4 |

Wire LED + resistor from pin to GND. Mode menu: IR+GPIO / IR only / GPIO only.

### GOST cycle
red → red+yellow (≥2 s) → green → yellow (≥3 s) → red — each step transmits for real.
