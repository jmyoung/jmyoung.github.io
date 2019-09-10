---
id: 17
title: Raspberry Pi and Argus TV/MediaPortal
date: 2012-12-02T08:56:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=17
permalink: /2012/12/raspberry-pi-and-argus-tvmediaportal/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2012/12/raspberry-pi-and-argus-tvmediaportal.html
categories:
  - Computers
tags:
  - htpc
  - mediaportal
  - raspberrypi
---
<div dir="ltr">
  <a href="https://i1.wp.com/lh3.ggpht.com/-RIAJEHkupok/ULsGmR9qSdI/AAAAAAAAAJE/U4AspylF_L4/s1600/XMBC.gif"><img class="alignleft" style="border: 0px currentColor;" alt="" src="https://i1.wp.com/lh3.ggpht.com/-RIAJEHkupok/ULsGmR9qSdI/AAAAAAAAAJE/U4AspylF_L4/s200/XMBC.gif?resize=200%2C133" width="200" height="133" border="0" data-recalc-dims="1" /></a>I recently set up my <a href="http://en.wikipedia.org/wiki/Raspberry_Pi">Raspberry Pi</a> so that I could watch TV and videos from my <a href="http://www.team-mediaportal.com/">MediaPortal</a> media center.
</div>

<div dir="ltr">
</div>

<div dir="ltr">
  I wanted to do this because I previously had an old laptop in the bedroom for that purpose, and it was noisy.  The RPI offers absolute silence, no moving parts, and very low power consumption.
</div>

<div dir="ltr">
</div>

<div dir="ltr">
  In order to do this, a bit of hardware is required...
</div>

<div dir="ltr">
</div>

<div dir="ltr">
  <strong><span style="color: #ff0000;">EDIT - I've since adjusted things so that I'm now using OpenElec on the RPi, and things are much better.  The experience on OpenElec is really good.</span></strong>
</div>

<div dir="ltr">
</div>

# Parts List

  * A Raspberry Pi.  Mine's the release version with 256Mb of RAM.  A case for it would be a good idea.
  * A 2Gb SD card to run <del><a href="http://www.raspbmc.com/">RaspBMC</a>.  </del>[OpenElec](http://openelec.tv/)
  * A MPEG-2 license code from the Raspberry Pi store.  I really strongly recommend you have this, MPEG-2 playback will be balls without it (which is pretty much all live TV and recorded content).
  * A powered USB hub. The RPI can only sink a small amount of current, which is easily exceeded.
  * A micro USB cable to power the RPI from the hub.
  * A cable to connect the RPI's USB ports to the hub.
  * A RC6 compatible media center remote and receiver. A suitable type will run for under $20 on eBay.
  * A monitor with DVI or HDMI inputs.  If you are using DVI you will need a HDMI-to-DVI cable.
  * A set of analog speakers or your monitor to support audio over HDMI.
  * A network point. I'm using a [TL-PA411](http://www.tp-link.com/en/products/details/?categoryid=1658&model=TL-PA411KIT) Ethernet-over-power setup since I didn't want to run a CAT5 cable across the room.

<div dir="ltr">
</div>

<div dir="ltr">
  Anyway, a breakdown of the special software/hardware components follows;
</div>

<div dir="ltr">
</div>

# The USB Hub

<p dir="ltr">
  The RPI can only sink a very low amount of current through its USB ports.  If you draw too much current, it typically manifests itself as lockups on the RPI at random times.  Running any USB devices through a proper powered hub avoids this.  And you can power the RPI itself from the powered hub, meaning you only need one power adapter.
</p>

<h1 dir="ltr">
  The Remote Control
</h1>

<div>
  <a href="https://i1.wp.com/2.bp.blogspot.com/-FaYsbVxAuWU/ULsNwSMVDLI/AAAAAAAAAJU/u7CwDl47g-0/s1600/HPHP-1.jpg"><img class="alignleft" style="border: 0px currentColor;" alt="" src="https://i1.wp.com/2.bp.blogspot.com/-FaYsbVxAuWU/ULsNwSMVDLI/AAAAAAAAAJU/u7CwDl47g-0/s200/HPHP-1.jpg?resize=200%2C148" width="200" height="148" border="0" data-recalc-dims="1" /></a>
</div>

You can find an appropriate remote control on eBay for about $20.  The model displayed above is an HP Media Center remote control, and it conforms to the RC6 protocol standard.  This type of remote will 'just work' with <del>RaspBMC</del> OpenElec, no configuration required.  It also has an IR Blaster to control a TV, but I don't about configuring that.

<h1 dir="ltr">
  <del>RaspBMC</del>
</h1>

<del>RaspBMC is a distribution of XBMC compiled specifically to run on a Raspberry Pi.  Go to www.raspbmc.com and get the Windows installer, and follow the instructions.  Installation is very straightforward, and then you should have a booting Raspberry Pi with XBMC on it.</del>

<del>If you have a MPEG-2 license (VERY STRONGLY RECOMMENDED) for your RPI, you can enter it into the RaspBMC configuration page once you've installed.</del>

<h1 dir="ltr">
  OpenElec
</h1>

OpenElec is a distribution of XBMC which is intended for use on appliances.  It's a full distribution, including all the plugins you'd want.  Installation is straightforward.  You're really going to need a Linux box of some type to do this easily, for those of you without access to a Linux box, go and download something like [Knoppix](http://knoppix.net/) and run it off a CD.

You can get an install guide for OpenElec on a Raspberry Pi at the [OpenElec Wiki](http://wiki.openelec.tv/index.php?title=Installing_OpenELEC_on_Raspberry_Pi).  It's strongly recommended that you go to the Raspberry Pi store and buy an MPEG 2 license for your RPI.  In order to set up that license, follow the [overclocking guide at this link](http://htpcbuild.com/htpc-software/raspberry-pi-openelec/openelec-overclocking/), and insert the key into your config.txt.

Note that you can safely enter in the overclocking settings in config.txt which correspond to the first step of overclock.  That will give the same default level of overclock that you get with RaspBMC.  Be cautious though.

<h1 dir="ltr">
  ARGUS TV / ForTheRecord
</h1>

As discussed earlier, I use MediaPortal for a media center.  MP does the TV recordings, but LiveTV, Scheduling and watching recordings are all handled by [ARGUS TV](http://www.argus-tv.com/) (formerly known as ForTheRecord).  In order to be able to watch live TV with <del>RaspBMC</del> OpenElec using this setup, you need to use the ForTheRecord (or ARGUS TV) plugin in <del>RaspBMC</del> OpenElec.

Configuration of the plugin is straightforward.  Go to System->Settings->LiveTV, and enable LiveTV.  Then go to System->Settings->Addons, and enable the ForTheRecord plugin under PVR Clients.  Be aware that you should turn the timeouts up a fair bit, the RPI is slow.

# Yes, yes, but how well does it work?

<del>It's ok.  The RPI is quite sluggish when it comes to navigation in RaspBMC and when changing channels.  Skipping ahead on a recording results in horrible artifacts until the next i-frame is reached (which may be up to 10 seconds).  However, it plays most things without complaint, can just be turned off when you're done with it, and is silent, small and cheap.</del>

The experience with OpenElec is markedly better than with RaspBMC.  It's not going to break any performance records, but it plays media fine, with no artifacting on skipping.  Skipping is sluggish, but acceptable.  Pretty decent for something so cheap and low power.