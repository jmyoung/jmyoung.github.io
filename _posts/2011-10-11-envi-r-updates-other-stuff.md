---
id: 63
title: ENVI-R Updates, Other Stuff
date: 2011-10-11T23:42:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=63
permalink: /2011/10/envi-r-updates-other-stuff/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/10/envi-r-updates-other-stuff.html
categories:
  - Technical
tags:
  - envir
  - linux
---
Whew, been a while.  I've been a bit slack with keeping up with my projects lately - too busy with other things.  However, I have a few updates.

I got a solar panel installation done last week, and as such I got a second transmitter for my ENVI-R power monitor.  I discovered a problem with the moving average code in my ENVI-R scripts, so I've corrected that and updated the GoogleCode repository.  It will now handle multiple transmitters without problems.

I've also gone and made button extensions for the three pushbuttons on the Arduinoven's front panel.  Manufacture was simple - I used a piece of aquarium-grade rubber tubing, which pushed over the button's shaft, and then a piece of aluminium rod which went in the tube and was rounded on the end.  Buttons hold well enough, and they won't fall out.  Now to drill the holes in the front for them, and then cut out a space for the LCD with a coping saw.

In other news, the Microserver is going quite well now that I've rebuilt it onto another USB key.  I'm now using tmpfs for both the MRTG data and /tmp.  Doing so appears to have resolved the minor issues I used to have, where I/O would pause for up to 10 seconds at random intervals.  My thoughts here is that when MRTG was doing its five-minutely update, it was queueing up a lot of I/O to the USB key, which prevented any other I/O while it was in progress, causing the pause.  Now it runs against tmpfs I'm no longer getting that problem.

I've got some ideas for a battery-powered temperature sensor powered by an ATtiny, which would send out temperature data via radio once a minute or so.  More on that when it happens.