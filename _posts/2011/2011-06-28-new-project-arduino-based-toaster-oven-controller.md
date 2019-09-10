---
id: 79
title: 'New Project &#8211; Arduino-based Toaster Oven Controller'
date: 2011-06-28T13:04:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=79
permalink: /2011/06/new-project-arduino-based-toaster-oven-controller/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/06/new-project-arduino-based-toaster-oven.html
categories:
  - Electronics
tags:
  - arduino
---
Now that I've got the MCE Remote all built and in service (works quite nicely!), I need a new project.  I'm interested in getting involved in surface mount devices.  The reason for this is threefold - there are certain devices that aren't available in through-hole packages, when using SMT you can typically make a board a lot smaller, and lastly individual SMT components not on breakout boards are typically a LOT cheaper than the already-soldered part.

There's a few ways to handle surface mount.  You can use a normal soldering iron, really steady hands, and a lot of patience.  You can use a hot air gun (I'm probably going to get a rework station for this).  Or you can use a reflow oven.  The reflow oven "cooks" the components onto the board, and if handled properly is the best and easiest way to solder a whole bunch of components onto a board.

A professional reflow oven costs a large amount of money, but it's possible to press-gang a normal toaster oven into the task by modifying it so that it can be temperature controlled and given a normal reflow temperature profile.  There are kits available to do this, like [this](http://littlebirdelectronics.com/products/reflow-toaster-controller).  However, in the spirit of adventure (and not wanting to mess with a PIC when Arduino is familiar), I decided to roll my own...

<a name="more"></a>Behold!  The first schematic of the Arduinoven;

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i1.wp.com/3.bp.blogspot.com/-Gnx90n-Qlss/TgnIDtfFk6I/AAAAAAAAAI8/xhej34YQXjU/s1600/arduinoven_schematic.png" imageanchor="1"><img border="0" height="220" src="https://i0.wp.com/3.bp.blogspot.com/-Gnx90n-Qlss/TgnIDtfFk6I/AAAAAAAAAI8/xhej34YQXjU/s320/arduinoven_schematic.png?resize=320%2C220" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      The Arduinoven v1.0
    </td>
  </tr>
</table>

This schematic is entirely theoretical at the moment (I haven't breadboarded any of it), however much of the design was lifted from the Arduino [Severino](http://www.arduino.cc/en/Main/ArduinoBoardSerialSingleSided3) board, which has many of the features I wanted.  I simply extended it a lot to add all the extra functionality.  The design has been assembled so that each section can be tested largely independently to simplify breadboarding when I come to that stage.  With the design, there were a few key features I wanted to adhere to;

  * Must be suitable for production by somewhere like BatchPCB (and can therefore be two layer).
  * Must have entirely through-hole components.
  * Must use an ATmega328p and be programmable through the Arduino IDE
  * Be able to store a significant amount of temperature data (that's what the i2c EEPROM is for)
  * Use an LCD and press buttons for an interface (uses an i2c LCD module)
  * Relay and thermocouple connections need to be on the actual oven itself, but the Arduinoven will be a removable device (hence the DIN-5 connector)
  * Be expandable in case additional hardware is desired (hence all the pin headers)
  * Use RS232 for serial communications to a PC
  * Fit onto a Eurocard-sized format PCB (100x80mm)

All in all, I'm pretty happy with how the design's looking.  More information once I receive my shipment of parts and I can start with the prototyping.  Once I'm happy with the prototyping, I'm intending to get the board manufactured by BatchPCB so I can get something professional looking.

_Note:  Call me suspicious, but I think that the Severino's schematic is in error and C8 (C5 on mine) is around the wrong way.  I'll look into it more before I actually breadboard anything._