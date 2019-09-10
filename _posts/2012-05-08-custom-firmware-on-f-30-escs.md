---
id: 42
title: Custom Firmware on F-30 ESCs
date: 2012-05-08T13:38:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=42
permalink: /2012/05/custom-firmware-on-f-30-escs/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2012/05/custom-firmware-on-f-30-escs.html
categories:
  - Quadcopters
tags:
  - avrdude
  - buspirate
---
I just got my new [Hobbyking F-30](http://www.hobbyking.com/hobbyking/store/uh_viewItem.asp?idProduct=15205) ESCs for the new quad I'm building.  Now, I specifically picked these ESCs because they are a great candidate for using the [SimonK ESC](https://github.com/sim-/tgy) firmware on.  This firmware is custom-written to be suitable for multicopters, and has far superior response characteristics to standard firmware.  The F-30 has a few features which make it a good pick (I think) for this firmware;

  * It has an Atmel processor, and there's no signs that will be stopping.  The Plush series changed over to a Silicon Labs processor recently, so all new ones will be SiLabs
  * Overpowered for what I need, but it only runs 2 grams heavier than the F-20
  * Has an external oscillator
  * Has programming pads and they're in a row and quite accessible

You can find a database of supported ESCs and notes about them at the [RapidESC Database](http://wiki.openpilot.org/display/Doc/RapidESC+Database).  At any rate, I went and cut open my F-30's, stripped off the heatsink, and what I found was basically exactly what I found at the [RCGroups thread](http://www.rcgroups.com/forums/showthread.php?t=1513678) about it;

<table cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td>
      <a href="https://i2.wp.com/1.bp.blogspot.com/-8jRA1x42Wxw/T6nCGZKLtXI/AAAAAAAAABQ/PZhJK_qthic/s1600/HK_30A_UBEC.jpg"><img alt="" src="https://i0.wp.com/1.bp.blogspot.com/-8jRA1x42Wxw/T6nCGZKLtXI/AAAAAAAAABQ/PZhJK_qthic/s320/HK_30A_UBEC.jpg?resize=320%2C202" width="320" height="202" border="0" data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      HK F-30 ESC (pic courtesy RCGroups.com)
    </td>
  </tr>
</table>

<div>
</div>

Fantastic!  So, I went ahead and made up a jig for connecting to the pads using some single-strand copper wire, a hot glue gun, and a clothespeg;

<table cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td>
      <a href="https://i2.wp.com/2.bp.blogspot.com/-NpXVhCqzYiE/T6kXW5jZ_OI/AAAAAAAAABE/Qrhs3KX9lj8/s1600/IMG_0831.JPG"><img alt="" src="https://i0.wp.com/2.bp.blogspot.com/-NpXVhCqzYiE/T6kXW5jZ_OI/AAAAAAAAABE/Qrhs3KX9lj8/s320/IMG_0831.JPG?resize=320%2C240" width="320" height="240" border="0" data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Programming jig - highly professional
    </td>
  </tr>
</table>

As for programming, I wired it all up to my BusPirate, and then ran the following command;

<pre>avrdude -c buspirate -P COM8 -p m8 -v -U flash:w:bs_nfet.hex</pre>

The .HEX file can be got from the [Downloads link](https://github.com/sim-/tgy/downloads) at SimonK's GitHub site.  It was rather fiddly getting all six pads touching at once, but once I got into the swing of it, I got all six programmed fairly quickly.

Then for testing.  For testing, I used a bunch of leads with alligator clips on them, hooked up the ESC to a spare [Turnigy 2217-16](http://www.hobbyking.com/hobbyking/store/__5690__Turnigy_2217_16turn_1050kv_23A_Outrunner.html) motor I have lying around (no propeller!), and then connected the power to a benchtop power supply I've got.  I used the benchtop supply because it can't put out too much current, has short circuit protection, and has an adjustable voltage output (I used 8 volts).  Hook up the ESC servo cable to channel 3 on a cheap receiver, and hold onto your hat.

They all worked.  First power up was with the transmitter off, and the ESC beeped three times (ascending) as expected.  Second power up was with the throttle on maximum.  Three beeps, followed by one extra beep.  Drop throttle to minimum, ESC emits two beeps.  From there, moving the throttle makes the motor fire up and do what you'd expect.  There's a notable lack of strange clicking sounds like you get with the stock firmware.

Next up is to repeat the same thing on my older Turnigy Plush 25A ESCs, but first I need some heatshrink that I can put on all the ESCs to protect them.  I'm quite looking forward to seeing how the existing quad flies with this new firmware in place.