---
id: 85
title: Finalized Frame Design (and all-up weight)
date: 2011-05-27T01:47:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=85
permalink: /2011/05/finalized-frame-design-and-all-up-weight/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/05/finalized-frame-design-and-all-up.html
categories:
  - Quadcopters
tags:
  - aeroquad
  - quadcopter
---
Finalized what I'm going to do with the frame design last night.  Frame design can be found at [this link](http://zencoding-blog.googlecode.com/svn/trunk/aeroquad/frame_design.vsd) (Visio document).  This frame is intended to be fairly small, but still robust and very easy (and cheap!) to construct replacement parts for.  M2M distance is ~475mm, which is around the 18.7 inch mark.  This frame is intended for use with 10 inch props (a 10 inch prop will just avoid the baseplate getting into the prop wash).

<a name="more"></a>  
The materials that are required for building this frame are;

  * 12pcs 25mm M5 bolts, nuts and washers
  * 4pcs 30mm M5 bolts, nuts and washers
  * 8pcs 10mm M3 bolts, with 3 washers and one spring washer each
  * A few spare M5 bolts (for the landing gear, sizes not decided yet)
  * 4pcs 19.05x19.05x200mm aluminium square tube, 1.2mm thickness (thicker is ok)
  * 2pcs 145x145mm aluminium sheet, 1.2mm thickness (thicker is ok)
  * 4pcs 20x60mm aluminium flat bar, 3mm thickness
  * 2pcs 20x255mm aluminium flat bar, 1.2mm thickness (thicker is ok)

I had to adjust my design a number of times, in particular because the sheet I bought was 295x295mm, which means I couldn't get multiple baseplates out of the one sheet if I went with a 150mm baseplate.  By varying the design to 145mm, I can get four baseplates out of one sheet, which is a significant cost savings (meaning each baseplate costs me ~$1.75).

Landing skids on the underside are two bent pieces of 1.2mm aluminium bar.  I may have to upgrade them to 3mm, depending on how easily they're deformed.  Bends on the skids should all be inwards and 90 degrees, so that the skids make a U shape with the tags pointing inwards.  Drill the 5mm hole for the bolts first.  The bars for the skids are slightly longer than they need to be to take into account losses involved with bending.  The skids provide 40mm of spacing, which is sufficient to keep the battery off the ground and also sufficient to have the legs on the arms off not making contact under normal circumstances.

All-up weight with no ESCs, props, or cabling is 1462g, so with the extra bits I'd expect to be around the 1.6kg mark.  A thrust calculator says that I have 4kg static thrust with the GWS 10x6 propellors I have (4.4 mins full throttle flight time), and 4.7kg static thrust with the APC 10x4.7 SF props (only 3.8 mins full throttle flight time).  This fits in nicely with my aimed 2:1 thrust:weight ratio, so performance should be fine.  The quad should be able to hover at around half throttle.

Weights of individual items follow;

  * Arms with plastic endcaps fitted (holes not drilled) - 206g
  * 295x295x1.2mm plate - 288g
  * 4pcs M5 25mm bolt with nut (no washer) - 20g
  * 1000x20x1.6mm flat bar - 88g
  * 757x20x3mm flat bar - 124g
  * MCU in container with M5 bolts / nuts - 212g
  * Motors with mounts fitted (no props or arm retaining bolts) - 346g
  * Battery - 404g

As you can see, the MCU+Motor+Battery combination comprises a very significant portion of the overall weight, so I'm not convinced I could really drop much weight by going to, say, nylon or aluminium bolts or other small things like that.  Replacing the baseplate with G10 fiberglass may remove a fair bit of weight though.

Note that some of those items are for uncut pieces - so that the baseplates I actually fit will weigh under a quarter of the whole 295x295mm plate and such.

Anyway, it's all coming together reasonably nicely.  Next tasks are to cut out the baseplates, drill all the holes and assemble the rest of the frame.