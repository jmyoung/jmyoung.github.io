---
id: 25
title: FOV Adjustments for TripleHead Setups
date: 2012-08-02T03:15:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=25
permalink: /2012/08/fov-adjustments-for-triplehead-setups/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2012/08/fov-adjustments-for-triplehead-setups.html
categories:
  - Gaming
tags:
  - gaming
  - nvsurround
  - warthog
---
Many games appear to do horrible things with the viewport when you are using a display with a strange aspect ratio - such as a triple head setup.  The aspect ratio of my setup is 48:9, which plays merry hell with viewports in flight sims that are designed to look 'normal' with a 16:9 setup.  The usual result is that views are horrendously thin vertically.

Anyway, I did some trigonometry (which is probably a bit broken) and came out with a formula that lets you convert a FOV figure that's intended for a normal aspect ratio and convert it to an FOV that's appropriate for a triplehead setup.

<p style="padding-left: 30px;">
  <img src="//s0.wp.com/latex.php?latex=%5Cdisplaystyle+%5Ctheta+%3D+2+%5Ctan+%5E%7B-1%7D+%28+3+%5Ctan+%5Cfrac%7B%5Calpha%7D%7B2%7D+%29+&#038;bg=ffffff&#038;fg=000&#038;s=2" alt="&#92;displaystyle &#92;theta = 2 &#92;tan ^{-1} ( 3 &#92;tan &#92;frac{&#92;alpha}{2} ) " title="&#92;displaystyle &#92;theta = 2 &#92;tan ^{-1} ( 3 &#92;tan &#92;frac{&#92;alpha}{2} ) " class="latex" /><br /> Where<br /> <img src="//s0.wp.com/latex.php?latex=%5Calpha+%3D+&#038;bg=ffffff&#038;fg=000&#038;s=0" alt="&#92;alpha = " title="&#92;alpha = " class="latex" /> original FOV<br /> <img src="//s0.wp.com/latex.php?latex=%5Ctheta+%3D&#038;bg=ffffff&#038;fg=000&#038;s=0" alt="&#92;theta =" title="&#92;theta =" class="latex" /> new FOV
</p>

Using this, the result that you get is the 'original' view, instead of being spread horizontally across three monitors and then the vertical component being hopelessly thin will be spread across only the center monitor.  This means that you'll see extra stuff on the left and right that wouldn't have been in that viewport normally, but the vertical view will be normal.

Doing this in something like A-10 with the left and right MFCD's works great - the MFCD appears on the central monitor and pretty well fills it, which is what you'd expect.  Without adjusting FOV, you just get about 1/3 of the MFCD into the display.

A conversion chart appears below for those who don't want to do math;

<div class="table-responsive">
  <table  style="width:100%; "  class="easy-table easy-table-default table table-bordered" border="0">
    <caption>FOV Conversion Chart</caption> <tr>
      <th >
        Standard FOV
      </th>
      
      <th >
        Triplehead FOV
      </th>
    </tr>
    
    <tr>
      <td >
        20
      </td>
      
      <td >
        55.76
      </td>
    </tr>
    
    <tr>
      <td >
        30
      </td>
      
      <td >
        77.59
      </td>
    </tr>
    
    <tr>
      <td >
        40
      </td>
      
      <td >
        95.03
      </td>
    </tr>
    
    <tr>
      <td >
        50
      </td>
      
      <td >
        108.88
      </td>
    </tr>
    
    <tr>
      <td >
        60
      </td>
      
      <td >
        120.00
      </td>
    </tr>
    
    <tr>
      <td >
        70
      </td>
      
      <td >
        129.09
      </td>
    </tr>
    
    <tr>
      <td >
        75
      </td>
      
      <td >
        133.04
      </td>
    </tr>
    
    <tr>
      <td >
        80
      </td>
      
      <td >
        136.67
      </td>
    </tr>
    
    <tr>
      <td >
        90
      </td>
      
      <td >
        143.13
      </td>
    </tr>
    
    <tr>
      <td >
        100
      </td>
      
      <td >
        148.75
      </td>
    </tr>
    
    <tr>
      <td >
        110
      </td>
      
      <td >
        153.72
      </td>
    </tr>
    
    <tr>
      <td >
        120
      </td>
      
      <td >
        158.21
      </td>
    </tr>
    
    <tr>
      <td >
        130
      </td>
      
      <td >
        162.33
      </td>
    </tr>
    
    <tr>
      <td >
        140
      </td>
      
      <td >
        166.16
      </td>
    </tr>
  </table>
</div>

75 degrees is included here because that's the default FOV for a lot of the DCS simulations.  The triplehead FOV of this (133 degrees) winds up being very close to the value that I figured out by eyeballing it (which was 135 degrees), so I'm fairly happy this is accurate.