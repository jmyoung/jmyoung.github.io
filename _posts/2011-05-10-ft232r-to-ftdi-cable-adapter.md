---
id: 97
title: FT232R to FTDI-cable Adapter
date: 2011-05-10T02:46:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=97
permalink: /2011/05/ft232r-to-ftdi-cable-adapter/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/05/ft232r-to-ftdi-cable-adapter.html
categories:
  - Electronics
tags:
  - arduino
---
I got myself one of Sparkfun's [FT232R Breakout](http://www.sparkfun.com/products/718) Boards, but I didn't get the basic version (whoops).  Now, the advanced version breaks out every pin of the FT232R, but it doesn't have a direct pinout to an FTDI cable such as what the [FT232R Basic](http://www.sparkfun.com/products/9716) supplies.  Oh, and it's set by default to 3.3v, but that's adjustable through a solder jumper.

I needed an FTDI adapter and a way to switch it between 5v and 3.3v sensibly.  No problem, as it turned out.

<a name="more"></a>The very first thing to do is to desolder the solder jumper on the top of the board.  That jumper fixes the VccIO line to 3.3v, which is not what we want.  We want it to be 5v in this case.

Second thing is to come up with a mapping of pins on the FT232R to pins on a normal FTDI cable.  Consulting the [schematic](http://www.sparkfun.com/datasheets/DevTools/Arduino/FTDI%20Basic-v21-5V.pdf) for the basic version makes this pretty simple.  Then we simply map that back to what we have on the breakout board, add in a line to link up VccIO to 5v, and we're sorted;

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i1.wp.com/4.bp.blogspot.com/-jgFpIU7KrNQ/Tcswzv7zS5I/AAAAAAAAAE0/0xmMAA5UumI/s1600/FTDI_5v_Adapter.png" imageanchor="1"><img border="0" height="281" src="https://i0.wp.com/4.bp.blogspot.com/-jgFpIU7KrNQ/Tcswzv7zS5I/AAAAAAAAAE0/0xmMAA5UumI/s320/FTDI_5v_Adapter.png?resize=320%2C281" width="320"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      FTDI Adapter - 5 volt version
    </td>
  </tr>
</table>

You can find the PDF and Eagle schematic files on my repository at [this link](http://code.google.com/p/zencoding-blog/source/browse/#svn%2Ftrunk%2Farduino%2Fftdi_5v_adapter).  Take careful note, the FTDI connector on that view is from the **top**, whereas the view of the breakout board is from the **bottom**.  Be careful not to wind up with one of the connectors upside down.  I've labelled every pin to reduce confusion in that regard.

Making a 3.3v version of this should be trivial, simply change the link from VccIO to 5v by moving it to 3.3v.  You could even do it with a switch, but I wouldn't advise that because fumble fingering it runs the risk of blowing up whatever you plug it into.  Just make two boards, and clearly label them.

Right now, I've only got it on a breadboard, but once my female pin headers come in, I'll build it onto a piece of stripboard to make a permanent adapter.