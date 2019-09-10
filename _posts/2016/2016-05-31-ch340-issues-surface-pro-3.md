---
id: 895
title: CH340 Issues on Surface Pro 3?
date: 2016-05-31T13:18:49+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=895
permalink: /2016/05/ch340-issues-surface-pro-3/
categories:
  - Electronics
  - Technical
tags:
  - esp8266
---
I picked up a few LoLin NodeMCU v3 boards the other day (you can read a comparison of the various NodeMCU dev boards [here](http://frightanic.com/iot/comparison-of-esp8266-nodemcu-development-boards/)).  However, I had a hiccup with it.

I couldn't get it to work reliably on my Surface Pro 3 (running Windows 10).  Yet, when I plugged it into a colleague's Lenovo running Ubuntu, it worked fine.

The serial UART (a CH340) was disappearing when the NodeMCU attempted to start up WiFi.  If I held down the reset button so that the ESP never initialized, the UART worked just fine.  Strange.

Then I tried plugging the NodeMCU into a dumb powered USB hub instead of directly into my Surface.  It worked just fine!

My suspicion is that the problem is caused by the power demand reported by the CH340.  It says it needs < 100mA, but I know that the power draw on these things can be upwards of 300mA.  So, I suspect that the Surface is _limiting_ the power draw to what the USB device says is its maximum on startup.  The dumb hub doesn't care about such things, so it powers the device regardless.

**TLDR**;  If you have problems with NodeMCU devices vanishing off your USB bus when you do things with them, plug them into a dumb USB hub.