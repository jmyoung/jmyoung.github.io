---
id: 86
title: 'AeroQuad &#8211; Engine Mounts'
date: 2011-05-25T01:49:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=86
permalink: /2011/05/aeroquad-engine-mounts/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/05/aeroquad-engine-mounts.html
categories:
  - Quadcopters
tags:
  - aeroquad
  - quadcopter
---
After a lot of discussion on the [AeroQuad](http://www.aeroquad.com/) forums about mounting the Turnigy 2217-16 motors I got to the arms of the frame, I decided to take a good idea and implement it.

Essentially, what I'm going to do is to construct a plate out of 20mm x 3mm aluminium flat bar (bought from Bunnings at like $6 a metre), 60mm in length.  That plate has the motor bolted directly to it with some 10mm M3 bolts, and then is bolted to the end of the arm with a single 25mm M5 bolt.  The idea there is that crash stresses on the end of the arm will tend to bend the 3mm plate or rotate it around its M5 bolt without damaging the motor mount.  Sounds like an idea.

<a name="more"></a>  
So last night I templated up what it would look like, went and bought the aluminium, and fired up the drill press and made one.  Looks to me like it'll do the job.

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i2.wp.com/2.bp.blogspot.com/-c-jOGAUSMFA/TdwtlAmoauI/AAAAAAAAAGk/-qD5bwlDH2Q/s1600/mount_side.JPG" imageanchor="1"><img border="0" height="320" src="https://i1.wp.com/2.bp.blogspot.com/-c-jOGAUSMFA/TdwtlAmoauI/AAAAAAAAAGk/-qD5bwlDH2Q/s320/mount_side.JPG?resize=244%2C320" width="244"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Completed Motor Mount
    </td>
  </tr>
</table>

 The motor mount has 3mm holes for the M3 bolts, a 9mm hole for the motor's shaft to pass through, and a 5mm hole for the M5 mounting bolt.  In hindsight, I should probably make the M3 holes at 3.5mm, since it's pretty hard to get them _exactly_ right, and if they are off by even a tiny amount, they're hard to screw in because of the mating required with the motor.  Notice how one of the bolts is a little skewed on mine.

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/1.bp.blogspot.com/-QnQdOhFFxUs/TdwtjV-5UUI/AAAAAAAAAGg/Kg3mRw0mCsU/s1600/mount_closeup.JPG" imageanchor="1"><img border="0" height="150" src="https://i1.wp.com/1.bp.blogspot.com/-QnQdOhFFxUs/TdwtjV-5UUI/AAAAAAAAAGg/Kg3mRw0mCsU/s320/mount_closeup.JPG?resize=320%2C150" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Closeup - notice skewed right bolt & three washers
    </td>
  </tr>
</table>

Since the only suitable M3 bolts I had were 10mm, I had to use three washers and a spring washer to provide enough spacing to ensure that the bolt didn't penetrate too far into the guts of the motor.  As it is, one of them is pressing lightly on the insulation of one of the cables.  It shouldn't do any harm, but I'll inspect it after use for any kind of damage - I might need to go with four washers (or a smaller 3mm aluminium spacer or something).  I haven't sealed down the bolts yet with Loctite, I'll wait until I have everything assembled and finalized, then I'll Loctite everything in place.

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/4.bp.blogspot.com/-8cQSyq4pgek/TdwtlwHzVcI/AAAAAAAAAGo/HL1Zlkadt1k/s1600/mount_underside.JPG" imageanchor="1"><img border="0" height="156" src="https://i2.wp.com/4.bp.blogspot.com/-8cQSyq4pgek/TdwtlwHzVcI/AAAAAAAAAGo/HL1Zlkadt1k/s320/mount_underside.JPG?resize=320%2C156" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Motor mount (underside)
    </td>
  </tr>
</table>

When i bolt the mount to the arm, I'll also be bending a piece of 1.6mm plate under the motor mount to use as a leg - not a supporting structure, but a standoff to stop the arms touching the ground on a slightly wobbly landing.

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i2.wp.com/3.bp.blogspot.com/-YvNmGFh0PNc/TeDOAGGNRPI/AAAAAAAAAGw/BraMRoooFw8/s1600/finished_mount.JPG" imageanchor="1"><img border="0" height="320" src="https://i2.wp.com/3.bp.blogspot.com/-YvNmGFh0PNc/TeDOAGGNRPI/AAAAAAAAAGw/BraMRoooFw8/s320/finished_mount.JPG?resize=297%2C320" width="297"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Completed leg
    </td>
  </tr>
</table>

Next up is to adjust my frame designs, then make three more of these mounts.