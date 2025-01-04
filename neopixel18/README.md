# neopixel18

Display colors on 18x NeoPixels.

## Wiring

Components:

* [Keyes 18 LED ring WS2812](https://fluxworkshop.com/products/bbaa100164-18-led-ring-ws2812-keyes-red?variant=32734533222460), compatible with Adafruit NeoPixels
* 4-channel logic level converter (1 channel used)
* button, active low

Connections:

* Fipsy #14 - (3.3V - level converter - 5V) - WS2812 DI
* Fipsy #10 - reset button

## Effect

NeoPixels display green / red / blue colors alternatively.

Photo: <https://x.com/yoursunny/status/1874646701807689786>

## Acknowledgement

NeoPixel transmitter is written by Kareem Matariyeh: <https://github.com/asm2750/Neopixel_TX_Core>
