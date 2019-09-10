---
id: 73
title: 'Arduinoven &#8211; Board Ordered!'
date: 2011-07-21T08:01:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=73
permalink: /2011/07/arduinoven-board-ordered/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/07/arduinoven-board-ordered.html
categories:
  - Electronics
---
Well, I've put in an order for version 1.0 (the release version) of the Arduinoven PCB with MakePCB.  I've updated the sch and brd files on my GoogleCode site with the release versions that I sent for manufacturing, but I'll refrain from screenshots and pictures until I've got the board in my hands and have actually tested it.

I replaced the DIN-5 connector with two right-angle 0.1" pin headers, to allow a much more direct connection for the thermocouple to the AD595 amplifier.  Other than that, no major changes.  The board should arrive in a couple of weeks.  Photos when it arrives, and fingers crossed that I didn't stuff anything too badly.

In other news, and to keep me busy in the meantime, I've ordered in a [Bus Pirate](http://dangerousprototypes.com/bus-pirate-manual/) !  I'm intending to use it as an I2C/SPI interface (so I don't have to keep dragging out an Arduino to do it), and also as a cheap-ass JTAG programmer.  I'm thinking of getting into STM32 development, and the first bit of kit I'll need to do that is a JTAG programmer.

The Bus Pirate is pretty slow for a JTAG programmer, but apparently it'll do the job.  And it'll do lots of other stuff to.  If I wind up needing a proper JTAG programmer, I'll get an Olimex [ARM-USB-OCD](http://www.olimex.com/dev/arm-usb-ocd.html) instead.