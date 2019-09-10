---
id: 65
title: 'Arduinoven &#8211; Board Assembly'
date: 2011-08-28T22:44:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=65
permalink: /2011/08/arduinoven-board-assembly/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/08/arduinoven-board-assembly.html
categories:
  - Electronics
tags:
  - arduino
---
Assembled the Arduinoven board over the weekend. It wound out being that one of the boards I received had a manufacturing defect, but the other two didn't.  While it would be pretty straightforward to correct the defect with a craft knife, I decided to just use one of the other boards.  I guess that's why they sent me three boards and it's also why you should check over a new board with a continuity tester...  Anyway, after all that, IT WORKS.

Overall board quality was high, although I'm glad I used the wide isolation distance that I did.  There were two other spots where if I hadn't used a large isolation I probably would have had a short.

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i2.wp.com/2.bp.blogspot.com/-KEYYfhkLAr8/Tlq45H01BmI/AAAAAAAAAJg/UqBs94V-OGk/s1600/assembled_topside.JPG" imageanchor="1"><img border="0" height="269" src="https://i0.wp.com/2.bp.blogspot.com/-KEYYfhkLAr8/Tlq45H01BmI/AAAAAAAAAJg/UqBs94V-OGk/s320/assembled_topside.JPG?resize=320%2C269" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Assembled Topside - in Sparkfun project case
    </td>
  </tr>
</table>

<a name="more"></a>



<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i2.wp.com/2.bp.blogspot.com/-VipThsycr5Q/Tlq47ESOH7I/AAAAAAAAAJk/Bp7tsPdNA78/s1600/assembled_underside.JPG" imageanchor="1"><img border="0" height="251" src="https://i0.wp.com/2.bp.blogspot.com/-VipThsycr5Q/Tlq47ESOH7I/AAAAAAAAAJk/Bp7tsPdNA78/s320/assembled_underside.JPG?resize=320%2C251" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Assembled underside
    </td>
  </tr>
</table>

I had a bit of difficulty getting the power and relay LEDs at the right length, hence the dark spots on the underside of the board at that point. Additionally, I didn't solder the whole way across the locking pins for the DB9 port (they don't do a whole lot).  I probably should go over the whole board's topside and fill up any of the through-holes which didn't wick through completely from the underside.  Might do that later.

First part I assembled was the power supply and power LED, that way I could ensure that power was running through the board correctly. 

Second part was assembling the microcontroller, crystal, loading capacitors, reset switch, reset line pullup resistor, ICSP header, and relay LED.  That way I could test that the MCU was operational by programming it with ICSP.  Then I soldered on the FTDI header, auto-reset jumper and capacitor, and made sure I could talk to the MCU via FTDI.  Lastly in this part, I soldered on the LCD i2c header and made sure that I2C was operational.

Part three was assembling the DB9 socket, MAX232 chip, RX/TX leds, and load capacitors for the MAX232.  This allows you to connect a serial cable to the unit and make sure you can talk to the MCU through serial.

Part four was soldering on the right-angle header pins for the thermocouple and relay, and putting in the AD595 thermocouple amplifier.  Then you can test that the amplifier works.

Next up, solder on the I2C pullup resistors and the 24LC256 i2c EEPROM.  A quick run with an I2C scanner shows it works.

And lastly, solder in the resistive network for the buttons and then the buttons and any remaining parts.

Assembling in this way allows each section to be tested and verified before you move onto the next, simplifying debugging if there's any problems.

At any rate, everything worked first go.  Well, I got a LED around the wrong way, but it happens.  Next up is to start working on the software and cutting out the case.  That may take me a while...