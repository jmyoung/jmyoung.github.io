---
id: 90
title: 'AeroQuad &#8211; Frame and MCU Case Design'
date: 2011-05-21T08:59:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=90
permalink: /2011/05/aeroquad-frame-and-mcu-case-design/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/05/aeroquad-frame-and-mcu-case-design.html
categories:
  - Quadcopters
tags:
  - aeroquad
  - quadcopter
---
Now that I've got the shield put together, the next step is to design and build a frame and container for the MCU and other electronics.

The container wasn't too hard.  I had a lunchbox-style clear container which I conscripted into service - it's the right height, and has the right features (clear, lid has a rubber seal in it, latches shut instead of just pressing shut, and square).  Converting it into a suitable container for the Arduino was an exercise in frustration, mostly on account of how screws for standoffs come in about a billion different types...  What I wound out using was 8mm long nylon PCB standoffs, which require a 3mm hole in the PCB.

<a name="more"></a>

Even those were a trial, because when they say 3mm, they actually mean "really tight fit with 3.5mm holes), and the holes in the Arduino board are exactly 3mm.  So I had to drill out the holes in the PCB to 3.5mm so they'd fit.  I didn't get the Arduino in very straight, but that's OK because I'll just offset the whole container a little when I attach it to the frame.

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i2.wp.com/2.bp.blogspot.com/-xxMcVoGOMOU/Tdd2HDmrttI/AAAAAAAAAGU/-o_0DeRtpDc/s1600/mcu_opened.JPG" imageanchor="1"><img border="0" height="240" src="https://i2.wp.com/2.bp.blogspot.com/-xxMcVoGOMOU/Tdd2HDmrttI/AAAAAAAAAGU/-o_0DeRtpDc/s320/mcu_opened.JPG?resize=320%2C240" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Electronics fitted to container.  Note slight offset on shield.
    </td>
  </tr>
</table>



<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/4.bp.blogspot.com/-ym-VMMBuQ5M/Tdd2Jv1biuI/AAAAAAAAAGY/la74uPEbWB8/s1600/mcu_shut.JPG" imageanchor="1"><img border="0" height="240" src="https://i2.wp.com/4.bp.blogspot.com/-ym-VMMBuQ5M/Tdd2Jv1biuI/AAAAAAAAAGY/la74uPEbWB8/s320/mcu_shut.JPG?resize=320%2C240" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Container latched shut.  It fits!
    </td>
  </tr>
</table>

I added a half inch grommet into the lid of the container, so I can route the motor cables and other required cables out of the hole, and there are four other grommets in the lid which 5mm bolts will pass through to attach the lid to the frame.

PDF of the frame design is available at [this link](http://zencoding-blog.googlecode.com/svn/trunk/aeroquad/frame_design.pdf).  My general plan here is to make a rigid frame which keeps the arms quite stiff, but then to mount the electronics container to the frame baseplate with a sandwiched piece of 3mm foam rubber in between, and also vibration isolate those bolts with grommets on both sides.  We'll see how that pans out.

The materials I wound out getting were 19.05x19.05x1.2mm wall aluminium square tube from Bunnings, and 1.2mm aluminium sheet from Jaycar.  I also got normal steel M5 bolts - I'll see about replacing those with aluminium later if I have weight problems.  The plan is to have the arms long enough to have a half-inch space of bar after the edge of the motor, and then have the tips of the propellors clear the container holding the MCU by one inch.  This should give a M2M distance of 18.5 inches.  Reasonably compact.

Next up will be the start of assembly of the frame itself.