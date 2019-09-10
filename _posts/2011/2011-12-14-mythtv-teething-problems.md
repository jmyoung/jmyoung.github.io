---
id: 54
title: 'MythTV &#8211; Teething Problems'
date: 2011-12-14T04:49:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=54
permalink: /2011/12/mythtv-teething-problems/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/12/mythtv-teething-problems.html
categories:
  - Computers
tags:
  - htpc
  - mythtv
---
As discussed earlier, I've been rebuilding my Media Center with MythTV running on Fedora 15.  I've been having a number of ... issues ... with it.  Fortunately I've gotten a lot of them finally nailed down.

<span><b>Tuner Issues</b></span>

I had two Hauppauge HVR-2200 tuners.  One of them just flat out didn't work, and the other worked, but the second tuner on it was frequently poor.  I've since pulled them both out and intend on putting them into my Windows main PC the next time I have it out to see if they work.

I've replaced them with a Leadtek WinFast DTV Dongle Gold and a Leadtek WinFast DTV2000DS.  The Gold is a USB key-format DVB-T tuner (single tuner), and the DTV2000DS is a PCI dual-tuner.

The Gold just worked.  And so did the DTV2000DS, for that matter.  The DTV2000DS interestingly enough is actually a dual USB tuner built onto a PCI to USB bridge.  Annoyingly though, the two tuners are completely indistinguishable to udev, resulting in an inability for udev to make distinct adapters for them.  A solution for this when I come up with one.

Anyway, I had a number of difficulties with them.  Primarily sometimes on powerup the second tuner doesn't work, or it randomly stops working.  What I've done is to add this to /etc/rc.d/rc.local;

> <div>
>   echo -n -1 > /sys/module/usbcore/parameters/autosuspend
> </div>

This prevents the kernel suspending power to the USB ports, which apparently causes issues with these tuners.  Secondly, in a bid to make it work consistently, I also added the following to a new file /etc/modprobe.d/tda18271.conf;

> <div>
>   options tda18271 cal=0
> </div>

This disables radio calibration on module load for the tuners.  My suspicion is that radio calibration was throwing the tuners off when the modules are loading.  This may be bunk, but so far it works.

Lastly, I've also discovered a way to test the tuners from the command line.  I'm considering adding this to the bootup procedure so that I can verify that all three tuners are fully operational before letting MythTV use them - to prevent instances of a recording being made that's garbage.  
<span><b><br /></b></span>  
<span><b>Fedora 16 Upgrade</b></span>

In my bid to try and get all the tuners working properly (the other issue I had was the second tuner on the DTV2000DS suddenly stop working and not work again), I upgraded my MythTV box to Fedora 16.  This was actually pretty painless, except for one really big gotcha.

Fedora 15 Mythbackend runs as root.  Fedora 16 Mythbackend runs as mythtv.  This means that you won't have write access to the spooler drive, and it basically breaks Myth.  Until I get around to fully fixing up the permissions, I've changed /lib/systemd/mythbackend.service to run as mythtv.

<span><b>Sleep / Hibernation</b></span>

I have a number of issues trying to get sleep/hibernate working.  If I use pm-suspend, the graphics card doesn't restart.  If I use pm-hibernate, initially the box just simply locked up.  I determined the lockup was due to the tuner drivers, so I wrote a script to stop the Myth Backend service and unload the modules on hibernate.

But then I discovered that frequently on waking up some of the tuners wouldn't work!  I haven't got a solution for this yet, but I'm working on it.

All in all, it's been a worthwhile exercise, but I've been getting a lot of grief from the TV tuners.  I've left it alone for this week, but in a week or so I'll try and get hibernation working again.