---
id: 13
title: IPMI and CentOS with the N36L
date: 2012-12-24T11:26:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=13
permalink: /2012/12/ipmi-and-centos-with-the-n36l/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2012/12/ipmi-and-centos-with-n36l.html
categories:
  - Technical
tags:
  - linux
  - nagios
---
Over this weekend I've been setting up [Nagios](http://www.nagios.org/) on my Microserver.  Specifically, I want to have alerting when/if the Microserver reaches critical conditions such as RAID device failure, over temperature, on UPS, stuff like that.

For monitoring temperatures and fan speed, I want to use IPMI since I have the Remote Access Card fitted.  However, IPMI doesn't 'just work' out of the box.  This post will explain how to make it work.

<pre>echo modprobe ipmi_devintf &gt;&gt;/etc/sysconfig/modules/ipmi.modules
 echo modprobe ipmi_si&gt;&gt;/etc/sysconfig/modules/ipmi.modules
 echo options ipmi_si type=kcs ports=0xca2 &gt;&gt; /etc/modprobe.d/ipmi_si.conf
 yum install -y freeipmi
 modprobe ipmi_devintf
 modprobe ipmi_si
 ipmi-sensors</pre>

Assuming that all worked, you should see the output of your Microserver's IPMI data, which should look something like this;

<pre>7936: Watchdog (Watchdog 2): [OK]
 22599: CPU_THEMAL (Temperature): 42.00 C (NA/110.00): [OK]
 22619: NB_THERMAL (Temperature): 41.00 C (NA/105.00): [OK]
 22593: SEL Rate (Other Fru): 6.00 msgs (NA/90.00): [OK]
 22620: AMBIENT_THERMAL (Temperature): 27.00 C (NA/45.00): [OK]
 22617: EvtLogDisabled (Event Logging Disabled): [OK]
 22618: System Event (System Event): [OK]
 22608: SYS_FAN (Fan): 1100.00 RPM (0.00/NA): [OK]
 22621: CPU Thermtrip (Processor): [OK]
 1536: Sys Pwr Monitor (Power Unit): [OK]</pre>

<div>
</div>

Note the typo in CPU\_THEMAL.  Good one, HP.  NB\_THERMAL is the northbridge temperature, which should be pretty similar to the CPU temperature on this motherboard.  AMBIENT\_THERMAL shows temperature inside the case, and SYS\_FAN shows the fan speed.  The critical thresholds are listed.

Now, if you're using Nagios, you will now want the [Nagios IPMI Monitoring Plugin](http://exchange.nagios.org/directory/Plugins/Hardware/Server-Hardware/IPMI-Sensor-Monitoring-Plugin/details).  Get this, and also install perl-IPC-Run .  Run the check as root with sudo, and you're sorted.  Better explanation of that when I get around to writing more about Nagios.

Oh, and if you're using SElinux, be prepared to battle with it to make it work properly with Nagios plugins requiring root...