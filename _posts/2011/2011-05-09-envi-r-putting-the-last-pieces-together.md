---
id: 99
title: 'ENVI-R &#8211; Putting the last pieces together'
date: 2011-05-09T01:59:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=99
permalink: /2011/05/envi-r-putting-the-last-pieces-together/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/05/envi-r-putting-last-pieces-together.html
categories:
  - Technical
tags:
  - envir
  - linux
---
In my [last post](http://zencoding.blogspot.com/2011/05/envi-r-data-parser.html) about the [ENVI-R](http://www.currentcost.com/product-envir.html) setup, I discussed setting [publish-envir.pl](http://code.google.com/p/zencoding-blog/source/browse/trunk/envir/publish-envir.pl) in order to parse raw serial data from the ENVI-R and post it out to [MQTT](http://mqtt.org/) channels.  In this post, we'll discuss how to get [THTTPD](http://www.acme.com/software/thttpd/) and [MRTG](http://oss.oetiker.ch/mrtg/) going, in order to actually get some useful graphs out there.

<a name="more"></a>  
**<span>Glue Scripts</span>**

MRTG can't use data direct from MQTT, so we need a fairly simple Perl script to pull the MQTT data out and hand it to MRTG in a useable format.  An MRTG "packet" is of the following format;

> <div>
>   <integer representing the "incoming" value>
> </div>
> 
> <div>
>   <integer representing the "outgoing" value>
> </div>
> 
> <div>
>   <integer representing uptime>
> </div>
> 
> <div>
>   <string representing the test value>
> </div>

A response must have four and exactly four lines.  So, our glue script has to haul in data from MQTT and then output four lines for MRTG to use.

Have a read of [mrtg-envir.pl](http://code.google.com/p/zencoding-blog/source/browse/trunk/envir/mrtg-envir.pl) at my GoogleCode repository.  The code there should be fairly self-explanatory.  The only complex bit is CalculateReading, which is a horrible bit of code that tokenizes and parses your input so you can do things like "return the first sensor subtract the second sensor" with "0.1-0.2" and stuff like that.

It's important to note that the script will wait until MQTT publishes a message.  This means that if your [publish-envir.pl](http://code.google.com/p/zencoding-blog/source/browse/trunk/envir/publish-envir.pl) script isn't running, or the ENVI-R isn't working or something, then MRTG will also be held up.

**<span>THTTPD Setup</span>**

Setting up THTTPD is very, very easy.  From Ubuntu, just do this;

> <div>
>   sudo aptitude install thttpd
> </div>
> 
> <div>
>   service thttpd start
> </div>

And that's about it.  By default, it'll share out stuff in /var/www, and has CGI turned off.  You don't need CGI in the short term.  By default it'll also have chroot enabled and will be reasonably secure.  All it can really do is pass out pages, but it has a tiny memory footprint and is very fast.  And for the basic cron-driven MRTG setup, that's all you need.

In order to test, just create something like /var/www/index.html and put the text "Hello world" into it, and make sure you can fetch it.

**<span>MRTG Setup</span>**

MRTG is also very straightforward to set up.  Just <span>sudo aptitude install mrtg</span> to install it.  By the default setup, MRTG will not run as a daemon, it'll run as a cron job executed every 5 minutes.

A warning about MRTG.  MRTG isn't very scalable - you'll want to use <span>rrdtool</span> or <span>cacti</span> if you want something big.  But for something simple, easy to set up, and only for a few samples, MRTG does the job quite nicely.

Have a look at my example [mrtg.cfg](http://code.google.com/p/zencoding-blog/source/browse/trunk/envir/mrtg.cfg) at my GoogleCode repository.  Drop that into /etc/mrtg.cfg and run the following commands and you're sorted;

> <div>
>   sudo su -
> </div>
> 
> <div>
>   mkdir /var/www/mrtg
> </div>
> 
> <div>
>   indexmaker --output=/var/www/mrtg/index.html /etc/mrtg.cfg
> </div>
> 
> <div>
>   env LANG=C /usr/bin/mrtg /etc/mrtg.cfg
> </div>
> 
> <span>exit</span> 

If you now look at the contents of <span>/var/www/mrtg</span>, you should see a number of files, images and the like.  Pop open your web browser and browse to <span>http://<yourserver>/mrtg</span> and you should see some graphs!

**<span>Final Notes</span>**

One thing you'll notice is that the publish script will accumulate a 5-minute moving average, which happily lines up nicely with the sample interval for MRTG.  But the calculated averages for the weekly and monthly graphs are calculated by MRTG, and will often miss out spikes in usage which you may want to see.  Additionally, the linear vertical scale can miss out low levels of base load or make the hard to see  Consider using logarithmic for the vertical scale.

You'll also notice in my GoogleCode repository a very simple CGI script for dumping out the instantaneous data from envir-last.  You'll need to enable CGI on THTTPD for this to work.

All in all, the setup was a good bit of fun and some problem solving, and now I'm collecting some useful electricity data.  Some observations are that careless use of lighting burns a surprising amount of power, and that the aquarium heater for our freshwater turtle was turned up too high and was blowing a lot of power as well.

I'll need to do some baseload analysis of devices on standby, because I still feel that the base load power use is way too high.