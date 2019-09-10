---
id: 117
title: 'VMWare &amp; the System Clock'
date: 2007-03-09T05:43:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=117
permalink: /2007/03/vmware-the-system-clock/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2007/03/vmware-system-clock.html
categories:
  - Technical
tags:
  - vmware
---
The system clock behaves ... strangely ... under VMWare in a guest OS. It tends to run slow, and the amount by which it runs slow varies wildly from day to day. Without a fixed time synchronization source, guests will quickly fall out of synchronization and time-critical mechanisms such as Kerberos will break.

This happens because the guest OS assumes that there is a constant period of time between instructions - ie, it has all of the processor's attention. The system clock is a high-precision clock maintained by this fact. When you put a guest OS into a virtual environment this goes out the window - the guest no longer has a consistent period of time between instructions, in general this time is longer than expected. Therefore means that individual ticks of the system clock take longer than the fixed (outside) time periods they should, and the system clock runs slow.

So, how do we stop this? Well, one solution is to use a guest-internal NTP client such as W32Time. <span>This is a very bad idea</span>. NTP clients adjust the system clock by slewing (speeding up or slowing down) the clock progressively so they can converge the system clock with NTP time. Since the system clock is running at an unpredictable rate, slewing the clock is a recipe for disaster - it causes the clock to swing to and fro and never stabilize. An unstable clock can cause very strange things to happen.

We could also just keep setting the time as we need to. <span>This is also a very bad idea.</span> Modern OSes rely on the continuity of time. If you just keep resetting the clock, the system 'loses time', and tasks that were supposed to run in the lost time just don't happen.

The solution is to let VMWare Tools handle the problem, and check the box that lets it synchronize with the host. When you do this, VMWare Tools slews the clock appropriately so it doesn't break anything, and your time converges as you'd expect. When you do this, you must turn off any other kind of time sync software such as W32Time, otherwise they will fight over the clock and much havoc will ensue.

There are certain times when you must run an NTP time server such as W32Time (such as on a domain controller). How you go about preventing W32Time and VMWare Tools fighting is an issue for another post.