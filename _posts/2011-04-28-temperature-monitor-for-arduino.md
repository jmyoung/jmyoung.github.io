---
id: 109
title: Temperature Monitor for Arduino
date: 2011-04-28T00:11:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=109
permalink: /2011/04/temperature-monitor-for-arduino/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/04/temperature-monitor-for-arduino.html
categories:
  - Electronics
tags:
  - arduino
---
<div>
</div>

<div>
</div>

<div>
</div>

<div>
</div>

<div>
</div>

<div>
</div>

<div>
</div>

<div>
</div>

<div>
</div>

<div>
</div>

<div>
</div>

<div>
</div>

<div>
</div>

<div>
</div>

<div>
</div>

<div>
</div>

<div>
</div>

<div>
</div>

<div>
  I've got a 1-year old, and the ducted heating system we have is only a single-zone model with the thermostat in the lounge room.  Since the bedroom doors are typically closed at night, I was always a bit concerned that there may be a large and non-linear temperature differential between the baby's room and the lounge room.  So I needed a way to track temperature between the two rooms overnight.
</div>

<div>
</div>

<a name="more"></a>

<div>
  The <a href="http://www.currentcost.com/product-envir.html">ENVI-R</a> I had fitted is sitting in the return air vent for the heating system and has a built-in temperature monitor which I'm tracking via <a href="http://oss.oetiker.ch/mrtg/">MRTG</a>.  Given its position, the figures coming back from it should be the same as the temperature recorded by the thermostat in the lounge.
</div>

<div>
</div>

<div>
  What I then did was pull out my Arduino Inventor's Kit and assemble <a href="http://www.oomlout.com/a/products/ardx/circ-10">Circuit 10</a>, which basically hooks up a TMP36 temperature sensor to Analog pin 0.  However, I heavily "adjusted" the code they gave to make it suited to my purposes.
</div>

> **Code segment is available at Google Code - [temptracker.pde](http://code.google.com/p/zencoding-blog/source/browse/trunk/arduino/temptracker.pde)**

<div>
  Essentially what happens is that the temperature monitor accumulates temperatures from the TMP36 once a second, and then once every five minutes writes the accumulated average to the EEPROM.  On startup the Arduino dumps the contents of the EEPROM out to the serial port in CSV format so you can recover it.  Given 5 minutes between samples, the Arduino can record a bit over 21 hours of temperature data like that, with no fancy shields or anything required, just a 9V power supply and the TMP36 sensor.
</div>

<div>
</div>

<div>
  After you're done, you should load up the EEPROM_clear example and run it to wipe the EEPROM back to 0.
</div>

<div>
</div>

<div>
   So, hauling out the data from MRTG and the Arduino and charting them in Excel gave me this;
</div>

<div>
</div>

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/2.bp.blogspot.com/--GanL1ZCXIk/TbitsRBcvqI/AAAAAAAAADk/kwQvWGCuiIw/s1600/tempchart.png" imageanchor="1"><img border="0" height="120" src="https://i0.wp.com/2.bp.blogspot.com/--GanL1ZCXIk/TbitsRBcvqI/AAAAAAAAADk/kwQvWGCuiIw/s320/tempchart.png?resize=320%2C120" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Room Temperature Comparison
    </td>
  </tr>
</table>

<div>
</div>

<div>
</div>

The big spike at midnight was where my wife had to get up and left the door open, so the bedroom temperature normalized to close to the lounge room temperature.  It looks like the room temperature differential is on average 7.5 degrees C, and it looks pretty linear.  It also looks like the heater system (which was set to 19 degrees) didn't come on, since there's no spikes on the lounge room chart.

Now, something notable.  These temperature monitors occassionally return garbage data.  The TMP36 on the Arduino sometimes returns 9.08 degrees, and the ENVI-R's temperature sensor sometimes returns 0.  Why this happens I don't understand, but the point of the averaging on the Arduino is to reduce the effect of those broken results (a couple of 9.08's in a whole field of 300 x 15's isn't going to change the average much).  In the case of the ENVI-R, I just manually chopped out any obviously broken data.  I should go and fix my collection script to disregard broken results in MRTG.

Anyhow, it turned out to be pretty useful, and I imagine that code could be used as a base for a whole bunch of simplistic data logging applications, where you only need a small number of samples and want minimal hardware.