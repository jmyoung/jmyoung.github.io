---
id: 80
title: 'MCE Remote &#8211; Board Etching and Assembly'
date: 2011-06-19T10:05:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=80
permalink: /2011/06/mce-remote-board-etching-and-assembly/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/06/mce-remote-board-etching-and-assembly.html
categories:
  - Electronics
tags:
  - arduino
  - htpc
---
In my [last post](http://zencoding.blogspot.com/2011/05/mce-remote-ir-blaster-prototyping.html) about the MCE Remote relay I was working on, I prototyped up the circuit and finalized the schematic in Eagle.  After doing that, I worked on a PCB layout ( all related file can be found [here](http://code.google.com/p/zencoding-blog/source/browse/#svn%2Ftrunk%2Farduino%2Fmpc_irblaster) ).  It was a bit of a trick getting a suitable layout sorted out in Eagle, but I got it done.  From there, I was able to generate transfers for the top layer (silkscreen), and the bottom layer (etch).  They appear below;

<div>
</div>

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i2.wp.com/3.bp.blogspot.com/-BOOOCpEZLt8/Tf29-c01C1I/AAAAAAAAAIg/AFfwPg-g9Jc/s1600/silkscreen.png" imageanchor="1"><img border="0" height="210" src="https://i0.wp.com/3.bp.blogspot.com/-BOOOCpEZLt8/Tf29-c01C1I/AAAAAAAAAIg/AFfwPg-g9Jc/s320/silkscreen.png?resize=320%2C210" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Silkscreen layer (as output by Eagle)
    </td>
  </tr>
</table>



<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i2.wp.com/1.bp.blogspot.com/-mURIOTrQRYE/Tf29__Z3iJI/AAAAAAAAAIk/C4o-otCj9tA/s1600/etch.png" imageanchor="1"><img border="0" height="210" src="https://i1.wp.com/1.bp.blogspot.com/-mURIOTrQRYE/Tf29__Z3iJI/AAAAAAAAAIk/C4o-otCj9tA/s320/etch.png?resize=320%2C210" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Etch layer (as output by Eagle)
    </td>
  </tr>
</table>

<div>
</div>

<div>
  I strongly recommend making sure you put text on all layers somewhere, so you can easily identify if they are reversed or not.  In order to do something useful with that, I decided to do something completely new to me - toner transfer PCB etching.
</div>

<div>
  <a name="more"></a>The principle with toner transfer etching is simple.  Laser printer toner is plastic, and if transferred onto a copper PCB will protect the PCB from the etchant wherever it is.  Since I'd just got hold of a laser printer, I thought I'd make use of the idea.  I went to Jaycar and bought some Press 'n Peel toner transfer film.
</div>

<div>
</div>

<div>
  This film is quite expensive per sheet.  Many people do the same thing on magazine glossy paper, but I figured I'd go with the peel just to make things easy for my first go.  I also bought a PCB etching kit which came with PCBs about the right size, a tray, tweezers, and sodium persulphate etchant.
</div>

<div>
</div>

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i1.wp.com/4.bp.blogspot.com/-9M273xlBxV8/Tf2_XIkLqBI/AAAAAAAAAIo/KtuZ3Mx97J0/s1600/transfer.JPG" imageanchor="1"><img border="0" height="209" src="https://i1.wp.com/4.bp.blogspot.com/-9M273xlBxV8/Tf2_XIkLqBI/AAAAAAAAAIo/KtuZ3Mx97J0/s320/transfer.JPG?resize=320%2C209" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Etch layer printed onto transfer film
    </td>
  </tr>
</table>

<div>
  The prints that you do should be reversed onto the toner paper (so the silkscreen layer gets mirrored, but the etch layer is printed as is).   One thing I discovered - don't turn up the toner density too much.  I turned it up to maximum, and I got some of the smears you see there, and there wound out being way too much toner.  In addition to that, I should have made my isolation distances a little bigger because the toner flattens out a bit and makes the traces wider than expected.
</div>

<div>
</div>

<div>
  After doing that, you simply lay the film on top of the cleaned PCB and iron it with a hot domestic clothes iron (no steam!) for a few minutes, gently moving the iron to ensure even heat transfer.  Afterwards, quench the board in cold water and peel off the film.
</div>

<div>
</div>

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/4.bp.blogspot.com/-R0732Pz-zUc/Tf2_99-TnOI/AAAAAAAAAIs/m38uxFXAX5A/s1600/pre_etch.JPG" imageanchor="1"><img border="0" height="161" src="https://i1.wp.com/4.bp.blogspot.com/-R0732Pz-zUc/Tf2_99-TnOI/AAAAAAAAAIs/m38uxFXAX5A/s320/pre_etch.JPG?resize=320%2C161" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Toner transferred to PCB
    </td>
  </tr>
</table>

<div>
  As you can see, there's a few spots where the tone squeezed out and made shorts on the tracks.  Those are resolved easily with a sharp knife post-etching, but it would have been better if I'd made the isolations a bit further apart.  I also filled in the (huge) pads of the 2.1mm power jack with an etch resist pen.  Then, it's in the etchant, following the instructions.  You'll notice that nearly nothing appears to happen, but then all the copper vanishes within a short period of time.  That's because of the extremely high opacity of metals - the copper remains opaque until it's only a few atoms thick, and then it all appears to vanish in a rush.  That's normal.
</div>

<div>
</div>

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/4.bp.blogspot.com/-KirSIAtlKqM/Tf3BZXfQOBI/AAAAAAAAAIw/Yt8zexdwX_s/s1600/post_etch.JPG" imageanchor="1"><img border="0" height="203" src="https://i1.wp.com/4.bp.blogspot.com/-KirSIAtlKqM/Tf3BZXfQOBI/AAAAAAAAAIw/Yt8zexdwX_s/s320/post_etch.JPG?resize=320%2C203" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Post etch, toner layer still in place
    </td>
  </tr>
</table>

<div>
  Removing the toner is as simple as giving it a wipe with acetone.  After that, I ironed on the silkscreen layer transfer in the same way on the top, and then drilled all the holes.  Most holes are 0.8mm, with the 2.1mm jack being 3mm.
</div>

<div>
</div>

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/3.bp.blogspot.com/-19Fq4a0H5Qo/Tf3Bvm_yVnI/AAAAAAAAAI0/trZEmxaOH4Y/s1600/board_top.JPG" imageanchor="1"><img border="0" height="196" src="https://i0.wp.com/3.bp.blogspot.com/-19Fq4a0H5Qo/Tf3Bvm_yVnI/AAAAAAAAAI0/trZEmxaOH4Y/s320/board_top.JPG?resize=320%2C196" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Silkscreened Layer
    </td>
  </tr>
</table>

<div>
  The horrible damage on the corners was my highly amateurish attempts at getting the damn board to fit into the jiffy box I got, which was only just big enough for the board.  I'm sure I could have done a much better job of it, but it doesn't really matter.
</div>

<div>
</div>

<div>
  And then finally, soldering all the parts on.  The ironed on template on the top makes assembly much much easier, even though it's not lined up perfectly.
</div>

<div>
</div>

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i1.wp.com/2.bp.blogspot.com/--Xk0buEYkLQ/Tf3CMWnf5JI/AAAAAAAAAI4/18qC8rnM-r8/s1600/populated.JPG" imageanchor="1"><img border="0" height="230" src="https://i0.wp.com/2.bp.blogspot.com/--Xk0buEYkLQ/Tf3CMWnf5JI/AAAAAAAAAI4/18qC8rnM-r8/s320/populated.JPG?resize=320%2C230" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Populated Board
    </td>
  </tr>
</table>

<div>
  Instead of soldering the infrared LEDs direct to the board, I soldered in female pin headers, so that I can use a cable for one of the LEDs if I want.
</div>

<div>
</div>

<div>
  On powerup, I noticed immediately that the pin arrangement of the RGB led is different from the schematic!  It doesn't matter though, I was able to take care of it with a software change (the blue and green pins are swapped).  I also thought that the circuit didn't work and so wound out doing all sorts of ugly things to the transistor amplifying stage, but it turned out to be perfectly fine and it was simply that I uploaded a copy of the code using the bugged IRremote library instead of my fixed version.  Doh!
</div>

<div>
</div>

<div>
  Next up is to <i>neatly </i>cut out the jiffy box to suit, and I'm done!
</div>