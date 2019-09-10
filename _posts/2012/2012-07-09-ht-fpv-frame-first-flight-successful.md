---
id: 28
title: 'HT-FPV Frame &#8211; First flight successful!'
date: 2012-07-09T02:14:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=28
permalink: /2012/07/ht-fpv-frame-first-flight-successful/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2012/07/ht-fpv-frame-first-flight-successful.html
categories:
  - Quadcopters
tags:
  - ardupilot
  - htfpv
  - quadcopter
---
Had the first flight of my HT-FPV based quad on Saturday.  No tuning, just went with factory default PIDs.  I installed the sonar under the frame - potentially too close to the power distribution, but it appears to be OK.

First flight was fine!  Takes off evenly, stabilization is good, altitude hold works great.  It wobbles a bit, so obviously the PIDs need adjusting somewhat.  Voltage telemetry on the Dx8 works well, and the LiPo alarm goes off at 10v.

The current monitor on the Attopilot doesn't seem to register in the Planner, but that appears to be a noted bug in ArduCopter 2.6 .  The hardware definitely works since I note a voltage on the current pin that varies as the current draw varies.  Hope it gets fixed soon.

The battery didn't seem to last very long, although I'm wondering how much of that is me losing track of time.

Next up is to get it all tuned up and to test loiter mode and auto-land for failsafe.  That'll probably have to wait for the weekend, it's dark by the time I get home from work.