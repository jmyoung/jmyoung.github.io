---
id: 112
title: 'Electronics &amp; Me &#8211; A History'
date: 2011-04-27T06:02:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=112
permalink: /2011/04/electronics-me-a-history/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/04/electronics-me-history.html
categories:
  - Electronics
---
Rewind 25 years or so.  I've always had an interest in electronics.  Mostly in pulling stuff apart and tinkering with it - I even built a few little FM radio transmitters in my early teens.  Of course, then I discovered computers, and the hardware side of things took a pretty big back seat from then.  And when I discovered the Internet in 1992, that was the end of that.  For a while at least.

<a name="more"></a>  
Besides the assembly part of computers, I didn't really have much more to do with low-level electronics for quite a number of years after then, until I was about 21 or so.  It was around about then that I decided to go back to study, and I decided I'd go and do Electronics at TAFE.  TAFE is the Australian equivalent of a tech school or community college.  I started off with a Cert II in Electronics, which covered off soldering and other basic electronics, and then I moved up to an Adv. Dip IV in Electronic Engineering (which did some microcontroller stuff, and a lot of maths).  Since I'd grown up a bit by then, was paying for the course out of my own pocket, and _wanted_ to study, I actually did the work, did the homework, and practically aced every subject I went into.

Then I wound out moving to another state, and I transferred across from the Adv. Dip to a Bachelor of Information Technology, where I did a big heap of subjects in programming, discrete maths, cryptography and the like.  I got the Bachelor's degree in the end, and that led me into my first professional job in IT, and the rest there is history.  I now work in IT.  And again, electronics took a back seat to the stuff I was doing with programming and general IT.

But during all this, I still kept all my old stuff - my soldering iron, my breadboards, benchtop power supply, parts, IC's and such.  It just sat in the shed, in a box which time forgot.

Fast forward to a few months ago.  I received a whopping huge power bill, which scared the living bejesus out of me.  So I resolved to get to the bottom of my power usage, and I set up an [ENVI-R](http://www.currentcost.com/product-envir.html), hooked up through USB to a Linux box using [MRTG](http://oss.oetiker.ch/mrtg/) to track my power usage.  The story of that will be for another post.  Anyhow, I got talking to a colleague of mine who said he'd built his own power meter using an Arduino microcontroller.

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i2.wp.com/arduino.cc/en/uploads/Main/ArduinoUnoFront.jpg" imageanchor="1"><img border="0" height="238" src="https://i2.wp.com/arduino.cc/en/uploads/Main/ArduinoUnoFront.jpg?resize=320%2C238" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Meet the Arduino Uno microcontroller.
    </td>
  </tr>
</table>

[Arduino](http://www.arduino.cc/).  There's a word I hadn't heard of before.  What was this thing?  So I did some digging.  You see, when I last was heavily into electronics, microcontrollers were clunky, difficult things, which were usually pretty expensive to boot, so I'd never really looked into them.  But when I looked at just how the field had grown in the last ten years (incredibly, it's been that long!), my jaw dropped.

A single-board, all-in-one microcontroller, with multiple analog inputs, many digital inputs and outputs, which has built-in flash, an EEPROM, and enough onboard storage to hold a pretty hefty amount of code?  And it can be programmed with USB?  And it has an onboard voltage regulator?  And you can program it in a familiar C-style programming language?  And it's only $30 for the board??  What the hell happened while I was sleeping?

Course, the answer to that is simple.  Times changed.  The open source revolution sprung up and started getting into hardware.  Flash became really cheap (back when I was first doing this stuff, microcontrollers were programmed via an EPROM you had to wipe with a UV light!).  Integration moved ahead to the point where you can pack all that stuff into a single DIP at low cost.

Awesome.

So I charged right out and got myself a [Sparkfun Inventor's Kit for Arduino](http://www.sparkfun.com/products/10173).  In between all my other things, I've been messing about with it.  And collecting ideas for what I want to do with my newfound discovery.

So, I realize I'm pretty late to the game with this sort of thing, but I just wanted to share my joy at discovering that such a thing exists and is practical and low cost.