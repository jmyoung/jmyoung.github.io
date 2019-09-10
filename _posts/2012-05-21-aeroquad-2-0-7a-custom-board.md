---
id: 38
title: AeroQuad 2.0.7a Custom Board
date: 2012-05-21T03:03:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=38
permalink: /2012/05/aeroquad-2-0-7a-custom-board/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2012/05/aeroquad-207a-custom-board.html
categories:
  - Quadcopters
tags:
  - aeroquad
  - quadcopter
---
Got my customized AQ 2.0.7 board, and I spent the weekend transferring all my existing sensors and such across to it.

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/4.bp.blogspot.com/-9CUd9pNN7qE/T7mjBKIEpqI/AAAAAAAAAB8/cSSyeNy-f5A/s1600/IMG_0839.JPG" imageanchor="1"><img border="0" height="235" src="https://i1.wp.com/4.bp.blogspot.com/-9CUd9pNN7qE/T7mjBKIEpqI/AAAAAAAAAB8/cSSyeNy-f5A/s320/IMG_0839.JPG?resize=320%2C235" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      AQ 2.0.7a Custom Board
    </td>
  </tr>
</table>

So, it turned out that the board actually has an error on it!  Eagle went and isolated a piece of ground plane, so you have to hook a small air wire from GND on the barometer to GND on the LLC.  Oh well.  Other than that, everything went pretty swimmingly moving my sensors across to it.  I had to completely ruin my old AQ v1.9 board to get everything out intact though.

It also turns out that the LEDs that are supplied with the AQ kit are not normal LEDs, they are actually LEDs with built-in resistors.  So my current board has no LEDs on it while I wait for my order of special LEDs to arrive.

The board worked pretty well straight off.  I discovered that the magnetometer is basically useless in its current position, too much interference from the power systems under it.  I'm thinking of desoldering the magnetometer board and relocating it onto a mast above the quad so it can get clear of the interference.