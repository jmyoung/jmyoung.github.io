---
id: 57
title: 'From WMC7 to MythTV&#8230;'
date: 2011-11-18T03:18:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=57
permalink: /2011/11/from-wmc7-to-mythtv/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/11/from-wmc7-to-mythtv.html
categories:
  - Computers
tags:
  - htpc
  - mythtv
---
After reading some more about what can be done with [MythTV](http://www.mythtv.org/), I thought I'd take the plunge.  Previously, my Media Center was running Windows 7 Ultimate with Media Center.  I have two Hauppauge HVR-2200 PCI-Express dual tuners, and an nVidia 9500 GT graphics card with HDMI output.  I also have a _huge_ pile of recorded TV in Windows Television (WTV) format, which was quite the obstacle because only Media Center can play that.

So, I decided to settle in with MythTV running on Fedora 15.  There's a heap of build guides on the Web, follow them if you want to do similar.  I'll just mostly talk about the issues I had.

<a name="more"></a>

**<span>Old Recorded TV</span>**

Firstly, I copied off all my previously spooled recorded TV in WTV format and using [VideoRedo](http://www.videoredo.com/), remuxed them into plain MPEG2 Program Stream (.mpg) files, which MythTV (and nearly anything) can play.  At a later time I'll transcode all the things I want to keep to H.264 in an MKV container, but for now I just want everything playable.  VideoRedo can remux a WTV pretty quickly, so I did all that on my main PC while I was messing with the HTPC.

**<span>HTPC Setup - OS Choices</span>**

I decided to go with Fedora 15 x64 instead of 16.  For one, 16 had just been released, and I was concerned there may be setup problems with it.  Fedora 15 is tried and true, and it should just "work".

For a window manager during setup, I did not select Gnome or KDE.  I used XFCE.  I don't see the need for a hugely fat window manager on a media center.  XFCE does the job quite nicely.

For RPM repositories, I elected to use [RPMfusion](http://rpmfusion.org/).  The choice was more stylistic than anything, but it's very much recommended you use either RPMfusion or ATrpms, not both.

After basic setup, I had to head over to linuxtv.org, and follow the setup instructions for my tuners.  Note that Fedora already has the drivers for them all, I just needed to drop the firmware into /lib/firmware .

For the MythTV theme, I used Mythbuntu, primarily because it's clean and easy to navigate, looks acceptable, and not too heavyweight.

**<span>Bzzt!  One tuner down!</span>**

It took me a while to notice, but it turns out that one of my tuners (both are Hauppauge HVR-2200's based off the saa7164 driver) won't load firmware - it says the image is corrupt and therefore doesn't work.  Unfortunately, I don't know if it ever worked under Windows.  It shares an IRQ with the graphics card, which may have something to do with it.

Anyway, after much stuffing about, I've called it a loss and pulled the card.  I've since put in a [Leadtek Winfast DTV Dongle Gold](http://www.leadtek.com/eng/multimedia/overview.asp?lineid=6&pronameid=407) instead to supply a third tuner.  Again, firmware from linuxtv.org and the drivers were already included in Fedora.  It "just worked".

I'll put Hauppauge tuner into one of the main PCs when I next have one out and see if it works at all.  At any rate, it doesn't matter much because MythTV can take two channels out of the one multiplexed stream, and so I can potentially record up to six things at once, on up to three transponders (so, I could do ABC1/ABC2 + 9/GO + 10/ONE or similar).

**<span>Programme Guides</span>**

I was previously a customer of [IceTV](http://www.icetv.com.au/) because they offer an excellent EPG service for WIndows Media Center users.  I definitely recommend them for WMC users.  But now I'm not a WMC user, so I swapped over to [Shepherd](http://svn.whuffy.com/) instead.  Shepherd requires a small amount of setting up, but now it's configured the data I'm getting looks pretty clean and useable.

I'll see how it goes compared to IceTV.

**<span>Autostart Configuration</span>**

In order to get MythTV to autostart on system boot, you configure <span>/etc/gdm/custom.conf</span> , and in the <span>[daemon]</span> block, add the following;

> <div>
>   TimedLoginEnable=true
> </div>
> 
> <div>
>   TimedLogin=mythtv
> </div>
> 
> <div>
>   TimedLoginDelay=0
> </div>

That will make your mythtv user auto-login.  Then, in XFCE, go to Settings -> Session and Startup, and add <span>mythwelcome</span> to the startup.  On boot, your MythTV frontend should start up.

**<span>Auto-Kill Frontend with IR Remote</span>**

First, put irexec -d in your XFCE startup.  That will cause your remote to be operatable outside of Myth.  Well, first set up your remote following the LIRC instructions, but anyway.  Make a .lircrc like this;

> <span>begin</span>  
> <span>    remote = mceusb</span>  
> <span>    prog = irexec</span>  
> <span>    button = Power</span>  
> <span>    config = /usr/local/bin/killmythfrontend.sh</span>  
> <span>    repeat = 0</span>  
> <span>    delay = 0</span>  
> <span>end</span>

And then make that killmythfrontend.sh kill the frontend with "killall mythfrontend".  Now, pressing the Power button your remote will kill your front end instantly.  Mythwelcome should then start it back up again.

**<span>Graphic Artifacts in VDPAU</span>**

I've noticed when using VDPAU (nVidia hardware accelerated video decoding) that I seem to be seeing visual artifacts - specifically glitches of white and red on the surfaces of things that are moving.  When I disable VDPAU I don't see that, but I want to use VDPAU.  So, I've gone and grabbed a new GT520 video card, and I'll see how that goes.  It might also be a driver issue, so I'll have to find out.

**<span>Digital Audio - A Lesson in Pain</span>**

Ouch.  I had a devil of a time getting digital audio working.  I wanted to get digital audio going out my coax port to my amp (which supports DTS).  Sounds pretty easy, right?  Not on your life.

First I got digital audio working!  Yay!  But then I noticed that I couldn't control the volume.  And then I noticed that it was only stereo.  DOH!  Then I got volume control working.  And then I got surround working.  But then I noticed that I couldn't play anything that had AC3 audio.  DOH!  Then I got AC3 working, but then I noticed that the volume control was broken again.

Finally, I gave up and ran the analog output of my HTPC into my amp and just ran off that.  It works great.  Sigh.

What I want to see about doing is whether my TV can do digital passthrough out, because then I could just run the amp from the TV and it would "auto-select" what channel to run off.  I might see about that when I feel up to it.

I imagine half the problem is me just having little understanding of how digital audio works.  I might have to settle with having no volume control off the remote (and only on the amp), and then configure an IR blaster to control the amp volume and mute that way.  That's probably the "right" way.

**<span>Results As Of Now</span>**

As of now, I've got my MythTV box set up so that it can record, play recorded TV, the remote control works, and DPMS monitor suspend is operational so it'll shut down the screen.  My video library has been moved across to it (although I haven't fully done the renaming and metadata collection for everything).  EPG is set up and working.  I still need to get automated sleep and wakeup working.

Still remaining is making another foray into digital audio.  I'm not looking forward to that.