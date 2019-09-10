---
id: 742
title: OpenELEC 4.0 Released (XBMC 13.0)
date: 2014-05-12T23:25:33+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=742
permalink: /2014/05/openelec-4-0-released-xbmc-13-0/
categories:
  - Computers
tags:
  - htpc
  - raspberrypi
format: aside
---
With the release of [OpenELEC 4.0](http://openelec.tv/news/22-releases/125-openelec-4-0-released), XBMC 13 ([Gotham](http://xbmc.org/xbmc-13-0-gotham-rises/)) is now available!  For those of us driving a media center with a Raspberry Pi, this is great news (there's significant performance improvements on the RPI).

Anyhow, it turns out that the upgrade process from OpenELEC 3.x is [extremely simple](http://xbmc.org/xbmc-13-0-gotham-rises/).  Just extract the downloaded package, and in the target folder you'll find four files - KERNEL, KERNEL.md5, SYSTEM, and SYSTEM.md5 .   Using Windows Explorer, browse to your media center (eg, \\mediacenter), and drop those files into the upgrade folder.  Reboot the media center, and it automatically upgrades.

On mine, there were a few PVR addons that enabled themselves I didn't want, so I just disabled them and rebooted again, and all appears fine.