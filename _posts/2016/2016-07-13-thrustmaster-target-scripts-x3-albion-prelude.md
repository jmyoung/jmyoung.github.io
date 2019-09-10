---
id: 922
title: 'Thrustmaster TARGET Scripts for X3: Albion Prelude'
date: 2016-07-13T11:46:10+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=922
permalink: /2016/07/thrustmaster-target-scripts-x3-albion-prelude/
categories:
  - Gaming
tags:
  - gaming
---
I've been messing about with getting back into X3 in the past few days, specifically with [Albion Prelude](http://store.steampowered.com/app/201310/).  I spent ages with Terran Conflict, back in the day.

I'm using a [Thrustmaster Warthog](http://www.thrustmaster.com/products/hotas-warthog) (hue hue, thrust master!) throttle and stick, with Saitek pedals.  This manifests itself as three separate USB devices.  X3 has an interesting defect where it can only utilize one USB device as a controller (whoops).  [Thrustmaster TARGET](http://www.thrustmaster.com/products/target) Script Editor to the rescue!



The above script has lines for every button and axis on the Warthog, and comments.  It's currently customized for how I want to use the Warthog with X3:AP, and doesn't have every binding in it yet I want, just the real basics.

Since I can't (yet!) use pedals with it, I've bound roll to the "friction" axis on the Warthog (the lever on the right side of the throttle).

There's some magic that happens with the throttle.  I've configured it to be forward-only throttle, so that the full range only drives your ship in the forwards direction with no reverse.  If you find your ship doesn't come to a complete stop when it's the whole way back, pull the speedbrake switch back and it'll stop.  You can also pull the boat switch back to reverse.

To make some sense of how the bindings work, binding something to 0 disables it.  The list of keybindings you can find by looking at defines.tmh in your TARGET install folder, in the definition for ASCE.

When I work out how to do more advanced stuff like mode switching, I'll include that.