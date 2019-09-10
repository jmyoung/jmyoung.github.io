---
id: 98
title: Arduino Uno as ISP
date: 2011-05-10T00:56:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=98
permalink: /2011/05/arduino-uno-as-isp/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/05/arduino-uno-as-isp.html
categories:
  - Electronics
tags:
  - arduino
---
So, I'm planning on building up an Arduino-compatible breadboard in order to prototype my MCE Remote IR Blaster. In order to do this, I decided I needed a few extra components so I can program the ATmega328p microcontroller without needing to go and pull chips out of sockets on my current Uno boards;

  * An AVR ISP device of some type (used to program the bootloader)
  * An FTDI-to-serial adapter and cables to connect a (relatively) bare ATmega328p to a PC for programming
  * A board to connect up an ATmega328p through a ZIF (zero insertion force) socket

<span><span><a name="more"></a>The ISP (In-System Programmer)</span></span>

When you upload a program to an Arduino, what actually happens is the microcontroller is reset, and then during the first few seconds of boot, a piece of code (the bootloader) runs. The bootloader listens on the serial port for an incoming sketch and commits it to flash if it receives one. If it doesn't, it just marches along and runs whatever sketch is already in flash.

This means that if your microcontroller has either no bootloader (ie, bought without one) or if something bad happened to its bootloader, it's basically bricked unless you can reprogram the bootloader. That's where the ISP steps in. The ISP allows you to program the microcontroller from scratch.

There's a couple of different ways to get an ISP. You can make a parallel port version, you can buy several different types of AVR ISP, or you can do what I did, and press-gang an existing Arduino Uno into becoming an ISP for you.

<span>Turning the Arduino Uno into an ISP</span>

Simply follow the instructions at <http://arduino.cc/en/Tutorial/ArduinoISP> - they work just fine. Note that the instructions say that the code won't work with the Uno, but this doesn't appear to be the case. I ran it just fine with an original Arduino Uno, running v0022 of the IDE. Note that my Uno is not the SMD version, I don't know if this will make any difference.

<span>What Next?</span>

Well. Now that I've discovered it appears I really can use an existing Arduino Uno as an ISP, that opens up a world of possibilities. Namely, I can make up a prototype shield to go onto a Uno which has a ZIF socket installed onto it, and does all the connections required to turn it into an ISP straight up.

So the plan is to fit up the prototype shield with the ZIF socket, some status LEDs, and also put in a breakout for a 2x3 ICSP pin header to program stuff external to the shield. Then I can also put in the appropriate 6-pin FTDI interface so the chip in the socket can be programmed.

Schematics and such will be coming as I make them. Phew, I'm getting a lot of projects on the go...