---
id: 1114
title: AnyCubic i3 Mega Marlin Firmware
date: 2019-04-01T10:15:14+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=1114
permalink: /2019/04/anycubic-i3-mega-marlin-firmware/
categories:
  - 3d Printing
tags:
  - 3dprinting
  - anycubic
---
So I've been doing more mucking about with my printer, and I elected to install a [custom firmware](https://www.thingiverse.com/thing:3249319) onto the unit. This firmware is a port of the Marlin 1.1.9 firmware to be compatible with the AnyCubic i3 Mega v3.

Oh, it turns out there are **four** versions of the AnyCubic i3 Mega kicking around. You can find a breakdown of them [here](https://www.thingiverse.com/groups/anycubic-i3-mega/forums/general/topic:27064). Mine is a v3 - identifiable because it has the Ultrabase, v1.1 firmware, and the SD card board is separate from the mainboard (visible through the slots in the bottom plate). The difference is **very important** when it comes to firmware updating.

The custom firmware has a number of benefits - most notably for me is mesh bed levelling. My bed is pretty flat, but there is a slight concavity in the center (of the order of less than 0.1mm, but it affects adhesion in the very center). So before I went too crazy with calibrating the printer, I wanted to have a better firmware onboard.

## OctoPrint and OctoPi

First of all, firmware updating requires a terminal. Since I have many Raspberry Pis kicking around, the easiest way to get what I want is to install [OctoPrint](https://octoprint.org/). This comes in a distribution called OctoPi, and has a lot of awesome features including, critically, a [firmware updater](https://plugins.octoprint.org/plugins/firmwareupdater/) plugin.

Installing OctoPi was a breeze. Then after that, I installed the Firmware Updater, and followed the instructions to set it up. Specifically, the programmer settings are;

  * AVR MCU: Atmega2560
  * Programmer Type: wiring

After applying the firmware update and restarting the printer, the About on the TFT does not show any change. This is expected. You can, however, see the firmware version information in OctoPi on the Terminal display when the printer starts up.

Once that is installed, it is critical that you reset the printer to factory defaults with;

<pre class="wp-block-preformatted">M502 ; Load default values<br />M500 ; Save to EEPROM</pre>

Once that is done, you can then proceed with mesh bed levelling and so-on.

I also picked up a Microsoft LifeCam H5D-00016, which can be assembled into a housing for OctoPi with camera [here](https://www.thingiverse.com/thing:3511248). I'll be putting that together as a project pretty soon.