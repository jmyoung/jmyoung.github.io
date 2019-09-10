---
id: 70
title: 'AeroQuad &#8211; Light, Barometers and Throttle Adjust'
date: 2011-07-30T23:54:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=70
permalink: /2011/07/aeroquad-light-barometers-and-throttle-adjust/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/07/aeroquad-light-barometers-and-throttle.html
categories:
  - Quadcopters
tags:
  - aeroquad
  - quadcopter
---
Had a bright and sunny day yesterday, and I got the chance to test out a theory I've seen discussed on the AeroQuad forums - namely that sunlight affects the BMP085 barometer.  The sun was bright and warm, but the air was cool.

Took the quad out to the park and flew it around.  Altitude hold was crazy again - big random swings up and down, unpredictable behaviour.  So I flew it over into a spot where there was a lot of shade, and the altitude hold went sensible pretty much straight away.  Unfortunately, it then drifted over into a spot where it was in full sun and went crazy and crashed reasonably hard 🙁

During the repairs, I folded over a loop of cardboard (blacked on the inside), and attached it to the BMP085 so that it's sitting in shade all the time.  At the next flight, it flew awesomely - I kept it up for a whole battery pack.  Admittedly I flicked altitude hold off a couple of times, but it was holding very well compared to how it has been.  So, it looks like keeping the BMP085 in the dark is the go.  I also moved the altitude sampling code to a 33Hz task loop, since sampling it at 50Hz is too fast for the BMP085.  That seems to have helped a lot too.

Lastly, this was also a good opportunity to test my throttle adjustment code doing some maneuvering.  What I've done is modify the AeroQuad code so that it increases the throttle in proportion for the difference in battery voltage between now and when it took off.  That way the altitude hold (and acrobatic for that matter) modes should not need to keep pushing up the throttle all the time to account for the battery running out.

So far, that code seems to work reasonably well.  I had to apply some corrections to throttle, but nowhere near as much as I've had to do in the past, and when transitioning out of altitude hold back to acrobatic, the throttle was "nearly right" for hovering, instead of being way too low like it usually is.

A patch for the 2.4.2 release is available [here](http://code.google.com/p/zencoding-blog/source/browse/trunk/aeroquad/battadjust-2.4.2.patch).