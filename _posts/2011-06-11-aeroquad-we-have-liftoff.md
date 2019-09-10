---
id: 81
title: 'AeroQuad &#8211; We Have Liftoff!'
date: 2011-06-11T05:50:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=81
permalink: /2011/06/aeroquad-we-have-liftoff/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/06/aeroquad-we-have-liftoff.html
categories:
  - Electronics
tags:
  - aeroquad
  - quadcopter
---
Well, it's done!  Last night I completed the last of the wiring, spun up all the motors, ran through the pre-flight checklists, and this morning I set the quad going in the carport.  It took off, no major issues.  Leans to the right, but I think that's because of the angle of the carport's concrete.  I only brought it about a foot off the ground 🙂

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i1.wp.com/1.bp.blogspot.com/-9E4dP5qcll0/TfR06PnKbWI/AAAAAAAAAHw/xz9LanxP6n8/s1600/readyforflight.JPG" imageanchor="1"><img border="0" height="240" src="https://i1.wp.com/1.bp.blogspot.com/-9E4dP5qcll0/TfR06PnKbWI/AAAAAAAAAHw/xz9LanxP6n8/s320/readyforflight.JPG?resize=320%2C240" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Ready for flight!
    </td>
  </tr>
</table>

<a name="more"></a>

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/2.bp.blogspot.com/-726qGhZKNmQ/TfL4pODOTZI/AAAAAAAAAHg/e7LpGfc2k48/s1600/assembled_props.JPG" imageanchor="1"><img border="0" height="307" src="https://i1.wp.com/2.bp.blogspot.com/-726qGhZKNmQ/TfL4pODOTZI/AAAAAAAAAHg/e7LpGfc2k48/s320/assembled_props.JPG?resize=320%2C307" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Top View
    </td>
  </tr>
</table>

Everything fitted in, however I had to cut a few mm off the inside end of the arms to make enough room for the wiring harness.  Total weight is 1708 grams.  Heavier than I anticipated, and I put that down to additional weight from the wiring harness, connectors, and solder in the bullet connectors.  Still within the thrust power:weight ratio though.

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i2.wp.com/3.bp.blogspot.com/-y2G0TlhFqFg/TfL5yX5XpgI/AAAAAAAAAHk/KosuI0r2x1s/s1600/wiring_displayed.JPG" imageanchor="1"><img border="0" height="310" src="https://i2.wp.com/3.bp.blogspot.com/-y2G0TlhFqFg/TfL5yX5XpgI/AAAAAAAAAHk/KosuI0r2x1s/s320/wiring_displayed.JPG?resize=320%2C310" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Assembled with top baseplate removed, showing wiring
    </td>
  </tr>
</table>

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i1.wp.com/3.bp.blogspot.com/-64_D8ms3-Xo/TfL59budpFI/AAAAAAAAAHo/18fxG8AdIzc/s1600/wiring_harness.JPG" imageanchor="1"><img border="0" height="217" src="https://i1.wp.com/3.bp.blogspot.com/-64_D8ms3-Xo/TfL59budpFI/AAAAAAAAAHo/18fxG8AdIzc/s320/wiring_harness.JPG?resize=320%2C217" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Power distribution harness
    </td>
  </tr>
</table>

The cables that are going between the arms are shielded from the arms by a folded piece of hard plastic, acting as a grommet.  The actual power harness itself uses heavy 12 AWG wire for the main branch, breaking out into 16 AWG for the branches for each ESC, and also a breakout for a 2.1mm jack for the Arduino.  The trunks are then heatshrunk and ziptied together.  The whole arrangement is quite stiff, hence why I had to organize things so that two ESCs were in the front quadrant, and one in each side quadrant, with none in the back.

Each 2-wire bullet connector is keyed so that they can't be plugged in the wrong way around.  However, the 3-wire bullet connector for the ESC to motor connection is unkeyed so that they can be reversed to reverse the motor.

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i2.wp.com/4.bp.blogspot.com/-e2pvqNGC9lk/TfL6tWJ7XbI/AAAAAAAAAHs/h0DZdQm_rak/s1600/esc-connections.JPG" imageanchor="1"><img border="0" height="217" src="https://i1.wp.com/4.bp.blogspot.com/-e2pvqNGC9lk/TfL6tWJ7XbI/AAAAAAAAAHs/h0DZdQm_rak/s320/esc-connections.JPG?resize=320%2C217" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      ESC and Motor connections
    </td>
  </tr>
</table>

I've followed the same bullet connector keying as the battery.  As of right now, none of the bolts are Loctited, but I'll have to disassemble and apply Loctite everywhere shortly.

Now that's done, I need to learn how to fly the damn thing, and then think about extensions.  First thing I'm thinking of is a way to leverage a barometer/magnetometer onto the thing...