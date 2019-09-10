---
id: 886
title: ESP8266 First Steps
date: 2016-04-29T10:20:07+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=886
permalink: /2016/04/esp8266-first-steps/
categories:
  - Electronics
tags:
  - esp8266
---
The [ESP8266](https://www.sparkfun.com/products/13678) is a ridiculously cheap ($2 or so from China), WiFi equipped breakout board which has a 32-bit microcontroller and Flash (1MB) onboard.  It comes in a bunch of different versions (mine is an ESP-01), and all with different Flash capacities.  The pinout of the one I have appears below;<figure style="width: 569px" class="wp-caption aligncenter">

<img class="" src="https://i1.wp.com/www.myelectronicslab.com/wp-content/uploads/2016/03/ESP8266-01-Pinout.png?resize=569%2C236" alt="" width="569" height="236" data-recalc-dims="1" /> <figcaption class="wp-caption-text">ESP-01 Pinout (courtesy MyElectronicsLab)</figcaption></figure> 

The most notable limitation of the ESP8266 is the _extremely_ limited I/O capability.  There's only two GPIOs in addition to the UART, and even those GPIOs configure the boot mode if they're held high/low during startup!  There is some info about how to get around this limitation at [this article](http://www.instructables.com/id/How-to-use-the-ESP8266-01-pins/) though.

<p style="text-align: left;">
  <span style="color: #ff0000;"><strong>DANGER:  The ESP8266 is a 3.3v level device.  Driving the inputs with 5v signalling without a level converter will kill it!</strong></span>
</p>

Anyway.  Using a simple 3.3v USB-to-UART converter and a little wiring will allow you to get something useful out of this in a few ways;

  * [Upload Arduino sketches to the onboard MCU](http://iot-playground.com/esp8266-and-arduino-ide-blink-example)
  * [Use the ESP8266 as a wifi modem for your Arduino](http://dalpix.com/blog/connecting-your-arduino-wifi-esp-8266-module)
  * [Directly connect your ESP8266 to a Raspberry Pi](http://www.esp8266.com/wiki/doku.php?id=raspberrypi:getting_started)
  * [Put the NodeMCU firmware on your ESP8266](http://benlo.com/esp8266/esp8266QuickStart.html)

I did the last.  I threw on the floating point firmware for [NodeMCU](http://nodemcu.com/index_en.html) onto my ESP-01, which gives you a nice interactive serial interface, standalone capability, and a built-in WiFi connection library.  You can then upload code you've written in a LUA-style language to do stuff on the thing.

Now for the real magic.  You can use the GPIO2 pin to read temperature/humidity data into the ESP8266.  A very simple guide about how to do that appears in the NodeMCU documentation for the [dht module](http://nodemcu.readthedocs.io/en/dev/en/modules/dht/).

It also turns out that NodeMCU contains a module for communicating to MQTT message brokers (it's actually got a whole lot of really handy IOT modules already in place).

Next plan is to assemble some code for the ESP8266 so that it reads temperature/humidity data and then publishes that to a MQTT channel for aggregation by something else.

Should make for some pretty cheap WiFi-enabled temperature/humidity sensors!