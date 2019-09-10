---
id: 116
title: Fixing W32Time in a Guest OS
date: 2007-03-09T07:27:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=116
permalink: /2007/03/fixing-w32time-in-a-guest-os/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2007/03/fixing-w32time-in-guest-os.html
categories:
  - Technical
tags:
  - vmware
---
<span>NOTE: For informative purposes only. I take no responsibility at all for any harm that may result to your environment as a consequence of this information. Use at your own risk, and research appropriately!</span>

Sometimes you must run W32Time on a guest OS, but it's not a good idea to run it at the same time as using VMWare Tools time synchronization. A good example of this is a domain controller - it must have W32Time running, must have accurate time, and must supply time to member servers.

First, a note. Don't just go and point your PDC at some dummy NTP source that doesn't exist. If you do that, after some period W32Time will just shut down and stop serving time. Instead, we need to find a way to get W32Time and VMWare Tools to co-exist peacefully.

The solution is to set W32Time so it only tries to slew the clock very occasionally, so the adjustments made by VMWare Tools dominate the clock and keep it in sync. Since W32Time is still in contact with a valid time source, it doesn't commit seppuku.

You can do this by changing this registry key to "Weekly". Data type is REG_SZ, if you need to create it;

<span></span>

> <span><span>HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters\Period</span></span>

Restart the W32Time service when you do that, and then all should be well. Oh yeah, and after giving it a little while to settle down, don't forget to check your event viewer, and do a;

<span></span>

> <span><span>w32tm /stripchart /computer:ANOTHER_DC</span></span>

to check that your machine is still in sync with the rest of your domain.