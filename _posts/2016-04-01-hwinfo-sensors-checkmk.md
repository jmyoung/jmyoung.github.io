---
id: 862
title: HWiNFO Sensors in CheckMK
date: 2016-04-01T11:40:16+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=862
permalink: /2016/04/hwinfo-sensors-checkmk/
categories:
  - Computers
  - Technical
tags:
  - checkmk
  - linux
  - nagios
---
I use [HWiNFO64](http://www.hwinfo.com/) on my Windows PCs to monitor the various temperature and fan sensors.  I wanted to get this data into [CheckMK](http://mathias-kettner.com/checkmk.html) for monitoring purposes.  Here's how I did it.

First, in HWiNFO, tag any sensors you want to monitor for the Vista gadget.  This causes HWiNFO to populate registry keys with the relevant data.  You'll then need to make a custom plugin for CheckMK in C:\Program Files (x86)\checkmk\plugins named "hwinfo64.cmd", containing the following;



Now, do a test on your CheckMK server, you should see the <<<hwinfo64>>> fields in your agent output for the host.  Great.  Now we need to write a check in CheckMK to interpret that data.  Make a new check 'hwinfo64' in /omd/sites/SITENAME/local/share/check_mk/checks, replacing SITENAME with your OMD site name;



Apologies for the terrible Python, my Python is very weak.  Also note that this assumes that all temperature-type sensors are in Celsius units, and all fan-type sensors are in RPM units.

Once that's done, you should be able to add services to your host and the HWiNFO sensors will be automatically inventoried and show up.  They will use some default thresholds.  In order to customize those thresholds, edit etc/check_mk/main.mk in your OMD site and do something like this;



That will set the warning/crit threshold for CPU temp checks at 70/80 C, and the threshold for GPU checks at 90/100 C, on the machines 'desktop1' and 'desktop2'.  Set as appropriate for your environment.