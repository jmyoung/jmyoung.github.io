---
id: 626
title: New radio firmware for GT-i9305T with CM10.1
date: 2013-06-05T09:23:26+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=626
permalink: /2013/06/new-radio-firmware-for-gt-i9305t-with-cm10-1/
categories:
  - Mobile Devices
tags:
  - cyanogenmod
  - i9305
---
<span style="color: #ff0000;"><strong>EDIT:  The new radio firmware didn't stop my mdm_hsic_pm0 problem, but enabling data roaming has seemed to.  I'm definitely not out-of-country or in a position where data roaming should be a thing, so I'm not too worried about having it on.  However, turning it on seems to have immediately put a stop to the mdm_hsic_pm0 shenannigans.  Very strange, but I'm suspicious that doing so may have gotten around some kind of bug in the radio firmware.  More if I find out more.</strong></span>

There's a new radio firmware available for the GT-i9305T (Samsung Galaxy S3 International, Telstra Australia variant).  The new firmware is coded **UBBMB2**, and can be downloaded from [this thread](http://forum.xda-developers.com/showthread.php?t=2010116) at XDA Developers.

I usually avoid updating radio firmware unless there's an actual need to.  In this case, my phone with the old DVALI5 radio on it was randomly blowing half the battery overnight, with **mdm\_hsic\_pm0** being the top wakelock consumer (and having a wake time of half the time the phone was unplugged!).  This is typically associated with Fast Dormancy issues.  So, I went and updated the radio, and yesterday the phone only used an average of 0.9% battery per hour, with **mdm\_hsic\_pm0** being a lower consumer and with a much, much lower proportion of wake time compared to run time.

In addition, for anyone using the official CyanogenMod 10.1 nightlies for the GT-i9305T, keep in mind that the nightlies have changed over to CM 10.1.  This means if you're using them, you should update your Google Apps install to the latest version too.  You can get them from [Goo.im here](http://goo.im/gapps).

Note, updating both of the above items (gapps update, radio firmware) can be done without a factory reset, so you won't lose your stuff.  But I still advise doing a nandroid backup anyway.

To update, just drop the ZIPs onto your SD card, boot up into ClockModRecovery, and flash them.