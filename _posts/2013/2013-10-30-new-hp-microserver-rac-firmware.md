---
id: 691
title: New HP Microserver RAC Firmware
date: 2013-10-30T09:51:26+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=691
permalink: /2013/10/new-hp-microserver-rac-firmware/
categories:
  - Technical
---
Came across this the other day - the post is a bit old, but it was news to me, and it resolves an old issue I've been having.  A new firmware is now available for the HP Microserver remote access card - v1.3, information is available [here](http://homeservershow.com/forums/index.php?/topic/5066-proliant-microserver-remote-access-card-firmware-update/).

Notably, this purports to fix the issue where the RAC just goes offline for some reason and stops responding over the network.  This fix appears to have resolved the problem for me.

I had to deploy using the script deploy in Linux because I couldn't use the GUI.  Once that was done, I had to reconfigure the RAC, which I did by using [ipmitool](http://ipmitool.sourceforge.net/).  Now, everything seems just fine.  For now.