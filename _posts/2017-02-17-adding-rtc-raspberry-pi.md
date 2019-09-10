---
id: 1002
title: Adding an RTC to your Raspberry Pi
date: 2017-02-17T14:22:58+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=1002
permalink: /2017/02/adding-rtc-raspberry-pi/
categories:
  - Technical
tags:
  - linux
  - raspberrypi
---
I use a RPi 3 as a secondary DNS and DHCP server, and time synchronization is important for that.  Due to some technicalities with how my network is set up, this means that I need a real-time clock on the RPi so that it can have at least some idea of the correct time when it powers up instead of being absolutely dependant on NTP for that.

Enter the DS3231 RTC (available on eBay for a few bucks).  The Pi Hut has an [excellent tutorial](https://thepihut.com/blogs/raspberry-pi-tutorials/17209332-adding-a-real-time-clock-to-your-raspberry-pi) on setting this up for a RPi, which I'm going to summarize here.

# Configure I2C on the RPi

From a root shell (I'm assuming you're using Raspbian like me);

<pre>apt-get install python-smbus
 apt-get install i2c-tools</pre>

Then, edit your `/boot/config.txt` and add the following down the bottom;

<pre>dtparam=i2c_arm=on
dtoverlay=i2c-rtc,ds3231</pre>

Edit your /etc/modules and add the following line;

<pre>i2c-dev</pre>

Now reboot.  If you do an `i2cdetect -y 1` you should see the DS3231 listed as device 0x68.  If you do, great.

# Configure Raspbian to use the RTC

After rebooting, the new device should be up, but you won't be using it yet.  Remove the fake hardware clock with;

<pre>apt-get --purge remove fake-hwclock</pre>

Now you should be able do `hwclock -r` to read the clock, and then `hwclock-w` to write the current time to it.

And lastly, to make it pull time from the RTC on boot, put the following into `/etc/rc.local` before the `exit 0`;

<pre>hwclock -s</pre>

And you can then add a cronjob in `/etc/cron.weekly` to run `hwclock -w` once a week.

Done!