---
id: 11
title: Adding messages to dmesg
date: 2013-01-02T01:03:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=11
permalink: /2013/01/adding-messages-to-dmesg/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2013/01/adding-messages-to-dmesg.html
categories:
  - Technical
tags:
  - linux
---
The dmesg log on CentOS frequently is missing timestamps.  While it can probably be added, what I wanted to do was add a mark to dmesg every few hours so I'd know how the passage of time went with it.  This can be done with a simple cron job in /etc/cron.d, like this;

<pre>0 */6 * * *    root   /usr/local/sbin/dmesg-mark</pre>

Then make a script in /usr/local/sbin/dmesg-mark like this;

<pre>#!/bin/sh
/bin/date '+----- MARK %Y-%m-%d %H:%M:%S %Z -----' &gt; /dev/kmsg</pre>

The above will output lines like this to dmesg;

<pre>----- MARK 2013-01-02 10:52:01 CST -----</pre>

You'll get one of those in dmesg every six hours with that cron job.  The date format isn't Australian standard (dd/mm/yyyy), it's YYYY-MM-DD.  However, YYYY-MM-DD actually sorts properly.