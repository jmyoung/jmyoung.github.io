---
id: 587
title: Triplehead FOV with DCS World 1.2.4
date: 2013-05-04T23:30:39+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=587
permalink: /2013/05/triplehead-fov-with-dcs-world-1-2-4/
categories:
  - Gaming
tags:
  - nvsurround
  - warthog
---
I did some work on getting triple-head going properly in [DCS: World](https://www.digitalcombatsimulator.com/en/world/) 1.2.4 (7680x1440 with three 2560x1440 monitors).  I've tested that everything seems to work fine with the [A-10C Module](http://www.digitalcombatsimulator.com/en/products/warthog/).  Also looks fine with the F-15 (so probably everything in [Flaming Cliffs 3](http://www.digitalcombatsimulator.com/en/products/flaming_cliffs_3/)), and the [Ka-50 Black Shark](http://www.digitalcombatsimulator.com/en/products/black_shark/). The Ka-50 viewpoint is a little buggy and will try and zoom out a LONG way when you enter, so just press * to zoom in until it looks normal.<figure id="attachment_591" aria-describedby="caption-attachment-591" style="width: 1280px" class="wp-caption aligncenter">

[<img class=" wp-image-591 " alt="A-10C Cockpit" src="https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2013/05/Screen_130504_233933.jpg?resize=840%2C158" width="840" height="158" data-recalc-dims="1" />](https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2013/05/Screen_130504_233933.jpg)<figcaption id="caption-attachment-591" class="wp-caption-text">A-10C in DCS World 1.2.4</figcaption></figure> <figure id="attachment_590" aria-describedby="caption-attachment-590" style="width: 1280px" class="wp-caption aligncenter">[<img class=" wp-image-590 " alt="Cockpit of a F-15C" src="https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2013/05/Screen_130504_234153.jpg?resize=840%2C158" width="840" height="158" data-recalc-dims="1" />](https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2013/05/Screen_130504_234153.jpg)<figcaption id="caption-attachment-590" class="wp-caption-text">F-15C in DCS world 1.2.4</figcaption></figure> <figure id="attachment_594" aria-describedby="caption-attachment-594" style="width: 1280px" class="wp-caption aligncenter">[<img class=" wp-image-594" alt="Ka-50 Cockpit in DCS World 1.4.2" src="https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2013/05/Screen_130505_160633.jpg?resize=840%2C158" width="840" height="158" data-recalc-dims="1" />](https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2013/05/Screen_130505_160633.jpg)<figcaption id="caption-attachment-594" class="wp-caption-text">Ka-50 in DCS World 1.2.4</figcaption></figure> 

In order to set up, you'll need to do the following;

  * <span style="line-height: 1.714285714; font-size: 1rem;">Apply the diff file from </span><a style="line-height: 1.714285714; font-size: 1rem;" href="https://code.google.com/p/zencoding-blog/source/browse/trunk/flightsims/dcsworld/1.2.4-to-triplehead.patch">here</a> <span style="line-height: 1.714285714; font-size: 1rem;">to your DCS World setup.  It'll go and change a couple of files in minor ways.  You can also get a ZIP of these files already changed suitable for DCS World 1.2.4.12913.167 from this link:  <a href="http://blog.zencoffee.org/wp-content/uploads/2013/05/TripleheadFOV-1.2.4.12913.zip">TripleheadFOV-1.2.4.12913.zip</a><br /> </span>
  * Copy autoexec.cfg from [here](https://code.google.com/p/zencoding-blog/source/browse/trunk/flightsims/dcsworld/autoexec.cfg) into your `C:\Users\<username>\Saved Games\DCS\Config` folder.
  * Copy SnapViews.lua from [here](https://code.google.com/p/zencoding-blog/source/browse/trunk/flightsims/dcsworld/SnapViews.lua) into your `C:\Users\<username>\Saved Games\DCS\Config` folder.

<span style="line-height: 1.714285714; font-size: 1rem;">The diff allows use of customized snap views, and sets the default external viewing angle to 120 degrees (maths as to why this is right can be found at </span><a style="line-height: 1.714285714; font-size: 1rem;" title="FOV Adjustments for TripleHead Setups" href="http://blog.zencoffee.org/2012/08/fov-adjustments-for-triplehead-setups/">this link</a><span style="line-height: 1.714285714; font-size: 1rem;">).  It also hardcodes the screen width for some UI elements to 2560x1440, and pushes the radio chatter windows across one screen so that they render on the middle screen and not on the right.  And lastly, it modifies Server.lua to allow the widened FOV for the Ka-50.</span>

The autoexec.cfg sets the maximum fps to 60, to avoid issues that tend to happen with microstutters on SLI.  The SnapViews.lua contains recalculated viewing angles for all default snap views such that they are corrected for triple-head FOV, as per my [prior post](http://blog.zencoffee.org/2012/08/fov-adjustments-for-triplehead-setups/ "FOV Adjustments for TripleHead Setups") on the topic.

Enjoy.