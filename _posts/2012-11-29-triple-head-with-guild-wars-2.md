---
id: 18
title: Triple-head with Guild Wars 2
date: 2012-11-29T06:04:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=18
permalink: /2012/11/triple-head-with-guild-wars-2/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2012/11/triple-head-with-guild-wars-2.html
categories:
  - Gaming
tags:
  - guildwars2
  - nvsurround
---
Over the weekend I decided to go and give [Guild Wars 2](https://www.guildwars2.com/en/) a go.  I'd heard some good things about it, and I wanted to try it out since I'm after something that's in the fantasy MMO style, but doesn't attract a subscription fee.

Anyway, I was very surprised and pleased that it _just worked_ with my triple-head monitor setup!  No messing about, I just selected the appropriate resolution, adjusted some of the detail settings down a little, and here we go;

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/4.bp.blogspot.com/-SY-8qvkhCCM/ULbj5OSy5DI/AAAAAAAAAGg/2IjFCFl3Ptc/s1600/normal_uisize.jpg" imageanchor="1"><img border="0" height="75" src="https://i0.wp.com/4.bp.blogspot.com/-SY-8qvkhCCM/ULbj5OSy5DI/AAAAAAAAAGg/2IjFCFl3Ptc/s400/normal_uisize.jpg?resize=400%2C75" width="400"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Click for full size.  It's HUGE.
    </td>
  </tr>
</table>

That JPEG has had its quality dropped a lot to keep it at a semi-reasonable size, so expect artifacts and such.  But it gives you an idea of what the view looks like.  The movies all play correctly (in the center monitor), the UI renders sanely, and the game plays just fine in triple-head.  There's a few minor niggles though;

  * Character creation splashes flicker.  Unknown why.  The mouse isn't aligned properly in those screens.
  * Increasing the UI size from 'Normal' as in the screenshot above to 'Large' or 'Larger' pushes the UI to the right and off the center monitor.  

This is pretty annoying, because my 27" 2560x1440 monitor has a vertical dot pitch of 0.0092", so any UI elements which are fixed in a small number of vertical pixels are REALLY small.  Oh well.

In terms of graphic detail adjustments, I've generally found with games in triple-head you first run out of VRAM before performance on a GTX690.  Running out of VRAM is really easy when you have so many pixels on-screen.  So here's the usual settings that I play with;

  * Vertical sync.  I leave this unset, and then control it through the NVidia Control panel in 'adaptive' mode.
  * Framerate Caps.  If a game has the ability to set a maximum framerate, I set it at 60.  No need to stress hardware when you can only display frames at 60 fps anyway.  It also seems to reduce the micro-stutters you get when you run uncapped.
  * Shadow detail.  This seems to steal a fair bit of VRAM, and usually I don't care much about shadows.  I turn this down to low, but usually not off.
  * Grass/tree detail.  I turn this down a bit if needed.  Games like SWTOR seem to attract a heavy performance penalty for having these up.  Turning them down to half has very little visual effect but greatly improves performance.
  * Antialiasing.  With a high resolution display with a small dot pitch, AA doesn't really offer a whole lot.  It consumes huge amounts of VRAM.  I usually turn this right off.
  * Draw distance.  If you get desperate, reducing draw distance a little can make the difference between filling up your VRAM and running smoothly.

Key signs that you're filling up VRAM are when you move into a new area (ie, new textures), and experience a framerate stutter and then everything runs smoothly again.  In a flight simulator, it can be exhibited by stuttering when close to the ground.

Because of the way that NVidia SLI works, a "4Gb" card actually has 2Gb effective useable, because each GPU (there are two) has to maintain the same VRAM buffer set, and so you can only fit 2Gb of actual textures and other data in there.  That's why it's so easy to run out of VRAM.

Anyway, with a little bit of adjustment, GW2 runs at 50-60 FPS with no stuttering, and still looks really nice.  Now I'm just hoping that the vendor fixes up the UI so that I can increase the UI size and it'll be perfect.