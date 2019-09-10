---
id: 104
title: 'AeroQuad &#8211; Wii Sensors and IMU'
date: 2011-05-01T07:37:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=104
permalink: /2011/05/aeroquad-wii-sensors-and-imu/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/05/aeroquad-sensors-and-imu.html
categories:
  - Quadcopters
tags:
  - aeroquad
  - quadcopter
---
<span><i>Update:  Well, I got a logic level converter, and it made no difference to the outputs.  Seems the clones just weren't any good.  No matter, I've already got an <a href="http://littlebirdelectronics.com/products/tripleaxis-digitaloutput-gyro-itg3200-breakout">ITG-3200</a> gyro and a <a href="http://littlebirdelectronics.com/products/triple-axis-accelerometer-breakout-bma180">BMA180</a> accelerometer waiting in the wings. Chalk that one up to experience.</i></span>

On Friday, I got the Wii nunchuk and Wii Motion Plus that I picked up from eBay.  Unfortunately, it turns out that they're clones, and not original Nintendo parts.  However, for the price I paid, I really can't be surprised.  Clones however can be ...  difficult.  So, let's get unpacking and assembling, and see how we go.

<a name="more"></a>

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i1.wp.com/4.bp.blogspot.com/-FpkLYCta4us/Tbz1omGR_7I/AAAAAAAAAEE/rV_f58Nha-g/s1600/wii_sensors.JPG" imageanchor="1"><img border="0" height="240" src="https://i1.wp.com/4.bp.blogspot.com/-FpkLYCta4us/Tbz1omGR_7I/AAAAAAAAAEE/rV_f58Nha-g/s320/wii_sensors.JPG?resize=320%2C240" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      WMP board (top), and Nunchuk (bottom)
    </td>
  </tr>
</table>

Unpacking the two boards, and then desoldering the connectors to get the raw PCBs didn't take long and wasn't very hard.  But first, I matched up all the pins using a multimeter to verify that the pinout is how I expected it to be.  The pinouts were fairly similar between the two boards, and fortunately the coloured wires used a sane colour scheme which I duplicated when I made the jumpers that go to the Arduino.

So, following [this tutorial](http://aeroquad.com/showthread.php?1658-Tutorial-for-using-the-Wii-sensors-with-AeroQuad) on the AeroQuad forums, I marched ahead.  First, I discovered that I need desoldering braid - a solder sucker isn't good enough for that kind of tiny work.  Second, the tip on my iron is too big!  I need a smaller tip, really.  But I made do anyway.

In essence, the nunchuk is attached to the WMP board, then the WMP board is connected to the Arduino.  First, I attached the nunchuk, as here;

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="http://1.bp.blogspot.com/-YapX2V12JaY/Tbz1tXUsYiI/AAAAAAAAAEQ/NfWiNTeuyiA/s1600/wmp_nunchuk+wiring.JPG" imageanchor="1"><img border="0" height="240" src="https://i0.wp.com/1.bp.blogspot.com/-YapX2V12JaY/Tbz1tXUsYiI/AAAAAAAAAEQ/NfWiNTeuyiA/s320/wmp_nunchuk+wiring.JPG?resize=320%2C240" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Connecting the WMP to the Nunchuk
    </td>
  </tr>
</table>

The grey wire is the Device Detect line on the nunchuk, which isn't needed.  Note the jumper on the WMP that links VCC to the WMP's Device Detect line.

After that, it's necessary to get the WMP and the nunchuk aligned properly.  This alignment is the same alignment that's used for the MultiWii.  "Forward" is at the top of the picture.

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/1.bp.blogspot.com/-IMS8LBDa3zc/Tbz1nHnt3tI/AAAAAAAAAEA/FZdoT__MX10/s1600/wii_orientation.JPG" imageanchor="1"><img border="0" height="320" src="https://i2.wp.com/1.bp.blogspot.com/-IMS8LBDa3zc/Tbz1nHnt3tI/AAAAAAAAAEA/FZdoT__MX10/s320/wii_orientation.JPG?resize=240%2C320" width="240"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Sensor orientation - up is "front"
    </td>
  </tr>
</table>

So, with the sensors in that orientation, I attached the coloured wires from the nunchuk to the location where you see the grey wires on the WMP, and then attached wires using the same colour scheme to the WMP so they could go to the Arduino.  Attaching the whole kit to a breadboard gives this;

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i1.wp.com/4.bp.blogspot.com/-MbAwrEBT1-w/Tbz1qUlmdpI/AAAAAAAAAEI/nkGn2OmXyxU/s1600/wmp_arduino.JPG" imageanchor="1"><img border="0" height="240" src="https://i0.wp.com/4.bp.blogspot.com/-MbAwrEBT1-w/Tbz1qUlmdpI/AAAAAAAAAEI/nkGn2OmXyxU/s320/wmp_arduino.JPG?resize=320%2C240" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Attached to a breadboard
    </td>
  </tr>
</table>

The yellow wire is SCL, the green wire is SDA, black is GND, and red is +VCC.  SDA connects to analog pin 4, and SCL connects to analog pin 5.  VCC is set to 5 volts.

<span><b>So, how did it work?</b></span>

Not so well, to be honest.  The WMP appears to be rather intermittent as to whether it works or not.  It either just returns zeroes or some garbage value that doesn't change.  Power cycling the WMP repeatedly can cause it to come good and then work fine, but losing the IMU appears to make the AeroQuad software crash, requiring a reset.  And the reset kills off the WMP again.

However, putting [MultiWii](http://www.multiwii.com/) onto the Arduino had a slightly different result.  The WMP still would often not initialize properly, but when it did I could connect the MultiWii configurator and have the pitch/roll meters work properly.  That's a start, but it's not exactly what I want.

I asked the good folks at AeroQuad for help [on the forum](http://aeroquad.com/showthread.php?2869-Wii-Sensors-Intermittent), but it looks like my problem may be the clone sensors.  Not much I can do there, at least until I get a logic level converter so I can try and run it off 3.3v and see if that stabilizes things.

<span><b>What now?</b></span>

Well, I'm thinking what I'll do is order in an [ITG-3200](http://littlebirdelectronics.com/products/tripleaxis-digitaloutput-gyro-itg3200-breakout) gyro and a [BMA180](http://littlebirdelectronics.com/products/triple-axis-accelerometer-breakout-bma180) accelerometer, which are the recommended parts to go onto the AeroQuad [v1.9 shield](https://www.aeroquadstore.com/ProductDetails.asp?ProductCode=AQ1-009) I've got coming in.  That shield does come with a logic level converter board, so I'll test the WMP using it, but I'll use the "correct" parts anyway.  If the WMP works fine with the LLC, then I'll keep them aside for a miniquad or something similar.

It's a bit disappointing to get roadblocked straight out of the gate, but I went with the Wii sensors knowing they were dirt cheap and with the view that I might have to get the expensive breakouts anyway.  Looks like that happened, and I'll put more time into diagnosing it later.

I have a pretty good hunch the problem is going to be the 5v feed.