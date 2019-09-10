---
id: 92
title: 'AeroQuad Shield &#8211; Assembly'
date: 2011-05-18T14:00:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=92
permalink: /2011/05/aeroquad-shield-assembly/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/05/aeroquad-shield-assembly.html
categories:
  - Quadcopters
tags:
  - aeroquad
  - arduino
  - quadcopter
---
This post has been delayed for a few days because I was awaiting my replacement BMA180 Accelerometer breakout board.  I had soldered in the gyo and other components, but held off on this final post until I'd got it all finalized.  The short story?  It works!  Read on for a couple of pics and comments.

<a name="more"></a>

**<span>AeroQuad v1.9 Shield Package</span>**

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/3.bp.blogspot.com/-1tjYZ20uNPc/TdREdjZz4cI/AAAAAAAAAGA/l3P-wFNVuYU/s1600/IMG_0573.JPG" imageanchor="1"><img border="0" height="320 px" src="https://i0.wp.com/3.bp.blogspot.com/-1tjYZ20uNPc/TdREdjZz4cI/AAAAAAAAAGA/l3P-wFNVuYU/s320/IMG_0573.JPG?resize=312%2C320" width="312 px" data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      AeroQuad v1.9 Shield Package
    </td>
  </tr>
</table>

The shield arrived in a well-packed box from the AeroQuad store, along with a sticker.  The contents of the shield package include everything required to assemble the shield, and also include a fair few spare pin headers.  The board is good quality - nice and thick, with a well-made solder mask, every thru-hole is plated and tinned.  The silkscreening is a little blurred, but it's good enough for assembly.  The stackable header kit (bought seperately) has good-quality headers, with fairly thick pins, also tinned.

The logic level converter breakout is at the top left.  I didn't actually use that board, since I already had one soldered up, so I used that.  This means I've now got a spare I need to solder at a later stage, but that can wait until I need an LLC for something.

**<span>Shield Assembly</span>**

Assembly is very straightforward.  I messed up one of the pin headers a small amount, it's lifted about 1mm off the board.  It doesn't really matter, it's not enough to be noticeable, and I'd rather not try and fix it and wreck the board or something, so I just left it alone.  The offsetting on some of the pins means that the headers go in fairly tight, and the pre-tinning means they're very easy to solder.  Assembly went off without a hitch, and everything just fitted.

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i2.wp.com/4.bp.blogspot.com/-I0yewf3kwuQ/TdREexGxpLI/AAAAAAAAAGE/K6SpuD-3L-c/s1600/IMG_0574.JPG" imageanchor="1"><img border="0" height="259 px" src="https://i1.wp.com/4.bp.blogspot.com/-I0yewf3kwuQ/TdREexGxpLI/AAAAAAAAAGE/K6SpuD-3L-c/s320/IMG_0574.JPG?resize=320%2C259" width="320 px" data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Shield with all non-breakouts attached
    </td>
  </tr>
</table>

I attached a few connectors that are not strictly required, so I have some flexibility - namely the spare I2C lines and the extra digital and analog breakouts.  The empty 6x1 pin header just below the receiver input grid is for a barometer, which can't currently be used with the Uno, so I've left that blank.  The prototyping area at the bottom left of the board has also been left empty.  Pay particular attention to the receiver grid when soldering it - do them one at a time.  I didn't, so I had to spend 15 minutes melting the solder and pushing the pins around with a pair of pliers to get them straight...

As for the breakout boards, the pins stick out the bottom quite a long way, and may possibly intercept the Atmega328p under it.  This would be very bad.  My solution there was to push the breakout board into a piece of stripboard I had (which was the same thickness as the Shield), and then cut the pins off sticking out about 1mm from the stripboard.  From there, I could then solder the breakout to the Shield without having the pins sticking out.

**<span>Completed Shield</span>**

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/2.bp.blogspot.com/-80j_E-GOXSE/TdREgDucT_I/AAAAAAAAAGI/eYvwhnufxMU/s1600/IMG_0577.JPG" imageanchor="1"><img border="0" height="265 px" src="https://i0.wp.com/2.bp.blogspot.com/-80j_E-GOXSE/TdREgDucT_I/AAAAAAAAAGI/eYvwhnufxMU/s320/IMG_0577.JPG?resize=320%2C265" width="320 px" data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Completed Shield with receiver cables attached
    </td>
  </tr>
</table>

The process took me a few hours, on account of how I spend a lot of time checking my joints with a magnifying glass, testing everything again and again with a multimeter and such.

After soldering on each pin header and breakout board, I ran over it with the continuity tester checking for shorts between pins, and making sure the pins had continuity with every point on the board they connect to (as per the schematic).  That way I could be sure that if I had a problem it must be with the piece of work I just did and not with some other piece of work I did a while ago.

After soldering on the gyroscope, I did the same continuity tests, but then (after making sure that +5V and GND wasn't shorted or something horrible like that) connected up the shield to the Arduino and ran tests on the gyro itself (ie, run the i2c scanner and AeroQuad configurator).  That way I could prove that the gyro worked on the i2c line.  The same was done after adding the accelerometer.

As a last step, I hooked up the receiver to the channels according to the documentation and fired it up.  I noticed inconsistent behaviour, and realized this was caused by the power drain of the whole kit exceeding the 100mA allowed by USB.  Plugging in an external power supply stopped that issue immediately.



<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/4.bp.blogspot.com/-b9KqEsb5Mxs/TfffE19ECTI/AAAAAAAAAIU/nZvtHT-4q64/s1600/powerusage.png" imageanchor="1"><img border="0" height="320 px" src="https://i1.wp.com/4.bp.blogspot.com/-b9KqEsb5Mxs/TfffE19ECTI/AAAAAAAAAIU/nZvtHT-4q64/s320/powerusage.png?resize=286%2C320" t8="true" width="286 px" data-recalc-dims="1"></a>
    </td>
  </tr>
  
  <tr>
    <td>
      100mA?  Whoops...
    </td>
  </tr>
</table>

Running everything through the configurator from there was easy.  Everything worked, although I needed to reverse a couple of the channels on my transmitter to have the movement direction match up correctly.

Next steps are to wait for the rest of the hardware to arrive and build a frame.  I'll be hunting for a suitable carrier for the electronics tomorrow.