# rot13

ROT13 letter substitution cipher in UART.

## Wiring

Components:

* USB-UART adapter (3.3V logic)

Fipsy   | USB-UART
--------|---------
2 (GND) | GND
8 (TX)  | RXD
9 (RX)  | TXD

Fipsy may be powered by USB-UART's 3V3 pin, if it does not have other power source.

## Usage

1. `sudo screen /dev/ttyUSB0 115200`
2. Type into the console. Upper-case and lower-case letters will be transformed using ROT13 cipher. Other characters are echoed back unchanged.
3. To exit, press CTRL+A followed by \ key.
