---
id: 51
title: Damn you, SElinux!
date: 2012-02-26T01:30:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=51
permalink: /2012/02/damn-you-selinux/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2012/02/damn-you-selinux.html
categories:
  - Technical
tags:
  - linux
---
SElinux is a major security feature in CentOS (and Red Hat).  By default it's in Enforcing mode, which means it enforces all sorts of security restrictions on what processes are allowed to do.  On my Microserver, I've intentionally been running in Enforcing mode so that I can get used to dealing with it, as well as for increased security.

Anyway, my MRTG configuration used to work just fine with CentOS, then when I did an update one day (I think when it went to CentOS 6.1), some parts of my MRTG config broke.  Specifically, the parts that ran scripts which executed commands like 'curl', 'ping' and so on.  The scripts that fetched data from my Mosquitto instance worked just fine.

This was pretty weird, so I left it alone since I didn't hugely need those counters anyway.  Pushing ahead to now, I decided to really have a look at why it wasn't working.  Eventually I worked out that it looks like MRTG has been added to the targeted SElinux setup, and this is what broke it!

To check that, if you have an application that just can't do certain things, doing a "<span>setenforce 0</span>" will temporarily switch SElinux over to Permissive mode.  If the application suddenly starts working, you've got an SElinux problem.  In this case, MRTG needed extra permissions that it doesn't have.

To find out what I needed, I did the following;



  1. Add '<span>audit=1</span>' to the kernel options in <span>/boot/grub/grub.conf</span> and then reboot.  This causes some pretty verbose logging from SElinux to happen, which is what we want.
  2. Do a '<span>setenforce 0</span>' to switch to Permissive mode.
  3. '<span>tail /var/log/audit/audit.log</span>' and look for the timestamp for the setenforce message.  Record it (we'll call it TIMESTAMP from here)
  4. Wait for your MRTG to try and do its thing. Wait until it's completely finished.
  5. '<span>grep -A 1000 TIMESTAMP /var/log/audit/audit.log > ~/audit.output</span>' .  This will drop out all the SElinux log messages since you changed to Permissive mode.
  6. Read the audit.output file.  Remove any lines that are obviously not related to MRTG.  In my case, there was a heap of stuff about <span>df</span>, <span>ping</span>, and <span>curl</span>.  These are all parts of the scripts that MRTG runs.
  7. Use audit2allow to generate a custom SElinux module with '<span>cat ~/audit.output | audit2allow -M mrtg_local</span>'
  8. Read <span>mrtg_local.te</span> and make sure that it's sane  It should only be talking about stuff that's MRTG related.
  9. Insert the module into SElinux with '<span>semodule -i mrtg_local.pp</span>' .
 10. Look at your <span>audit.log</span> and get the timestamp from when the new module was inserted.
 11. Wait for MRTG to run again.  This time you should see nothing appear in the audit log.  If you did, you'll need to strip out the existing module with '<span>semodule -r mrtg_local</span>' and start again.
 12. Change SElinux to Enforcing mode with '<span>setenforce 1</span>'.  Wait for MRTG to run and this time it should work AND you should see nothing in the audit log.  If it still doesn't work, start again.
 13. Remove <span>audit=1</span> from grub.conf and reboot

<div>
  So there we have it.  The above generated a custom SElinux module that fits my MRTG configuration and got it all working.  Now I have all my graphs again.
</div>

<div>
</div>

<div>
  It's a good security feature, but it does tend to make programs break in weird and wonderful ways when it blocks access.
</div>