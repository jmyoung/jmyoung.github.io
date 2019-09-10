---
id: 62
title: 'HP Microserver &#8211; Suppressing Excess Logging'
date: 2011-10-14T05:36:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=62
permalink: /2011/10/hp-microserver-suppressing-excess-logging/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/10/hp-microserver-suppressing-excess.html
categories:
  - Technical
tags:
  - linux
---
Just got around to doing this.  There's a lot of logging that goes on by default on a Linux box, and every log message that gets committed to disk shortens the life of the USB key you're driving your Microserver with.  As such, suppressing spurious logging is fairly important.

One of the most regular loggers is cron.  Every time cron runs it will write several log messages to /var/log/syslog and to /var/log/auth.log .  To suppress this entirely, create a new file /etc/rsyslog.d/02-suppress-cron.conf and put in this text;

> cron.*  ~  
> :msg,contains,"pam_unix(cron:session)" ~

This will tell rsyslog to suppress all cron messages, and also suppress any other messages which would normally go to auth.log about cron.