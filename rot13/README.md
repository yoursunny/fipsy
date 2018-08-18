# rot13

ROT13 letter substitution cipher in UART.

## Wiring

peripheral|peripheral pin|Fipsy pin
----------|--------------|---------
USB-UART  |GND           |2
USB-UART  |TXD           |9 (RX)
USB-UART  |RXD           |8 (TX)

Fipsy may be powered by USB-UART's 3V3 pin, if it does not have other power source.

## Usage

1. `sudo screen /dev/ttyUSB0 115200`
2. Type into the console. Upper-case and lower-case letters will be transformed using ROT13 cipher. Other characters are echoed back unchanged.
3. To exit, press CTRL+A followed by \ key.
