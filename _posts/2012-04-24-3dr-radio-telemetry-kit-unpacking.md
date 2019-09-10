---
id: 44
title: '3DR Radio Telemetry Kit &#8211; Unpacking'
date: 2012-04-24T06:29:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=44
permalink: /2012/04/3dr-radio-telemetry-kit-unpacking/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2012/04/3dr-radio-telemetry-kit-unpacking.html
categories:
  - Quadcopters
tags:
  - ardupilot
  - quadcopter
---
As part of the new set of quadcopter parts I've ordered, I received my [3DR Radio 915MHz](https://store.diydrones.com/3DR_RadioTelemetry_Kit_915_Mhz_p/kt-telemetry-3dr915.htm) kit yesterday.  This little beauty is about half the price of an equivalent XBee Pro, smaller and lighter, and also can inject signal strength data into the [MAVlink](http://qgroundcontrol.org/mavlink/start) telemetry packets.  It's also very, very new.

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/store.diydrones.com/v/vspfiles/photos/KT-Telemetry-3DR915-2.jpg?ssl=1" imageanchor="1"><img border="0" height="200" src="https://i0.wp.com/store.diydrones.com/v/vspfiles/photos/KT-Telemetry-3DR915-2.jpg?resize=200%2C200&#038;ssl=1" width="200"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      3DR Telemetry Kit (915MHz)
    </td>
  </tr>
</table>

<a name="more"></a>

The unit is tiny, as you can see.  When I get a chance, I'll see about making up a box that can be cut by Ponoko or something for the ground station to go in, for safety's sake.

The air unit is a tiny board which is equipped with an [FTDI Cable](http://www.ftdichip.com/Products/Cables/USBTTLSerial.htm) compatible pin header on one end, and an antenna connection on the other end.  Input and signalling voltage is 5v.

Setup on the ground side is easy, just install the standard FTDI drivers and that's it.  If you buy a pair of modules they are already configured to work together, so all you really need to do is change the settings on each end to make them compliant with your country's regulations.  Info on how to do that can be found at the [3DRadio wiki](http://code.google.com/p/ardupilot-mega/wiki/3DRadio).

Here in Australia, you can use the full 100mW power output on the 915Mhz model, as long as you constrain the frequency range to 915Mhz - 928MHz with at least 20 channels for frequency hopping.  The 433MHz model is a lot more restricted about what's allowed (433.050MHz - 434.790MHz, 25mW max power).

Initial testing from others indicates a range in the air of 8km (!!!!).  For my kit though, it can go into the box until I get the rest of my parts in...