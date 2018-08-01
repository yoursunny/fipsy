# piano4

Four-key piano.

https://yoursunny.com/t/2018/fipsy-piano/

## Wiring

Components:

* Keypad: [4-key button module](https://www.miniinthebox.com/en/p/4-key-button-module-sensor-external-keyboard-module-for-arduino-raspberry-pi-blue_p4872487.html), active low.
* Buzzer: [RobotDyn passive buzzer](https://robotdyn.com/buzzer-module.html), drive with square wave.

Fipsy | Keypad | Buzzer
------|--------|-------
10    |        | S
11    | K1     |
12    | K2     |
13    | K3     |
14    | K4     |
15    | VCC    | VCC
16    | GND    | GND

## Effect

* First key plays C4 sound.
* Second key plays E4 sound.
* Third key plays G4 sound.
* Fourth key plays C5 sound.
