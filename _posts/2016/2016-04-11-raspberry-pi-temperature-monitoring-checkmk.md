---
id: 878
title: Raspberry Pi Temperature Monitoring with CheckMK
date: 2016-04-11T11:30:39+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=878
permalink: /2016/04/raspberry-pi-temperature-monitoring-checkmk/
categories:
  - Technical
tags:
  - checkmk
  - linux
  - python
  - raspberrypi
---
The [Raspberry Pi](https://www.raspberrypi.org/) running [Raspian](https://www.raspbian.org/) has some built-in temperature sensors.  The sensor is on the CPU die, and you can find it at;

<pre>/sys/class/thermal/thermal_zone0/temp</pre>

CheckMK supports the idea of [local checks](https://mathias-kettner.de/checkmk_localchecks.html).  A local check is a simple script that runs in the agent on a host and performs whatever check processing and verification that's required on the client end.  This means you cannot customize the warn/crit thresholds from the CheckMK host end.  But they're easy to write.



The above simplistic script reads in the CPU temperature of the RPi, and sets a warn threshold of 90% of the throttling temperature with a critical threshold of 100% of the throttling temperature.

If you add this into;

<pre>/usr/lib/check_mk_agent/local</pre>

On your Raspian install, then manually run check\_mk\_agent, you'll see in the <<<local>>> section the output from the sensor.  You can then edit the host in CheckMK and add the new service that is automatically inventoried.  I assume here that your CPU die never gets below 0 degrees (should be fairly sensible in most circumstances, I imagine).

Easy!