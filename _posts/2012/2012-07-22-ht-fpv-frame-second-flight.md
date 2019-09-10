---
id: 27
title: 'HT-FPV Frame &#8211; Second Flight!'
date: 2012-07-22T11:02:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=27
permalink: /2012/07/ht-fpv-frame-second-flight/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2012/07/ht-fpv-frame-second-flight.html
categories:
  - Quadcopters
tags:
  - ardupilot
  - htfpv
  - quadcopter
---
Got to take the HT-FPV out to the park today, finally there wasn't any rain to put a stop to proceedings.  This is the first full-range test I got to do.

First, range checks.  The TM1000 seems to be very short range (20 meters or so!), which may be on account of where I've put the antenna.  I'll have to work on that.  On the other hand, range testing with the AR8000 showed control still working at 300 meters (30 meters on reduced power).  I'll do more testing on that later, but it's within spec for that I need at the moment.  I've currently got the failsafe configured to just cut power - I'll have to mess with trying autoland at some stage.

Second, hover checks.  Hover was fine, altitude hold held altitude great, even with quite large attitude shifts when maneuvering around.  There seems to be some yaw drift, which may be either magnetic interference or insufficient P (the drift isn't always the same direction).

Lastly, loiter testing.  To start with, I left the quad in altitude hold at about 1 meter, then kicked in loiter.  The quad immediately started heading off to the west.  Since I have limited room, I didn't let it get too far before kicking back out of loiter and bringing it back.  Tried it again, and this time it went great - it loitered around for a good minute or two within about a 5 meter radius area.

My theory here is that I probably didn't have a good GPS fix (I waited for the 3dfix light).  If I had more room and I just let it go, it probably would have loitered at some other point nearby, but with my limited space I didn't want to let it go.

Still some vibrations which indicate that tuning is still required, but other than that, a good result.