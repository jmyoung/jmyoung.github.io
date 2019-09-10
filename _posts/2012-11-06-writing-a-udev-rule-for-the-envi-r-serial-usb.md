---
id: 19
title: Writing a UDEV rule for the ENVI-R Serial USB
date: 2012-11-06T04:35:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=19
permalink: /2012/11/writing-a-udev-rule-for-the-envi-r-serial-usb/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2012/11/writing-udev-rule-for-envi-r-serial-usb.html
categories:
  - Technical
tags:
  - envir
  - linux
---
By default the ENVI-R's serial USB adapter will get a device name such as /dev/ttyUSB0, but this may wander if you have multiple serial devices connected.  In order to get a fixed name, create an appropriate .rules file in /etc/udev/rules.d, and enter this;

<pre>SUBSYSTEMS=="usb", ATTRS{idProduct}=="2303", ATTRS{idVendor}=="067b", NAME="%k", SYMLINK+="envir_serial", MODE="0660"</pre>

With this, you'll wind out with a /dev/envir_serial that you can connect your scripts to.  This can be done with any such device, just determine the vendor ID from running lsusb.