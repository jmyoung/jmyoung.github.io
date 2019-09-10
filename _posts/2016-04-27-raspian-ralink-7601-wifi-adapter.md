---
id: 884
title: Raspian with Ralink 7601 Wifi Adapter
date: 2016-04-27T20:15:07+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=884
permalink: /2016/04/raspian-ralink-7601-wifi-adapter/
categories:
  - Computers
  - Technical
tags:
  - linux
  - raspberrypi
format: aside
---
Recently picked up a Ralink 7601 Wifi Adapter (a no-name clone wifi stub from Ebay), for the princely sum of about $2 delivered.  It's identifable easily because in lsusb it shows up as;

<pre>Bus 001 Device 005: ID 148f:7601 Ralink Technology, Corp.</pre>

Unfortunately, it turns out these things aren't natively supported by Raspian without a firmware module.  But there's hope!

[This guide](https://www.raspberrypi.org/forums/viewtopic.php?f=45&t=122028&p=828070&hilit=mt7601#p828070) shows how to get it running, which essentially just boils down to this command;

<pre>wget https://github.com/porjo/mt7601/raw/master/src/mcu/bin/MT7601.bin -O /lib/firmware/mt7601u.bin</pre>

And then configuring it like you normally would in wpa_supplicant.  Pretty easy stuff in the end.