---
id: 985
title: 'Netflow Collector on Splunk &#8211; Interesting Bug'
date: 2016-12-07T06:11:01+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=985
permalink: /2016/12/netflow-collector-splunk-interesting-bug/
categories:
  - Computers
  - Technical
tags:
  - splunk
format: aside
---
The [Splunk Add-on for Netflow](https://splunkbase.splunk.com/app/1658/) appears to have a bug.  If you run through the configure.sh script accept all the defaults, it refuses to ingest any Netflow data.

This is because its script deletes all ASCII netflow data that's older than -1 day old.

You can easily fix this by either rerunning configure.sh again and typing in every value, or edit `/opt/splunk/etc/apps/Splunk_TA_flowfix/bin/flowfix.sh` and change the following line;

<pre># Cleanup files older than -1
find /opt/splunk/etc/apps/Splunk_TA_flowfix/nfdump-ascii -type f -mtime <strong><span style="color: #ff0000;">+-1</span></strong> -exec rm -f {} \;</pre>

Change the `+-1` to `+1`.  This tells the script to clean up all ASCII netflow data older than 1 day (ie, not everything older than some time in the future).