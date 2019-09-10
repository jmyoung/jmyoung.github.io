---
id: 72
title: Bus Pirate Received!
date: 2011-07-27T11:42:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=72
permalink: /2011/07/bus-pirate-received/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/07/bus-pirate-received.html
categories:
  - Electronics
tags:
  - avrdude
  - buspirate
---
Just got my delivery made, and now I have a [Sparkfun Bus Pirate](http://www.sparkfun.com/products/9544)!  One thing I noticed straight away is that the cable provided has exactly the same colour scheme as the original Seeedstudio version, but the shroud on the 10-pin header is reversed, meaning that all the colours were swapped.

Since I wanted to use [this chart](http://dangerousprototypes.com/docs/Common_Bus_Pirate_cable_pinouts), a little operation was in order.  Fortunately it turns out that you can wiggle the shroud off the pins and reverse it, making the colour scheme all match up the way it should, although it does mean your cable is now coming out the wrong end.  Doesn't matter much.

My intention is to use the thing to do I2C testing, as well as use it as a standin ICSP programmer (newer versions of AVRDUDE support it) for 8-pin AVRs.  And lastly, as a cheapo JTAG debugger for when I start getting into ARM.

I'm in the midst of setting up OpenOCD to test it out for JTAG, so I'll blog about my experiences there once that's done.

A very cool little bit of kit.  Now I just need to find a suitable box.  The thing is tiny, about the size of a matchbox...