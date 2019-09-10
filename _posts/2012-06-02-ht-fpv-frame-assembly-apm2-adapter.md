---
id: 36
title: 'HT-FPV Frame Assembly &amp; APM2 Adapter'
date: 2012-06-02T01:34:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=36
permalink: /2012/06/ht-fpv-frame-assembly-apm2-adapter/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2012/06/ht-fpv-frame-assembly-apm2-adapter.html
categories:
  - Quadcopters
tags:
  - ardupilot
  - htfpv
  - quadcopter
---
I got myself a HoverThings [HT-FPV](http://www.hoverthings.com/htfpvblack.html) frame for the new quadcopter.  The frame is made entirely from G10 fiberglass, aluminium spaces, and #4-40 bolts.

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i2.wp.com/4.bp.blogspot.com/-RBP5wudI6T0/T8lgVjcnlmI/AAAAAAAAACc/l8DqI_zc5g4/s1600/htfpv.jpg" imageanchor="1"><img border="0" height="215" src="https://i1.wp.com/4.bp.blogspot.com/-RBP5wudI6T0/T8lgVjcnlmI/AAAAAAAAACc/l8DqI_zc5g4/s320/htfpv.jpg?resize=320%2C215" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      HoverThings HT-FPV Frame (black)
    </td>
  </tr>
</table>

<div>
</div>

As you can see, it looks excellent.  The frame is intended for use with FPV.  I don't have any FPV equipment, but that will be changing.  Anyway, during the assembly, I noticed a few issues;



  * Battery holder isn't high enough to hold a 5000mAh Zippy Flightmax battery.  This should be resolvable with either a smaller battery or higher spacers on the top plate.
  * No landing gear.  However, I'm planning on putting on some landing gear ([this](http://www.hobbyking.com/hobbyking/store/uh_viewItem.asp?idProduct=10159) and [this](http://www.hobbyking.com/hobbyking/store/uh_viewItem.asp?idProduct=10160)) which I already use on my current quad.  I really don't like the idea of having no landing gear at all.
  * There's an aluminium spacer directly under the motor mounts.  Unfortunately the Turnigy 2217-16 motor has a shaft sticking out at the bottom of the motor that interferes with that spacer.  I don't want to remove the spacer because it will affect the rigidity of the frame.  The solution here is to cut the shafts off with bolt cutters - they aren't used for anything useful.
  * The middle plate has hole spacing for many popular board sizes.  Unfortunately it has no hole spacing that's suitable for an [ArduPilotMega2](http://code.google.com/p/arducopter/wiki/APM2board)!  The solution appears below...

So, to resolve the last issue, I decided to go and make an adapter board to allow the APM2 to bolt onto the HT-FPV frame with either a 45mm x 45mm or 60mm x 60mm spacing.  Then I realized that I need to make some adapters so that the BEC power from my four ESCs only gets to the APM2 from one of the ESCs.

Enter the [APM2 Board Adapter v1.0](http://code.google.com/p/zencoding-blog/source/browse/#svn%2Ftrunk%2Fschematics%2FAPM2_Adapter)!

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i1.wp.com/2.bp.blogspot.com/-YBWPP0ZEerQ/T8lgWwNcgBI/AAAAAAAAACo/AOzyXeHGFFU/s1600/top.png" imageanchor="1"><img border="0" height="320" src="https://i1.wp.com/2.bp.blogspot.com/-YBWPP0ZEerQ/T8lgWwNcgBI/AAAAAAAAACo/AOzyXeHGFFU/s320/top.png?resize=320%2C320" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      APM2 Board Adapter Top Render
    </td>
  </tr>
</table>



<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i1.wp.com/1.bp.blogspot.com/-DsgoqOpCjKk/T8lgURImjtI/AAAAAAAAACY/_PDh_l7jSzg/s1600/bottom.png" imageanchor="1"><img border="0" height="320" src="https://i2.wp.com/1.bp.blogspot.com/-DsgoqOpCjKk/T8lgURImjtI/AAAAAAAAACY/_PDh_l7jSzg/s320/bottom.png?resize=320%2C320" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      APM2 Board Adapter Bottom Render
    </td>
  </tr>
</table>

I've ordered three of the boards from [OshPark](http://oshpark.com/) this time around so that I've tried them out.  The adapter board itself has all passive components (I was debating adding some capacitive filter caps to the power section, but I decided against it), and has the following features;

  * Direction guide so you get your APM2 installed the right way around (on both side of the board)
  * Hole spacing for 45x45mm mounts and 60x60mm mounts
  * Up to eight ESC inputs and a separate BEC
  * Configurable power selection so that you can move a jumper to select which ESC supplies power to your APM2 (or none!)
  * Splits out the ESC signal line to a separate pin header
  * Large ground plane on the underside of the board to reduce interference caused by power systems under the board
  * No ground plane on the top of the board, and no traces inside the APM2 mounting area, so that the APM2 can be mounted hard to the board and scratches won't reveal traces and cause shorts

Assuming I actually got all my dimensions right (I'm pretty sure I did), I should be able to attach this to the HT-FPV frame using the 60x60 holes, then attach the APM2 directly to it.  From there, I can connect my four ESCs to the ESC inputs, jumper one of them for power output, then I can take the PWM inputs off the board and the VCC out and I'm done.

We'll see what it's like when I get the boards.