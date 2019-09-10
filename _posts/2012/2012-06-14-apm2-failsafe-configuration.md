---
id: 33
title: APM2 Failsafe Configuration
date: 2012-06-14T10:42:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=33
permalink: /2012/06/apm2-failsafe-configuration/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2012/06/apm2-failsafe-configuration.html
categories:
  - Quadcopters
tags:
  - ardupilot
  - quadcopter
---
As discussed in my [last post](http://coding.zencoffee.org/2012/06/apm2-ppm-encoder-firmware-update.html), I installed a new APM2 PPM encoder firmware and intended to set up the failsafes on my APM2 and my Spektrum Dx8 transmitter.

Following the excellent guide you can find at DIY Drones ([link here](http://diydrones.com/profiles/blogs/spektrum-dx8-and-ar8000-failsafe-setup)), I configured my Dx8 / AR8000 in exactly the same way.

Anyway - everything works, exactly as desired!  When I turn off the radio (ie, the AR8000 failsafe triggers) the PWM signal to the APM2 drops to ~ 911us, which is short enough to trip the failsafe.  When I pull the throttle line out of the APM2 (simulating a cable failure, which is what the new PPM encoder firmware protects against), the PWM throttle signal drops to ~900us, which is also low enough to trip the failsafe.

Thinking about it, there's other failure modes possible - namely that you might lose other lines besides the throttle line.  I guess the solution there would be to either flip your mode switch to RTL, or simply turn off your radio thus triggering the normal failsafe and an appropriate response.