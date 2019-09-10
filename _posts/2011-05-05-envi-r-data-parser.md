---
id: 100
title: 'ENVI-R &#8211; Data Parser'
date: 2011-05-05T01:25:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=100
permalink: /2011/05/envi-r-data-parser/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/05/envi-r-data-parser.html
categories:
  - Other
tags:
  - envir
  - linux
---
In my last post about my [ENVI-R](http://www.currentcost.com/product-envir.html) setup, I talked about how to set up [RSMB](http://www.alphaworks.ibm.com/tech/rsmb).  Now we'll talk about setting up the appropriate scripts so that you can get data parsed from the ENVI-R and have it published to the appropriate channels on the message broker.

<a name="more"></a>

<div>
  <b>Note:  It's been a long time since I've done much Perl coding.  As such, this code is probably horrible.  It works, but yeah, don't expect a grand example of clean Perl code.</b>
</div>

Before you can use this script, there's a number of things that should have already been set up;

  * The Message Broker should be running.  Read my [previous post](http://zencoding.blogspot.com/2011/05/envi-r-data-broker-setup.html) for setup.
  * You should have your ENVI-R all connected and ready on /dev/ttyUSB0.  Read [this post](http://zencoding.blogspot.com/2011/04/envi-r-mrtg-overview.html) for setup.
  * You'll need Perl installed (this should be in by default).
  * You'll need the WebSphere::MQTT::Client CPAN module.  Read this [howto](http://www.perlhowto.com/installing_cpan_modules) for how to install.
  * You will also need the Device::SerialPort , Data::Dumper and Clone modules.  Dumper should already be installed.
  * The Perl script available as [publish-envir.pl](http://code.google.com/p/zencoding-blog/source/browse/trunk/envir/publish-envir.pl) in my GoogleCode repository.

Right.  After all that, drop that script in /usr/local/bin (or somewhere else fairly sane) and just run it.  It will spit out various bits of output about what's happening by default.  You can make an init.d script of the same kind of form as the one you made for the broker to run it on boot.  But just run it by hand first.

What you will notice is that the script will publish data received from the ENVI-R to three channels; <span>envir-raw</span>, <span>envir-last</span>, and <span>envir-average</span>.  The purpose of those channels is as follows;

> **envir-raw:**  The last raw message received from the ENVI-R.  The only processing done to this is to make sure that the line received is of the form <span><msg>X</msg></span>, and it drops <span>X</span> out to the channel.
> 
> **envir-last:**  The parsed values of the last received ENVI-R message.  The timestamp that is generated here is the UNIX timestamp on the host at the time the message was received, NOT the time as far as the ENVI-R is concerned.  Sensors are defined as X.Y where X is the transmitter number (0 is the first) and Y is the channel number (1 through 3).
> 
> **envir-average:**  The calculated 5-minute moving average of the messages received.  The timestamp here is the timestamp on the host at the time the average was sent to the channel, not the ENVI-R's time.  Sensor values are the same and are calculated from the sensors present at the start of the moving average period.  So if you add a sensor, it won't show up in the average for five minutes.

Due to random variance in the temperature and power readings, it's strongly advised to use the <span>envir-average</span> channel for normal charting, and to just use <span>envir-last</span> for looking at instantaneous data or making sure everything works.

Once you've got it running, swap to another window and run <span>stdoutsub envir-last</span>.   After a few seconds you should see parsed packets coming in from the script in a form you can easily use with [MRTG](http://oss.oetiker.ch/mrtg/) or anything else you want.

If you don't see anything after a while, check the <span>envir-raw</span> channel, look at what the script is outputting to the console, and finally check the /dev/ttyUSB0 device itself to make sure you're seeing data.

Assuming it's all working, we're nearly there.  All that remains now is THTTPD, MRTG, and the final glue scripts.