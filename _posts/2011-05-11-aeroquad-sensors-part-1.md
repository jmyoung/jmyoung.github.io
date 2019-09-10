---
id: 95
title: 'AeroQuad &#8211; Sensors (Part 1)'
date: 2011-05-11T02:46:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=95
permalink: /2011/05/aeroquad-sensors-part-1/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/05/aeroquad-sensors-part-1.html
categories:
  - Quadcopters
tags:
  - aeroquad
  - arduino
  - quadcopter
---
As discussed in my [last post](http://zencoding.blogspot.com/2011/05/aeroquad-sensors-and-imu.html) about the AeroQuad, I wasn't having much luck with the Wii sensors and wound out getting a [BMA180](http://littlebirdelectronics.com/products/triple-axis-accelerometer-breakout-bma180) accelerometer and [ITG3200](http://littlebirdelectronics.com/products/tripleaxis-digitaloutput-gyro-itg3200-breakout) gyroscope ordered in.  Short results:  Gyroscope's fine, accelerometer's not.  But it's being replaced by the supplier, so all's good.

<a name="more"></a>  
**<span>The BMA180 Breakout Board</span>**

The BMA180 board was fitted up to a breadboard using the following schematic (courtesy [Sparkfun Forums](http://forum.sparkfun.com/viewtopic.php?f=14&t=25431));



<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i2.wp.com/img522.imageshack.us/img522/3077/arduinobma180.jpg" imageanchor="1"><img border="0" height="202" src="https://i2.wp.com/img522.imageshack.us/img522/3077/arduinobma180.jpg?resize=320%2C202" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      BMA180 Wiring Schematic
    </td>
  </tr>
</table>

After wiring, I went and set up an I2C Scanner sketch which I found at [todbot.com](http://todbot.com/blog/2009/11/29/i2cscanner-pde-arduino-as-i2c-bus-scanner/).  The idea here was to just see the BMA180 respond on the I2C bus.  However, it didn't work.  After a lot of stuffing around, checking wiring, and reading the Sparkfun [schematic](http://www.sparkfun.com/datasheets/Sensors/Accelerometer/BMA180_Breakout_v11.pdf) and the Bosch [datasheet](http://dlnmh9ip6v2uc.cloudfront.net/datasheets/Sensors/Accelerometers/BST-BMA180-DS000-07_2.pdf), I did a brief experiment.

The BMA180 was locking up the I2C bus whenever it was connected, which made me think that SDO (which was tied to ground) may have been dragging SDI to ground also.  SDO is used in I2C mode as the address select switch - tie it to ground to select I2C address 0x40, tie it to Vccio to select I2C address 0x41.  So I decided to leave SDO floating instead of tying it to ground.

The BMA180 then worked fine!  Cracking out the multimeter after a lot more reading, I checked pins 6 and 7 on the breakout board for a short, and sure enough they're shorted.  So I then very carefully went over my soldering job with a big magnifying glass to make sure there's no bridges, and everything looks fine on my side;

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/3.bp.blogspot.com/-IA56d0loAJQ/Tcsmr5hm_jI/AAAAAAAAAEg/mO-ZZpgtJDE/s1600/bma180.JPG"><img border="0" height="116" src="https://i2.wp.com/3.bp.blogspot.com/-IA56d0loAJQ/Tcsmr5hm_jI/AAAAAAAAAEg/mO-ZZpgtJDE/s200/bma180.JPG?resize=200%2C116" width="200"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      BMA180 Breakout Board<span></span><span></span>
    </td>
  </tr>
</table>

Pins 6 and 7 are on the right on that picture.  Significant gap between the two.  Then I came across threads on forums with other people who have had similar problems, and looking at the BMA180 chip itself, I notice that the soldering looks a bit heavy (pretty big blobs of solder under the chip).  Therefore it's pretty likely that the chip is shorted under the board.  Unfortunate, but the manufacturer is replacing it for me.

**<span>The ITG3200 Breakout Board</span>**

The ITG3200 is a much happier tale.  Note that both the BMA180 and the ITG3200 are 3.3v devices, so you need to push their signals through a logic level converter to get them to the 5v required by the Arduino.  You should use the Tx0 and Tx1 lines, since they are bidirectional.

Wiring was very straightforward, I just followed the [AeroQuad v1.7 wiring schematic](https://aeroquad.googlecode.com/svn-history/r383/trunk/Documentation/Shield/AeroQuad_v1.7/AeroQuad_v17.pdf) and linked up the gyroscope as appropriate.  The SCL (I2C clock) is the yellow line and should go to Analog Pin 5 on the Arduino.  SDA (I2C data) is the green wire and should go to Analog Pin 4.

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i2.wp.com/4.bp.blogspot.com/--Vige9g2zyQ/Tcsm1Z5kVzI/AAAAAAAAAEo/5B-SGeDs-2U/s1600/gyro_overview.JPG" imageanchor="1"><img border="0" height="150" src="https://i1.wp.com/4.bp.blogspot.com/--Vige9g2zyQ/Tcsm1Z5kVzI/AAAAAAAAAEo/5B-SGeDs-2U/s200/gyro_overview.JPG?resize=200%2C150" width="200"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      ITG3200 Test Overview
    </td>
  </tr>
</table>

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/3.bp.blogspot.com/-z-Rtan7wGh8/Tcsm0od3TyI/AAAAAAAAAEk/-yHeEt9iGLQ/s1600/gyro_closeup.JPG" imageanchor="1"><img border="0" height="150" src="https://i0.wp.com/3.bp.blogspot.com/-z-Rtan7wGh8/Tcsm0od3TyI/AAAAAAAAAEk/-yHeEt9iGLQ/s200/gyro_closeup.JPG?resize=200%2C150" width="200"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      ITG3200 Closeup
    </td>
  </tr>
</table>



<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i1.wp.com/4.bp.blogspot.com/-5on13HiQgsc/Tcsm7t3l9uI/AAAAAAAAAEw/dq60-orr_Sc/s1600/llc_closeup.JPG" imageanchor="1"><img border="0" height="150" src="https://i0.wp.com/4.bp.blogspot.com/-5on13HiQgsc/Tcsm7t3l9uI/AAAAAAAAAEw/dq60-orr_Sc/s200/llc_closeup.JPG?resize=200%2C150" width="200"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      LLC Closeup
    </td>
  </tr>
</table>



<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i1.wp.com/2.bp.blogspot.com/-fdZ14Xd1Apo/Tcsm52JC-vI/AAAAAAAAAEs/j2QCD4oXHBE/s1600/i2c_connect_closeup.JPG" imageanchor="1"><img border="0" height="150" src="https://i2.wp.com/2.bp.blogspot.com/-fdZ14Xd1Apo/Tcsm52JC-vI/AAAAAAAAAEs/j2QCD4oXHBE/s200/i2c_connect_closeup.JPG?resize=200%2C150" width="200"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      I2C Wiring to Arduino
    </td>
  </tr>
</table>

Pay special attention to the breadboard.  The left side of the breadboard is the "high voltage" side, where the +5V from the Arduino goes onto the power rails, and the right side is the "low voltage" side, where the +3.3V from the Arduino goes in.  Note that the logic level converter bridges the "middle", with the HV side on the left, and the LV side on the right.  It's very important you don't mix them up, since if you do you'll blow up your gyro.

Anyway, after wiring, I used the [I2CScanner](http://todbot.com/blog/2009/11/29/i2cscanner-pde-arduino-as-i2c-bus-scanner/) sketch I found.  I had to modify it slightly to scan above 100, since the I2C address for the ITG3200 is 0x69, which is 105 in decimal.  No matter, I just set up the scanner to scan up to 127.  Found it first go.

Then, I uploaded and ran this [itg3200_test.pde](http://code.google.com/p/zencoding-blog/source/browse/trunk/arduino/itg3200_test.pde) sketch (on my GoogleCode repository).  Sketch runs, and shows valid data coming from the gyro - I pitch, yaw, and roll it and the X,Y,Z figures change.  All's good!

**<span>Next Steps</span>**

I've verified the gyro works fine, so that's going back in the ESD bag and into my breakout box.  Now I need to wait for a replacement BMA180 and test that.  I'm also still waiting for my receiver and AeroQuad shield.