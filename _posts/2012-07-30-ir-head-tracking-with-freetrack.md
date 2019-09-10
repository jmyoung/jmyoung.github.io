---
id: 26
title: IR Head Tracking with FreeTrack
date: 2012-07-30T05:18:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=26
permalink: /2012/07/ir-head-tracking-with-freetrack/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2012/07/ir-head-tracking-with-freetrack.html
categories:
  - Gaming
tags:
  - gaming
  - peripherals
  - warthog
---
I've recently been learning to fly in [DCS: A-10c Warthog](http://www.digitalcombatsimulator.com/en/series/warthog/), deciding to stick to just one flight sim until I get good at it.  What I've been interested in is whether a head tracking system would be useful, and whether I'd like it.  The [TrackIR 5](http://www.naturalpoint.com/trackir/) head tracking system runs about $200, which is a bit costly for an experiment - particularly if I didn't like it.

First, some background.  A head tracker is a system which monitors your head for movement, and then can be used to shift the point of view in a simulator appropriately.  Some work from facial recognition, but most work by having either infrared reflectors or emitters in fixed positions on a harness on the user's head, which are then monitored by a camera.  The TrackIR is one such system, and has high compatibility with many simulators and is quite popular.  But it's expensive.

Enter [FreeTrack](http://www.free-track.net/english/).  FreeTrack is a free system which uses (slightly modified) Webcams and a head harness made with some infrared LEDs to implement a head tracking system.  I decided to make myself up a really cheap FreeTrack setup to see whether I liked it at all.  Total cost?  About $20.

**<span>The Hardware</span>**

I went down to my local games shop, and was lucky enough to pick up an old-style Playstation 3 Eye for $9 (!!!).  The PS3Eye is ideal for this sort of thing since it can be easily disassembled and turned into an IR camera and can do decent resolution and framerate (320x240 @ 120fps).  I ripped out the IR filter lens inside the camera (wrecking the filter in the process), and replaced it with a piece of cut-out developed photographic negative.  The black part of a photographic negative is quite opaque to visible light, but nearly transparent to infrared.  I only used one layer, but in hindsight I probably should have used 2-3 layers of film.

For the headset, I simply used three IR LEDs in series with a 220 ohm resistor and a 9V battery.  This means the LEDs will have about 40mA going through them, which is within their spec.  Those are mounted onto a hat (photos will be forthcoming) so that two of the LEDs are on the corners of the visor, and the third is in the middle at the top of the head, all pointing towards the camera.  I then covered each LED with a thin layer of Blu-Tac to act as a diffuser.  Blu-Tac is surprisingly permable to IR light.

**<span>The Software</span>**

Firstly, I got drivers for the PS3Eye from [here](http://codelaboratories.com/downloads/).  Secondly, you'll also need FreeTrack itself.  Setup here is quite easy, follow the instructions you can find at [this link](http://www.free-track.net/forum/index.php?showtopic=2416).

When FreeTrack is running, mess about with your sensitivities.  You will probably notice that FreeTrack will crash if you just hit Start.  Click on the tabs that let you select the framerate, and the Stream button that lets you view the settings for the camera, and it'll be fine when you hit Start.

Assuming it all runs, you'll now need to get it running in your flight sim.  We'll assume you're using DCS A-10c like me.  [Download the Eagle Dynamics DLL](http://facetracknoir.sourceforge.net/information_links/download.htm)'s from the FreeTrackNoIR project (another head tracker) and then drop the files into a 'headtracker' folder under (I assume that the root of your DCS A-10c install is in C:\A10C for brevity);

C:\A10C\bin\headtracker    <-- put 64 bit DLL and files here  
C:\A10C\bin\x86\headtracker     <-- put 32 bit DLL and files here On starting up A-10, it should 'just work'. **<span>The Test</span>**

It's impressive.  The level of immersion provided by something so simple is amazing.  You will definitely want to enable deadzones for all the axes though otherwise it'll look like you have the shakes.  But once you get it tuned right, it's amazing.  Just being able to naturally look out of the cockpit is incredible.

It's impressive enough that I've just ordered a TrackIR.