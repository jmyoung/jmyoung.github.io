---
id: 34
title: 'APM2 &#8211; PPM Encoder Firmware Update'
date: 2012-06-12T09:55:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=34
permalink: /2012/06/apm2-ppm-encoder-firmware-update/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2012/06/apm2-ppm-encoder-firmware-update.html
categories:
  - Quadcopters
tags:
  - ardupilot
  - quadcopter
---
The [APM2](http://code.google.com/p/arducopter/wiki/APM2board) appears to have a serious (well, I consider it serious, the designers don't appear to) issue.  There's the normal failsafe, where if the throttle channel goes to a certain value (below 960us or so) then the failsafe code can kick in.  That's great.

But if something happens in-flight and there's _absolutely no throttle signal at all_, like say a wire breaks or a connection pulls out, then the PPM encoder on the APM2 by default will just keep sending the same throttle signal it got last through to the APM2 flight processor.

The end result?  Your quad stands a decent chance of just flying away into the wild blue yonder if you have this kind of failure.  Note I say IF.  It's pretty unlikely you will have that happen, and the designers are right that it's up to the user to make sure their hardware is reliable.

That all said, there's a fix!  The latest version of the PPM encoder firmware for the APM2 fixes this issue.  Installation instructions are at this link;

<http://code.google.com/p/arducopter/wiki/APM2Encoder> 

In addition to the resources stated there, you will also need the Arduino Mega 2560 DFU driver.  It's a bloody nuisance extracting that from the Git repository file by file, so you can find a zipped up copy at my GoogleCode repository;

<http://zencoding-blog.googlecode.com/svn/trunk/ardupilot/dfu_driver.zip>

Enjoy.  Tonight I'll be setting up and testing the failsafes to make sure everything's going to work right, and will edit this blog when I have some more info.

Edit:  The PPM encoder update worked fine!  Details in the next post.