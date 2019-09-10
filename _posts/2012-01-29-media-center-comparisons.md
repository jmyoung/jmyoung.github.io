---
id: 52
title: Media Center Comparisons
date: 2012-01-29T03:51:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=52
permalink: /2012/01/media-center-comparisons/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2012/01/media-center-comparisons.html
categories:
  - Computers
tags:
  - htpc
  - mediaportal
---
I've either tested or used for an extended period of time several different media center products for the PC, so I thought I'd write some opinions I have about each one of them.  Take this with a grain of salt, since everyone's requirements and aesthetic tastes are different.

For each media center product, I've included a few plugins or other software that I've considered mandatory to the product.

<span><b>Windows 7 Media Center</b></span>  
URL:  Built into Windows 7 Ultimate Edition  
O/S:  Windows 7 32-bit  
EPG:  [IceTV](http://www.icetv.com.au/)  
Plugins:  [MediaBrowser](http://www.mediabrowser.tv/), [DVRMS Toolbox](http://babgvant.com/files/folders/dvrmstoolbox/default.aspx), [ShowAnalyzer](http://www.dragonglobal.biz/showanalyzer.html)

The default Media Center product you'll have available when using Windows 7.  Functional and fairly reliable, WMC7 is pretty low on the feature list out of the box.  I used this for a long time, and it was easy to work.

Unfortunately though, it's not very configurable, and you'll need a lot of plugins to get it working properly.  MediaBrowser is an excellent product for organizing your movies and TV series and downloading fanart / covers / other metadata for them.  DVRMStoolbox & ShowAnalyzer are pretty much mandatory to get commercial skipping working.

One significant con with using WMC7 is that it by default records everything in the proprietary WTV format, which not a lot of commercial analyzers and video editors can actually read.  You can convert from WTV to other formats using Microsoft's wtvconvert utility, but it would be nice for it to just record in mpeg or something instead.

You can connect Media Extender appliances and XBOX360/PS3's to a WMC7 install, but you cannot connect another Windows PC to a WMC7 install for watching live tv.  You can however share all the folders that you have media in and just point your second PC at it, but it's not very optimal.

You can use the over-the-air EPG with WMC7, but it's not advised.  You pretty much have to use IceTV in Australia, which provides a good quality EPG for use, along with a plugin that allows you to set recordings via the IceTV website.

The big catch with IceTV is that they only set the program start/end times on the quarter-hour boundaries, which means that you will need to set a fairly lengthy pre-record and post-record time to make sure you actually catch all of your shows.  Other than that, IceTV is good, but expensive.

<span><b>XBox Media Center</b></span>  
URL:  <http://xbmc.org/>  
O/S:  Windows 7 32-bit (and others)

XBMC is a good looking media player.  I discounted it very early in the piece because it can't utilize TV tuners to do recording.  It's only for playback.

<span><b>MythTV</b></span>  
O/S:  [Fedora 16 64-bit](http://fedoraproject.org/)  
EPG:  [Shepherd](http://svn.whuffy.com/)

Full-featured Linux-based media center solution.  Looks great with the Mythbuntu theme, and comes with grabbers to fetch TV show and movie metadata and such.  It also acts in a backend/frontend architecture, so you can run multiple frontends on different PCs to watch live TV from multiple places - something you can't do with Windows Media Center.

The Shepherd EPG only runs on Linux and is a scraper to derive EPG data direct from the providers.  It's free, and it tends to have much more precise timing than IceTV does.

A major point in MythTV's favor is that it has an extremely detailed scheduling system.  You can set schedules according to some pretty complex search criteria and such in order to get exactly what you want.  It also provides a web interface direct to your MythTV box for reviewing the EPG and setting recordings, which is very, very handy.  It also makes its recordings in plain MPEG-2 format, for easy editing.

The main issues that I had with MythTV is that the nvidia driver I have was very poor at dealing with corruption in the incoming video signal (resulting in a storm of blockiness with any issues), and that the drivers for the USB tuners I have frequently would break on coming out of sleep, resulting in loss of tuners.  I also had some other issues that were hardware related, but I won't hold that against MythTV.

<span><b>MediaPortal</b></span>  
O/S:  Windows 7 32-bit (and others)  
EPG:  [IceTV](http://www.icetv.com.au/) or [Shepherd](http://svn.whuffy.com/) (with work!)  
Plugins:  MP-TVseries, Moving Pictures, ForTheRecord, ComSkip

MediaPortal is a competitor for XBMC and WMC7, and is quite popular.  It's come a long way in the last few years since I tried it last.  The default skin looks good, and it also works in a front-end / back-end architecture.  You can run multiple frontends by installing the MediaPortal client on other PCs and watch live TV through your HTPC.

By default it's pretty plain, but with the addition of a few plugins you can get all the functionality you need pretty easily.  The default over-the-air EPG is as usually pretty terrible, but you have the ability to use IceTV (with no IceTV Interactive functionality!).  Or, with some trickery it's possible to use Shepherd if you have a Linux box around (hello, HP Microserver) to do the grabbing for you and generate the appropriate xmltv output to go into MediaPortal.

MP-TVseries and Moving Pictures are compementary plugins to organize your TV shows and movies and fetch metadata / art for them.  They work well out of the box, although you may have to play with the naming of your media a bit to make them work 100% properly.  I haven't figured out how to get MP-TVseries and Moving Pictures working on a remote client yet.

ComSkip is a common commercial analyzer.  Since MP records in plain MPEG-2 Transport Stream (.ts) format, ComSkip can analyze it just fine for commercials.  Get a good INI file for it.

ForTheRecord is a plugin replacement for MediaPortal's default scheduler.  It makes the scheduler _vastly_ more powerful, and also provides a remote administration tool for setting up recordings and reading the EPG.  You'll have to find some way to drop your EPG tvguide.xml into ForTheRecord's XMLTV folder for it to actually read it in though (more on that later.  With FTR in place, MP's scheduling capabilities rival MythTV's.

<span><b>Conclusion</b></span>

With the exclusion of XBMC (ruled out because it can't record), all three solutions will work as a media center.  Currently I'm using MediaPortal, and I really like it how I can run a remote MediaPortal client on Windows PCs to watch live TV - something you can't do with Windows Media Center.

Windows Media Center has some advantages in easy of setup and use, however.  MythTV has advantages in customizability and cost (no Windows license required!).  But WMC uses a proprietary .WTV format, and MythTV has some issues with Linux device drivers.