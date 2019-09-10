---
id: 94
title: 'ArduinoISP &#8211; Construction'
date: 2011-05-14T14:00:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=94
permalink: /2011/05/arduinoisp-construction/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/05/arduinoisp-construction.html
categories:
  - Electronics
tags:
  - arduino
---
**<span>Edit:  Looks like my post order got a bit scrambled from me trying to edit the tags...  Doh.  So I'm reposting this to get it at the top and restore a bit of timeline continuity.  Sorry...</span>** 

From my [last post](http://zencoding.blogspot.com/2011/05/arduinoisp-shield-prototyping.html), I breadboarded a design for an Arduino shield which turns it into an ISP and a few other functions.  This post will detail how I went about constructing the final shield onto a [Freetronics prototype shield](http://www.freetronics.com/products/protoshield-basic).

The shield can be constructed in a number of phases, which simplifies testing since you can test functionality at the end of each stage to make sure your core assembly is working as expected.  I'd strongly recommend also testing each wire link you make with a continuity tester to make sure that they're actually connected right and that there aren't any shorts.

<a name="more"></a>

<span><b>Phase 1 - Atmega328p Support Parts</b></span>

The first phase is getting enough parts onto the shield in order to be able to fire up the Atmega328p and get the [Blink](http://www.arduino.cc/en/Tutorial/Blink) sketch working.  From the breadboard assembly I did earlier, the Atmega328p was already programmed with the sketch.

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i1.wp.com/3.bp.blogspot.com/-sgBnm0l9frk/Tc4ruxmccHI/AAAAAAAAAFs/-JdqcGCQNCU/s1600/isp_step1_top.JPG" imageanchor="1"><img border="0" height="320" src="https://i0.wp.com/3.bp.blogspot.com/-sgBnm0l9frk/Tc4ruxmccHI/AAAAAAAAAFs/-JdqcGCQNCU/s320/isp_step1_top.JPG?resize=260%2C320" width="260"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Step 1 - Basic setup (top view)
    </td>
  </tr>
</table>



<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/3.bp.blogspot.com/-6O8t0sAZlnA/Tc4rwSn_MuI/AAAAAAAAAFw/XHWieFGRRVY/s1600/isp_step1_underside.JPG" imageanchor="1"><img border="0" height="320" src="https://i0.wp.com/3.bp.blogspot.com/-6O8t0sAZlnA/Tc4rwSn_MuI/AAAAAAAAAFw/XHWieFGRRVY/s320/isp_step1_underside.JPG?resize=258%2C320" width="258"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Step 1 - Basic setup (underside)
    </td>
  </tr>
</table>

The extra parts are a 3mm LED and a 330r carbon film resistor, for showing power status.  This is built onto the shield, and appears on the bottom right of the top view.  I only soldered the pins on the ZIF that I wasn't going to be using in the whole assembly, leaving the others unsoldered (for now). 

The big bit of wire on the top of the underside view is the resistor leg of the 10k reset pullup resistor.  That gives me a bus that I can use to hook up other things to the reset line (of which there's a lot).  The blue wires are 30AWG wire wrap wire.  Wire wrap wire is very thin, and the insulation is made from a flourocarbon that burns away quite readily under a soldering iron.  It's very fiddly to work with though, but it does the job.  It's thin enough that it can fit into the same hole as another component to make a joint when you solder it.

Finishing up the job, I carefully checked to make sure there were no shorts (including checking continuity from +5v to ground).  Note that when you check +5V to GND, don't be worried if the continuity testers gives a brief buzz, that's just the 100nF noise suppression capacitors charging up.

<span><b>Phase 2 - ArduinoISP Interface</b></span>

The next phase is to connect up all the components required for the ArduinoISP to burn bootloaders into the ZIF socket.  This doesn't include the outbound ICSP header or the FTDI plug.  Results are below;

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i2.wp.com/4.bp.blogspot.com/-9mLu7BhaCCg/Tc4uN8IXV_I/AAAAAAAAAF0/BsIwBBYX1Ps/s1600/isp_step2_top.JPG" imageanchor="1"><img border="0" height="320" src="https://i0.wp.com/4.bp.blogspot.com/-9mLu7BhaCCg/Tc4uN8IXV_I/AAAAAAAAAF0/BsIwBBYX1Ps/s320/isp_step2_top.JPG?resize=258%2C320" width="258"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Step 2 - ArduinoISP Interfacing (top)
    </td>
  </tr>
</table>



<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/2.bp.blogspot.com/-d2pEiskUJJU/Tc4uPcoAJdI/AAAAAAAAAF4/im_vTx6h010/s1600/isp_step2_underside.JPG" imageanchor="1"><img border="0" height="320" src="https://i2.wp.com/2.bp.blogspot.com/-d2pEiskUJJU/Tc4uPcoAJdI/AAAAAAAAAF4/im_vTx6h010/s320/isp_step2_underside.JPG?resize=291%2C320" width="291"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Step 2 - ArduinoISP Interfacing (underside)
    </td>
  </tr>
</table>

More of the same, really.  The only real deviation from design is that the 330R resistors in series with the LEDs are actually on the positive side of the LED, and are 470R's.  Doesn't make much difference, if any.

Again, after assembly test for shorts, and make sure every connection goes where you expect.  Check against the device, not the solder joint, since the joint may have flux on it, and the dry joint may be inside the joint too.  So you want to check the pin (for example) that goes to the Arduino, and the matching ZIF socket hole on the top.

Results were good!  It works first time.  Next up is to attach the FTDI interface plug so that sketches can be uploaded.

**<span>Phase 3 - FTDI Socket</span>**

Following the pinout for the Arduino Pro Mini, attaching an FTDI interface isn't hard.  There's enough room on the bottom of the board for it to fit, so I attached a 6-pin male header there.  Wires were routed along the top of the board for this into their respective locations, with ample use of solder bridges between pads where required.

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/4.bp.blogspot.com/-Nu3gkXWiaEY/Tc6fkS9k5qI/AAAAAAAAAF8/VaGNrtAQ--4/s1600/step3_done.JPG" imageanchor="1"><img border="0" height="320" src="https://i1.wp.com/4.bp.blogspot.com/-Nu3gkXWiaEY/Tc6fkS9k5qI/AAAAAAAAAF8/VaGNrtAQ--4/s320/step3_done.JPG?resize=240%2C320" width="240"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Phase 3 - Testing the FTDI interface
    </td>
  </tr>
</table>

I had a few issues with my home-made FTDI cable.  I thought I got one of the connectors around the wrong way and pulled it apart, but then it turned out I'd made it correctly after all..  D'oh.  Since I haven't made my FTDI adapter yet, the other end of the cable in the photo has a bunch of M-M breadboard jumper leads stuck in the end of the cable.

I won't be attaching the ICSP_OUT header yet, since I don't have a proper ICSP cable.  Once I've got one, I'll attach the header and test it.  At any rate, it's been pretty successful so far, no major slipups and everything's worked pretty well first go.

The programmer board should prove quite handy in the future, I think.