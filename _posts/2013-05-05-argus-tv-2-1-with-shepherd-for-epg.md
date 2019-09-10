---
id: 596
title: ARGUS-TV 2.1 with Shepherd for EPG
date: 2013-05-05T20:49:49+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=596
permalink: /2013/05/argus-tv-2-1-with-shepherd-for-epg/
categories:
  - Computers
tags:
  - htpc
  - mediaportal
---
If you're having trouble with the new ARGUS TV plugin messing up your EPG by it being off by an amount equal to your timezone, this can be corrected by running the following;

<pre><span style="line-height: 1.714285714; font-size: 1rem;">tv_grab_au --component-set augment_timezone:timeoffset=Auto</span></pre>

Once that's run, when you go to fetch your EPG, do this instead;

<pre>env TZ="Australia/Adelaide" tv_grab_au</pre>

Assuming you're in Adelaide, of course.  Substitute with whatever timezone is appropriate.  That forces Shepherd to embed your timezone into the XML timestamps, which makes ARGUS work properly again.  Otherwise Shepherd uses local time for its timestamps, whereas because no timezone is specified ARGUS assumes they're in UTC, causing everything to be off by your timezone offset.