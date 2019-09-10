---
id: 91
title: 'ArduinoISP &#8211; Completed!'
date: 2011-05-19T07:14:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=91
permalink: /2011/05/arduinoisp-completed/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/05/arduinoisp-completed.html
categories:
  - Electronics
tags:
  - arduino
---
In my [last post](http://zencoding.blogspot.com/2011/05/arduinoisp-construction.html) on the topic, I assembled the majority of the ArduinoISP shield I'd prototyped.  Last night, I finished assembly, and attached an ICSP header to it for performing the last step.

<a name="more"></a>

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/1.bp.blogspot.com/-Qlogh4mAFP8/TdREr5T2ynI/AAAAAAAAAGM/g2frK48hnQI/s1600/IMG_0579.JPG" imageanchor="1"><img border="0" height="320" src="https://i2.wp.com/1.bp.blogspot.com/-Qlogh4mAFP8/TdREr5T2ynI/AAAAAAAAAGM/g2frK48hnQI/s320/IMG_0579.JPG?resize=268%2C320" width="268"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      ArduinoISP Shield - Top View
    </td>
  </tr>
</table>

Adding the ICSP header wasn't too hard - in the above photo it's at the bottom left.  Pin 1 is the bottom left-most pin, and pin 1 on the FTDI cable (the ground pin) is on the left as well.  The miniature black reset button on the right causes the underlying Arduino to reset.  The big red reset button at the top resets the microcontroller in the ZIF socket.

I made a minor boo-boo.  I should have put the ICSP header one row up from the bottom of the board.  As it is, pins 1 & 4 are very close to interfering with the top of the USB plug on the Arduino, which is rather bad.  I'll take care of that with a spot of hot glue as insulation tonight.  Might also take the opportunity with the hot glue gun to glue down some of the wires on the underside to ensure they don't come to grief.

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i1.wp.com/3.bp.blogspot.com/-BSx7noUPXN4/TdREtUpMnZI/AAAAAAAAAGQ/hnHA3bfq3PY/s1600/IMG_0580.JPG" imageanchor="1"><img border="0" height="320" src="https://i0.wp.com/3.bp.blogspot.com/-BSx7noUPXN4/TdREtUpMnZI/AAAAAAAAAGQ/hnHA3bfq3PY/s320/IMG_0580.JPG?resize=285%2C320" width="285"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      ArduinoISP Shield - Underside
    </td>
  </tr>
</table>

Anyway, testing was all successful first go.  Onboard/offboard ISP, FTDI programming, and blink test all work fine, as well as both reset buttons.  Success!

One comment though - wire wrap wire for doing this kind of wiring is very, very, very fiddly.  But it works reasonably well.