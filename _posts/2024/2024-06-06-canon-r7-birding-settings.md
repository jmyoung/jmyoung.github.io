---
title: 'Canon R7 Birding Settings'
author: James Young
layout: post
categories:
  - photography
tags:
  - birding
---

I do some bird photography, using a Sigma 150-600C Contemporary lens with my Canon R7.  There's a few issues with the Sigma and the R7 - focus pulses in and out, however it can be dealt with by some adjustments.  It's not perfect, but it does perform much better.

The exact model and firmware version I have is Sigma 150-600mm F5-6.3 DG OS HSM C015, version 2.03.  Canon R7 is firmware version 1.3.1 at the time of writing.  I am also using the Canon EF-RF Adapter with Control Ring (although I don't use the ring much).

Sigma Lens Settings
===================

First you'll need to get the USB-based Sigma Dock, and use that on the lens.  Since I have my birding setup on C2 on my camera, I configured C2 on the lens using Customization Mode as follows;

| Setting | Value |
| --- | --- |
| AF Speed Setting | Standard AF Priority |
| Focus Limiter Setting | Not Customized |
| OS Setting | Moderate View Mode |

I have also customized C1 to be even more conservative, with the same settings as C2 but Smooth AF Priority.  I also shoot in OS Mode 1 under most circumstances - something I should test further, whether I get better hit rate in C2 for panning shots, or even with OS off entirely when shooting at 1/1000s and higher.

The intention here is to provide a couple of modes on the switch to help deal with the AF pulsing;

* OFF - Standard AF Priority, Standard View Mode.  The factory default settings.
* C1 - Very conservative, smooth AF & moderate view.
* C2 - Conservative, standard AF & moderate view.

Moderate View Mode turns off OS while in the EVF, and enables it when taking the shot.  This tends to produce better results with the R7, but it does result in a shaky viewfinder when composing.  Holding technique becomes important.

Canon R7 Settings
=================

I shoot in custom mode C2, and have Auto Update Settings DISABLED.  That way the camera reverts back to the custom mode's defaults after about a minute or when modes are changed or power cycled.

Shooting Mode and Basics
------------------------

Shooting is done in Fv mode.  This provides the ability to change parameters from the wheel on the back and the dial.  I leave the Fv active wheel on shutter speed, because that's the component I need to change the most.  Other settings are;

| Setting | Value |
| --- | --- |
| Shutter Speed | 1/1000
| Shutter Mode | Electronic First Curtain
| Aperture | f/7.1
| ISO | Automatic
| Auto ISO Range | 100-12800
| Metering | Evaluative
| Exposure Compensation | +1/3 
| White Balance | AWB
| Fire Rate | HS Continuous+
| Image Mode | CRAW
| Focus Mode | AI Servo
| Focus Zone | Zone 1
| AF Subject | Animals
| Eye Detect AF | ON

Some commentary on settings choices.  Most birds that I shoot are darker colored than the surroundings, hence the +ve exposure compensation.  With modern denoise software, high ISO is no longer something to fear, and I'd rather get a properly exposed high-ISO shot than an underexposed one.  I fix the aperture at f/7.1 because that produces good sharp results across the whole focal range on the Sigma lens, but in bright conditions I'll bring it down to f/8 for extra.  As a result, under most situations I'm only really adjusting the shutter speed, with 1/1000 being the middle ground, going up or down as required.

EFCS is the shutter mode that should be used by default - it doesn't suffer badly from shutter shock like pure mechanical does, and doesn't suffer from rolling shutter like electronic does.  You do need mechanical for the best bokeh at high shutter speeds, and also for flash, but neither really matter here.

Autofocus Settings
------------------

Besides the configuration above which is mostly just done on the Q-set menu on the back LCD, there's also some AF optimization that should be done.

| Setting | Value |
| --- | --- |
| Page 1 / Switching Tracked Subjects | 0
| Page 2 / Selected Case | Case 1 
| Page 2 / Case 1 / Tracking | -1
| Page 2 / Case 1 / Accel | -1
| Page 2 / Case 2 / Tracking | -1
| Page 2 / Case 2 / Accel | -2
| Page 4 / Limit AF Areas | Spot,1,3,All

I've mostly done my shooting on Case 2, Tracking -2, Acceleration -2, but after some recommendations I'm currently going to be trying Case 1, -1/-1 and see how that goes.  The cases and tracking/acceleration settings make a huge difference to the R7's stickiness with AF on birds, so it's vital to see what you can do with these settings.

Button and Dial Configuration
-----------------------------

The next piece is the buttons.  Button config is set up this way to provide easy access to various AF focus modes and to also quickly turn features on and off.  Button layout is like this (I've only included changes from factory default);

| Button | Value |
| --- | --- |
| Shutter Half-Press | Metering Start
| AF-ON | Metering and AF Start
| Asterisk | Recall - AF Spot, Subject Track ON, Subject Detect OFF, Eye Detect OFF, AF ON
| Magnify | Direct AF Area Selection
| D-Pad Left | Silent Shutter
| D-Pad Right | Eye Detect Toggle
| D-Pad Up | One-Shot AF/Servo-AF Toggle
| D-Pad Down | Switch Focus/Control Ring
| Joystick | Move focus point
| Joystick Press | Reset focus point to center
| Control Ring | Exposure Compensation

The configuration here gives dual back-button focus, with the ability to quickly change focus point, and also ability to quickly disable eye detect AF if it's causing issues.

The silent shutter toggle on D-Pad Right is to quickly switch into Electronic shutter mode, if you need it for a subject you don't want to startle.  Pressing it again will revert back to EFCS.

The Elephant in the Room - Autofocus Hunting
============================================

The hard word on the Sigma 150-600C + R7 combo is, you'll never completely eliminate the focus hunting issue.  The combination just isn't perfect, and that's it.  But you can still get pretty stellar results for the money anyway - see this [Rainbow Lorikeet](https://www.flickr.com/photos/195869142@N03/53173980782/) photo I got with that combo.

You can also improve hit rate by dropping the fire rate from HS+ to a lower rate - this provides more time between shots for the AF to operate and it doesnt "lose" lock as easily.

I've written all the above because I own the combination, and I simply can't afford the other great options in that range (the RF 100-500 or the new RF 200-800).  So I have to just wear the miss rate, and that's it.
