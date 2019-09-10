---
id: 9
title: Quota Usage Checking with Nagios
date: 2013-01-11T00:38:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=9
permalink: /2013/01/quota-usage-checking-with-nagios/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2013/01/quota-usage-checking-with-nagios.html
categories:
  - Technical
tags:
  - linux
  - nagios
---
My ISP ([Adam Internet](http://www.adam.com.au/)) supplies an XML usage page, which uses Basic authentication.  You sign up on their admin page for a token, and you then use those credentials (username:token) as the creds when fetching the usage page, and you get back a whole bunch of XML.  There's various smartphone tools to use that data.  What I wanted was a [Nagios](http://www.nagios.org/) check, and also for perfdata to go into [pnp4nagios](http://docs.pnp4nagios.org/pnp-0.6/start) from that based on my Internet usage.

At [this link](http://code.google.com/p/zencoding-blog/source/browse/trunk/scripting/nagios/check_adam) you can find a script I wrote which does all of this.  You'll need to install the LWP and XML::XPath modules to Perl, which you can do in CentOS with;

<pre>yum install perl-XML-XPath</pre>

LWP should be installed by default.  Usage is quite simple, just call it like this;

<pre>check_adam -u username:token -w 90 -c 95</pre>

to set warning threshold at 90% and critical threshold at 95%.  The script works by fetching the XML usage data, parsing it using XPath, and pulling out various bits of info.  It then generates a status line for Nagios similar to the following;

<pre>OK: 10 of 100 GiB (10%). 0.5 GiB today. Day 24.</pre>

Showing you absolute usage, quota, percentage usage, amount used today, and how far you are into your billing cycle.  Threshold is based on the percentage listed there. At some stage I'll put in some cleverness around alerting if you're going to run out of quota at your current usage, or something similar.

Perfdata returned is quite extensive - quota, usage overall, usage today, days into cycle, SNR (both directions), Sync speed (both directions), attenuation (both directions).

Enjoy.