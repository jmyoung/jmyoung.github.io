---
id: 77
title: Some Breakout Boards
date: 2011-07-08T01:26:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=77
permalink: /2011/07/some-breakout-boards/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/07/some-breakout-boards.html
categories:
  - Electronics
---
Last weekend I assembled a few breakout boards for things I'm going to need to be able to prototype my Reflow Oven project.  Namely, I needed a DB9 RS232 breakout board, a DIN-5 breakout board, and a 5v power supply.  Schematics and board layouts (fixed versions!) can be found at my [GoogleCode](http://code.google.com/p/zencoding-blog/source/browse/#svn%2Ftrunk%2Farduino%2Farduinoven%2Fbreakouts) repository.

Unfortunately, due to not paying appropriate attention, the boards below have a missing track - one that I had to fix with a green wire.  Ah well.  The versions on GoogleCode are fixed.

<a name="more"></a>

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i2.wp.com/3.bp.blogspot.com/-jWaZO0SMjqA/ThOM3mRHziI/AAAAAAAAAJA/WPEo4ZkVDHc/s1600/IMG_0644.JPG" imageanchor="1"><img border="0" height="127" src="https://i2.wp.com/3.bp.blogspot.com/-jWaZO0SMjqA/ThOM3mRHziI/AAAAAAAAAJA/WPEo4ZkVDHc/s320/IMG_0644.JPG?resize=320%2C127" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Top View
    </td>
  </tr>
</table>



<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/3.bp.blogspot.com/-qxqZdpBCIRI/ThOM4t4faKI/AAAAAAAAAJE/B-e7N2qPWOk/s1600/IMG_0645.JPG" imageanchor="1"><img border="0" height="125" src="https://i1.wp.com/3.bp.blogspot.com/-qxqZdpBCIRI/ThOM4t4faKI/AAAAAAAAAJE/B-e7N2qPWOk/s320/IMG_0645.JPG?resize=320%2C125" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Underside (missing track on middle board)
    </td>
  </tr>
</table>



<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/2.bp.blogspot.com/-cts4-GQUf0g/ThOM5uFc1hI/AAAAAAAAAJI/5toJEf9oc7M/s1600/IMG_0646.JPG" imageanchor="1"><img border="0" height="124" src="https://i2.wp.com/2.bp.blogspot.com/-cts4-GQUf0g/ThOM5uFc1hI/AAAAAAAAAJI/5toJEf9oc7M/s320/IMG_0646.JPG?resize=320%2C124" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Fully assembled!
    </td>
  </tr>
</table>

This time around I didn't adjust the printer at all - I just printed at default density, and did the toner transfer thing and etched.  In order to get the transfers made, I made use of an Eagle .CAM file I made up just for that purpose - you can find it [here](http://zencoding-blog.googlecode.com/svn/trunk/toner.cam).

Before running the CAM file, you should run Eagle's drill-aid.upl script.  That will insert some circles into the insides of all pads on the board restricting the hole size to the size you've specified.  This is very useful since frequently the hole size is huge on parts, and you only need a 0.8mm hole in the center to align your drill.

After doing so, run the CAM and it'll generate three EPS files, named .ETCH.EPS, .OVERLAY.EPS and .FILL.EPS .  These are encapsulated postscript files that can be opened up with an editor like GIMP.

  * **ETCH.EPS** is the bottom copper layer (the etch).  You should have pad filling turned off if you are going to use the FILL file, or ON if you aren't.
  * **OVERLAY.EPS** is the top silkscreen layer (the overlay).  This is mirrored to make it ready to print onto transfer film.
  * **FILL.EPS** is the output of layer 116, which is the fill layer generated by drill-aid.ulp.  If you're using this, you will need to edit ETCH.EPS and import FILL.EPS over the top of it, making the white parts of FILL.EPS transparent.  That way the pads on your etch will be filled in appropriately.

After running this and processing the files, I printed them out onto transfer film and etched them.  After etching I ironed on the overlay, and it all turned out pretty well (besides the missing track!).  I then ran over the board with solder to tin all the tracks, and soldered on the components.  No track shorts or any problems, although I did have a broken track that I fixed with a solder bridge.  I used 10mil track width and 12mil track spacing.

The 5V power supply in the photo above has a jumper where the 500mA polyfuse should be for now, since I was waiting for the polyfuses to arrive.  They've arrived now, so I'll swap that part in.

Next up is to put the relay and thermocouple inside the oven, make up the DIN-5 connector, and test it.  Then I need to finalize the layout of the board and finish the prototyping.