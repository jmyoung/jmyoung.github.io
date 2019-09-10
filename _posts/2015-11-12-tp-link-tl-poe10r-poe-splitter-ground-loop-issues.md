---
id: 822
title: TP-Link TL-POE10R PoE Splitter Ground Loop Issues!
date: 2015-11-12T11:20:32+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=822
permalink: /2015/11/tp-link-tl-poe10r-poe-splitter-ground-loop-issues/
categories:
  - Electronics
tags:
  - raspberrypi
format: aside
---
A warning for those who are setting up PoE gear (like I'm researching).  The [TP-Link TL-POE10R](http://www.tp-link.com.au/products/details/cat-4794_TL-POE10R.html) (a low-cost voltage switchable PoE splitter) has a fairly major issue.  It's not [galvanically isolated](https://en.wikipedia.org/wiki/Galvanic_isolation).

This means that if you power a device using the splitter, and that device has a non-isolated electrical connection to something that's independently powered, you may get a [ground loop](https://en.wikipedia.org/wiki/Ground_loop_(electricity)).  This will usually manifest itself as the PoE injector shutting down, but may manifest itself as anything from shorting out components to starting a fire (extremely unlikely).

NOTE - This is not an issue if you have no non-isolated electrical connections going from the device attached to the splitter.  So if you have a Raspberry Pi attached to the Ethernet cable on the splitter and being powered by the splitter you're cool.  But if you plug an HDMI cable from the RPi going into a TV while it's being powered by the splitter, sparks may fly.

The solution is to either be careful, buy a proper isolated splitter, or use a DC-DC isolating converter.

[Reference article here](http://electronics.stackexchange.com/questions/53388/ground-loop-problem-with-power-over-ethernet).