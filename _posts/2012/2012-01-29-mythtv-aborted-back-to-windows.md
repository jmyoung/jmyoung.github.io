---
id: 53
title: 'MythTV &#8211; Aborted. Back to Windows.'
date: 2012-01-29T02:35:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=53
permalink: /2012/01/mythtv-aborted-back-to-windows/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2012/01/mythtv-aborted-back-to-windows.html
categories:
  - Computers
tags:
  - htpc
  - mediaportal
---
Well, I gave MythTV a good go, but in the end I had to ditch it.  I had endless problems getting my USB tuners to come back up reliably after sleep, and I also had some strange crashes and other issues.

<div>
</div>

<div>
  For reasons that anyone with a wife and small children will understand, it's a high-severity incident of the worst degree when your media center keels over for some reason in the middle of the day just before nap time.  So, back to Windows.
</div>

<div>
</div>

<div>
  Anyway, I had a few adventures with that - my first Windows install corrupted itself and died after a week, which wound out being because of some bad RAM installed in the HTPC box.  Removed that and rebuilt it again, and it appears OK.  What's notable is that I had that RAM installed when I was running Fedora, which makes me think that perhaps all the problems I was having with MythTV were actually the bad RAM all along...
</div>

<div>
</div>

<div>
  Currently, I'm running with <a href="http://www.team-mediaportal.com/">MediaPortal</a> instead of Windows 7 Media Center, on Windows 7 32-bit.  I've also done some cleverness with <a href="http://svn.whuffy.com/">Shepherd</a> so that I'm able to use the Shepherd EPG on Windows (details to follow).
</div>

<div>
</div>

<div>
  Installation and setup is pretty straightforward for Windows running a Media Center.  I'll give more detail in following posts, but what you'll need is this;
</div>

<div>
  <ul>
    <li>
      Windows 7 32-bit (64-bit will work too, but it's a bit more complicated with codec setup)
    </li>
    <li>
      <a href="http://shark007.net/win7codecs.html">Shark007's codec pack</a> (contains all the codecs you'll need)
    </li>
    <li>
      <a href="http://www.uvnc.com/">UltraVNC</a> (for remote management)
    </li>
    <li>
      Microsoft Hotfix <a href="http://support.microsoft.com/kb/977178">KB977178 </a>(fixes problems with large hard drives vanishing on resume from sleep)
    </li>
  </ul>
</div>

<div>
  After installation, set the following registry keys;
</div>

<div>
</div>

> <span>HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\LargeSystemCache = 1</span> 

> <span></span><span>HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters\Size = 3</span>

<div>
</div>

<div>
  This prevents issues with nonpaged pool exhaustion on Windows 7 when running a media center.  You may also want to look at <a href="http://exilesofthardware.blogspot.com/2009/09/tweakprefetch.html">TweakPrefetch</a>, but SuperFetch is a lot less obtrusive on Win7 compared to Vista, so your mileage may vary.
</div>

<div>
</div>

<div>
  Anyway, I'll write up a brief comparison of four different media center types shortly.  It's a shame to have gotten rid of MythTV since it provided a lot of great features, but I couldn't have my tuners randomly not coming back up when resuming from sleep.
</div>

<div>
</div>