---
id: 75
title: 'Arduinoven &#8211; Status Update'
date: 2011-07-12T05:13:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=75
permalink: /2011/07/arduinoven-status-update/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/07/arduinoven-status-update.html
categories:
  - Electronics
---
 Been a while since I've posted about the Arduinoven project I'm working on.  I've got a prototype PCB laid out, which is of the appropriate form factor to fit into a [Sparkfun Project Case](http://www.sparkfun.com/products/8601).  The board is a two-layer design, with all through-hole components.  I've adjusted the design to use a [MAX232](http://www.sparkfun.com/products/316) RS232 converter instead of the discrete component RS232-to-TTL adapter (this saves a little space and makes soldering easier).  The full feature list appears below.

<a name="more"></a>

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/1.bp.blogspot.com/-0a1UiUm5oNU/ThvNaneCcPI/AAAAAAAAAJQ/wVuCSz9-rVw/s1600/arduinoven-1.0rc3-sch.png" imageanchor="1"><img border="0" height="220" src="https://i0.wp.com/1.bp.blogspot.com/-0a1UiUm5oNU/ThvNaneCcPI/AAAAAAAAAJQ/wVuCSz9-rVw/s320/arduinoven-1.0rc3-sch.png?resize=320%2C220" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      v1.0RC3 Schematic
    </td>
  </tr>
</table>



<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i1.wp.com/3.bp.blogspot.com/-j-PguCOjll0/ThvNZ4nfPHI/AAAAAAAAAJM/xPLZ6Q347ow/s1600/arduinoven-1.0rc3-brd.png" imageanchor="1"><img border="0" height="240" src="https://i1.wp.com/3.bp.blogspot.com/-j-PguCOjll0/ThvNZ4nfPHI/AAAAAAAAAJM/xPLZ6Q347ow/s320/arduinoven-1.0rc3-brd.png?resize=320%2C240" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      v1.0RC3 Board Layout
    </td>
  </tr>
</table>

The board layout is pretty busy, but I've designed it all with 10mil traces and isolations, and 12mil isolations between the ground pour and other traces, so it should be fairly easy to work on.  Most of the circuit subsections have now been tested on a breadboard (with the exclusion of the microcontroller part), so I'm pretty confident it'll actually work if I haven't messed up a footprint or something.  Still, your mileage may vary...

Key features of the board in its current state are; 

  * Eurocard-sized PCB.  Fits in a Sparkfun Project Case including all peripherals.
  * Programmed via RS232 serial cable, and may be controlled by a computer instead of just the MCU.
  * Back-lit 16x2 LCD for displaying status and controlling the unit.
  * Piezo buzzer for sounding when a program is completed.
  * Menu buttons (up, down, enter) for controlling what the unit is doing.
  * Expanded 32kbyte EEPROM storage capacity for storing temperature graphs for a program that was run
  * Debugging Tx/Rx LEDs for the RS232 lines, along with headers for I2C, power, and all digital/analog pins on the ATmega328p
  * Interface to oven is through a DIN-5 connector so it's easy to make a cable for it
  * Indicator LEDs for power and when the relay is being activated 

In terms of the toaster oven itself, I've installed the relay module, which is isolated from the case via a piece of fiberglass and some extensive standoffs.  The relay module's connections to the DIN-5 panel mounted socket are all heatshrunk, and the whole lot is zip-tied to keep it away from anything running line voltage.  I've also drilled a hole into the oven enclosure and run a rigid spring through to the middle of the enclosure which I've put the thermocouple in so the end of it sits right in the middle of the heating area.  The JB weld on that is drying right now, so it should be ready for testing tonight.

Once I've tested that the oven interface is all working as it should, I should be in a position to breadboard the microcontroller section, and then look at doing a final breadboard of all the parts integrated together (using a normal Arduino).  Then it'll be time to start working on the software, and ordering a PCB!