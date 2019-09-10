---
id: 654
title: DOTA2 with SLI Graphic Corruption Fix
date: 2013-08-01T07:38:28+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=654
permalink: /2013/08/dota2-with-sli-graphic-corruption-fix/
categories:
  - Gaming
tags:
  - dota2
  - gaming
  - nvsurround
---
I'm using an NVidia GTX690, in 2d surround mode.  The GTX690 is an SLI card, and in 2d surround mode SLI is not optional.  Running [DOTA2](http://www.dota2.com/) on this system (even on just one monitor) causes all sorts of random graphic corruption.

This corruption manifests itself as flickering text, distorted polygons when hovering over menu items, that sort of thing.  Nothing terrible, but it's annoying.  Fortunately, I found a fix!

[This thread](http://dev.dota2.com/showthread.php?t=64832) on the DOTA2 Dev forums worked perfectly for me.  I'll summarize it here in case that thread disappears;

> What I ended up doing was downloading the latest nvidia inspector. I changed my values for a few options. (see below)
> 
> 'Number of GPUs to use on SLI rendering mode' : SLI\_GPU\_COUNT_TWO  
> 'Nvidia predefined number of GPUs to use on SLI rendering mode' : SLI\_PREDEFINED\_GPU\_COUNT\_TWO  
> 'Nvidia Predefined SLI mode' : SLI\_PREDEFINED\_MODE\_FORCE\_AFR2  
> 'SLI rendering mode' : SLI\_RENDERING\_MODE\_FORCE\_AFR2

And a screenshot of my settings in NVidia Inspector follows;

[<img class="aligncenter size-full wp-image-655" alt="NVInspector DOTA2 Configuration" src="https://i0.wp.com/blog.zencoffee.org/wp-content/uploads/2013/08/inspector.png?resize=840%2C175" width="840" height="175" data-recalc-dims="1" />](https://i0.wp.com/blog.zencoffee.org/wp-content/uploads/2013/08/inspector.png)

&nbsp;

The items in grey are unchanged.  Seems to have worked immediately, and performance seems fine.