---
id: 111
title: 'AeroQuad &#8211; Arduino-based multi-rotor aircraft'
date: 2011-04-27T07:01:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=111
permalink: /2011/04/aeroquad-arduino-based-multi-rotor-aircraft/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/04/aeroquad-arduino-based-multi-rotor.html
categories:
  - Quadcopters
tags:
  - aeroquad
  - arduino
  - quadcopter
---
While I was poking around about what kinds of cool things people do with an [Arduino](http://www.arduino.cc/), I stumbled across [AeroQuad](http://aeroquad.com/).  It's a site and community for folks who are developing an open-source multi-rotor RC helicoptor.

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="http://aeroquad.com/attachment.php?s=16f698198d6f95586946198db50fa4f6&attachmentid=3175&d=1302910144" imageanchor="1"><img border="0" src="http://aeroquad.com/attachment.php?s=16f698198d6f95586946198db50fa4f6&attachmentid=3175&d=1302910144" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      An AeroQuad (pic courtesy AeroQuad.com)
    </td>
  </tr>
</table>

Now that's awesome.

<a name="more"></a>  
As soon as I saw that, I thought to myself _"Dude, you totally have to make one of them!"_.  Cue the research frenzy, cost analysis, and wife justification strategies (love you, snookums).  And guess what, it looks like it's pretty viable, and should make a great project to get me back into electronics and also leave me with something totally awesome at the end of it.

So, in order to make a Quad, there's quite the number of items that are required.  Later posts will detail just how I've gone about actually getting those items and putting everything together into a (hopefully) working quadcopter;

  * **A work area.**  My shed's a storage disaster.  So the need for a work area has triggered off a cleaning frenzy of throwing out lots of stuff, installing shelving to get boxes off the floor, and I also charged out and bought all the stuff to build a (wooden) workbench.  The bench I'll discuss in brief later.
  * **A variable power soldering iron or a 15W and a 30W iron.**  I only owned a 40W iron, which is a bit hefty for delicate electronics on sensors, so I picked up a [$99 soldering station](http://jaycar.com.au/productView.asp?ID=TS1564&CATID=29&form=CAT&SUBCATID=627) from Jaycar.  According to the salesman, the "temperature control" actually just varies wattage, so it can stand in for a 15W iron.
  * **Arduino UNO.**  You can also use an Arduino Mega for more sensors, but I want to start small and simple.  I got a [Uno](http://arduino.cc/en/Main/ArduinoBoardUno) with my Inventor's kit, but I've ordered a second off eBay.
  * **AeroQuad Shield. ** This is a board that sits on top of the Uno and provides connectivity to the sensors.  It's not technically required, but I just got the [v1.9 board](https://www.aeroquadstore.com/ProductDetails.asp?ProductCode=AQ1-009) from the AeroQuad store to get it over and done with.
  * **Nintendo WiiMotion Plus.**  The WMP has a 3-axis gyroscope in it, which is useable with AeroQuad, and is pretty damn cheap.  I picked up one from eBay, and am planning to use it in the build.  There's been reported issues with AeroQuad 2.4 software and Wii components, but it's a work in progress and being fixed.
  * **Nintendo Wii Nunchuk.**  The Nunchuk has a 3-axis accelerometer in it, which goes with the WMP and the shield to make a 6DOF IMU (inertial measurement unit).  These three items make the navigation heart of the AeroQuad.  The Mega can also take a barometer, magnetometer and such for even better navigation.
  * **Miscellaneous Cabling & Stuff.**  Various connectors and stuff are required, I'll get them as I need them.
  * **Frame.**  I haven't bought the frame components yet, since they aren't needed in the early stages.  But I'm planning on using a X of square-section aluminium tube for the arms, with a plastic case for the electronics.  Motor-to-motor diameter will be about 20-24 inches.
  * **Battery.**  Not required just yet, but a main 3S1P LiPo (lithium-polymer) battery is required to drive the motors.  I'll probably aim for a [4000mAh version](http://www.hobbyking.com/hobbyking/store/uh_viewItem.asp?idProduct=7634).  Most advice seems to be to pick a 3S1P battery (11.1 volts) which weighs about the same as the rest of the quad.
  * **Charger to suit Battery.**  Not required yet, but a charger with an automatic balancing feature is pretty key, especially with LiPo's which tend to explode if they're badly charged.
  * **Propellers.**  Not required yet.  They have to be balanced and in counter-rotating pairs.  I'll probably be going with [cheapo 10x6 inch](http://www.hobbyking.com/hobbyking/store/uh_viewItem.asp?idProduct=11333) props, since I'm likely to break heaps.
  * **ESC's.**   Not required yet.  Electronic Speed Controllers drive the main motors at a speed as governed by the servo connection on them.  They're basically like a relay, but variable.  The DC brushless motors used in a quad can draw a _lot_ of current, and given the motor/prop combo I'm probably going with, I'll likely be getting [Turnigy Plush 25A](http://www.hobbyking.com/hobbyking/store/uh_viewItem.asp?idProduct=2163) ESC's.
  * **Motors.**  Not required yet.  Motor/Prop combination is a bit tricky, and also relies on the size and mass of your quad.  I figured out that the [Turnigy 2217-20](http://www.hobbyking.com/hobbyking/store/uh_viewItem.asp?idProduct=5691) motors should give me the thrust I want (3kg, which will be a bit more than double the weight of the quad), while not overdriving the ESC's.
  * **Transmitter and Receiver.**  I wound out ordering a [HobbyKing HK-7X](http://www.hobbyking.com/hobbyking/store/uh_viewItem.asp?idProduct=10186) radio and receiver.  Honestly, I would have preferred a Spektrum DX7, but they are _very expensive_, and I just can't justify the money on a first quad.  As long as the HK-7X actually works, it should be $60 well spent.  I can go with the Spektrum later, if I wind up getting more models or need the better quality.

I've ordered in all the electronics - so that's the controller, IMU components, and Tx/Rx.  I'll wait until I've settled on a frame and have a better idea of weight before I start ordering ESC's, props and motors.  I'll have plenty to play with in the meantime.

So as you can imagine, I'm impatiently awaiting my parts arriving.