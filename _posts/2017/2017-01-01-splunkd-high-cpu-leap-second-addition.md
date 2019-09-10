---
id: 992
title: Splunkd High CPU after leap second addition?
date: 2017-01-01T11:17:26+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=992
permalink: /2017/01/splunkd-high-cpu-leap-second-addition/
categories:
  - Technical
tags:
  - linux
  - splunk
---
Had my alerting system yell at me about high CPU load on my [Splunk Free](http://docs.splunk.com/Documentation/Splunk/6.5.1/Admin/MoreaboutSplunkFree) VM;

[<img class="aligncenter wp-image-994 size-full" src="https://i0.wp.com/blog.zencoffee.org/wp-content/uploads/2017/01/splunkcpu.jpg?resize=819%2C340&#038;ssl=1" width="819" height="340" srcset="https://i0.wp.com/blog.zencoffee.org/wp-content/uploads/2017/01/splunkcpu.jpg?w=819&ssl=1 819w, https://i0.wp.com/blog.zencoffee.org/wp-content/uploads/2017/01/splunkcpu.jpg?resize=300%2C125&ssl=1 300w, https://i0.wp.com/blog.zencoffee.org/wp-content/uploads/2017/01/splunkcpu.jpg?resize=768%2C319&ssl=1 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" data-recalc-dims="1" />](https://i0.wp.com/blog.zencoffee.org/wp-content/uploads/2017/01/splunkcpu.jpg?ssl=1)

A bit of examination revealed that it was indeed at abnormally high load average (around 10), although there didn't appear to be anything wrong.  Then a quick look at `dmesg` dropped the penny;

<pre>Jan 1 10:29:59 splunk kernel: Clock: inserting leap second 23:59:60 UTC</pre>

Err.  The high CPU load average started at 10:30am, right when the leap second was added.

A restart of all the services resolved the issue.  Load average is back down to its normal levels.