---
id: 858
title: Ubuntu VM AutoResize with 15.10
date: 2016-03-21T11:11:26+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=858
permalink: /2016/03/ubuntu-vm-autoresize-15-10/
categories:
  - Computers
  - Technical
tags:
  - linux
  - vmware
format: aside
---
Installed Ubuntu in a VMware Workstation 12 VM, and can't get desktop autosize working with open-vm-tools?  Here's how to fix it.

Make sure you have the open-vm-tools-desktop package installed;

<pre>sudo apt-get install open-vm-tools-desktop</pre>

Edit /etc/xdg/autostart/vmware-user.desktop and add the following line at the bottom;

<pre>X-Gnome-autostart-enabled=1</pre>

Restart, and then make sure that under the View tab you have Autofit Guest enabled.  Should do the trick.