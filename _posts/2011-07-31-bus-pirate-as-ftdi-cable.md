---
id: 69
title: Bus Pirate as FTDI Cable
date: 2011-07-31T10:28:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=69
permalink: /2011/07/bus-pirate-as-ftdi-cable/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/07/bus-pirate-as-ftdi-cable.html
categories:
  - Electronics
tags:
  - arduino
  - buspirate
---
One of the things I wanted to do with my Bus Pirate was figure out how to apply it like an FTDI cable for the purposes of uploading sketches to an Arduino.  It took me a little stuffing around to do it, but here's the condensed version of how to make it work;

<a name="more"></a>

First, the "black" wire on the proper FTDI cable is pin 1, and the "green" wire is pin 6.  Now, you wire up your Bus Pirate to the FTDI 6-pin header like so;

> <span>Pin 1 - Brown (GND)<br />Pin 2 - Not connected<br />Pin 3 - Orange (+5V)<br />Pin 4 - Grey (MOSI)<br />Pin 5 - Black (MISO)<br />Pin 6 - Purple (CLK)</span>

Now that's done, we'll use the BusPirate in UART mode to get it emulating an FTDI cable.  There's something important to understand here - the BusPirate cannot switch serial speeds after you put it into transparent mode.  Fortunately we want to program at 115200 baud, and the BusPirate is already connected at that speed by default, so it'll be all fine.

  1. Open up your terminal emulator, connect to the BusPirate at 115200 baud.  If you use a different speed, connect at that speed, and then press "b" in order to swap to 115200 baud.
  2. Change to UART mode (type "m" and then "3")
  3. Select serial port speed of 115200 baud (type "9")
  4. Select 8 data bits, no parity (type "1")
  5. Select 1 stop bit (type "1")
  6. Select receive polarity of idle 1 (type "1")
  7. Select output type of Normal (H=3.3v, L=GND) (type "2")
  8. Activate the power supplies (skip this step if the circuit is externally powered!) (type "W")
  9. Type "i" for info.  The pullup resistors should be off.
 10. Type "(3)" including brackets, no quotes.  This will put the BusPirate into transparent bridge mode with flow control.  Once this is done, you'll have to reset the BP to get a prompt back again.
 11. Close your terminal emulator.
 12. Fire up the Arduino IDE, and upload firmware like you usually would, selecting the BusPirate as the serial port.  It'll work just like an FTDI cable will, only it can't change speeds.

All works as expected, and the upload speed is very similar to a real FTDI cable.  It can even auto-reset a Uno for doing the upload.