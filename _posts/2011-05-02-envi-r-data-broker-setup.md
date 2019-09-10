---
id: 103
title: 'ENVI-R &#8211; Data Broker Setup'
date: 2011-05-02T06:02:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=103
permalink: /2011/05/envi-r-data-broker-setup/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/05/envi-r-data-broker-setup.html
categories:
  - Technical
tags:
  - envir
  - linux
---
Continuing my previous post on this topic, I realized I needed a message broker in order to permit me to have a daemon polling the [ENVI-R](http://www.currentcost.com/product-envir.html) for data, processing it, and then making it available in a palatable form for various scripts and for [MRTG](http://oss.oetiker.ch/mrtg/).  It would have been possible for me to simply have a cron job dump a summary table to disk every few seconds, but since my Linux box uses a CompactFlash card for disk storage, that would quickly kill the flash chips.  I needed something that held the messages in memory only.  That's where a [MQTT](http://mqtt.org/) message broker steps in.

<a name="more"></a>  
One of my colleagues at work put me on to MQTT, and in particular he put me onto IBM's Really Small Message Broker ([RSMB](http://www.alphaworks.ibm.com/tech/rsmb)).

RSMB is a really tiny implementation of an MQTT compliant message broker.  When they say tiny, they aren't kidding - the broker is a 78k executable which requires an included 73k library.  (config file is optional but a good idea).

**<span>Setup Notes</span>**

Given that RSMB is such a tiny thing, setting it up is very easy.  However, I did a few extra steps to make it a little more secure and integrated;

  * Dump <span>broker</span> (the executable) into <span>/usr/local/bin<span><span>. </span><span></span></span></span>
  * Do the same with <span>stdoutsub</span> and <span>stdinsub</span> .
  * Copy <span>libmqttv3c.so</span> to <span>/lib</span> as <span>libmqttv3c-1.2.0.so</span> and then softlink libmqttv3c.so to it.  This conserves the normal sanity with libraries that ld.so expects, and it should be a bit more maintainable.  Probably not the best way to do things, but it works.
  * Create a new user with no special rights named <span>broker</span>.  After creation, edit <span>/etc/shadow</span> (there's probably a better way to do this) and change the second field on the broker line to *.  That ensures nobody can log in using the account.
  * Create a config file in <span>/usr/local/etc/broker.cfg</span> (config text follows).
  * Create a new directory in <span>/var/local/broker</span> .  chown that directory to <span>broker:broker</span>.
  * Create a new <span>/etc/init.d/broker</span> script and add it to startup with <span>update-rc.d</span> .

The config file contents are;

> <span><span># config file for IBM's RSMB (Really Small Message Broker)</span></p> 
> 
> <p>
>   <span>port 1883</span><br /><span>max_inflight_messages 500</span><br /><span>max_queued_messages 3600</span><br /><span>persistence_location /var/local/broker/</span></span>
> </p></blockquote> 
> 
> <p>
>   The init.d script is;
> </p>
> 
> <blockquote>
>   <p>
>     <span><span>#!/bin/bash</span><br /><span>### BEGIN INIT INFO</span><br /><span># Provides:          broker</span><br /><span># Required-Start:    $network $local_fs</span><br /><span># Required-Stop:     $network $local_fs</span><br /><span># Default-Start:     2 3 4 5</span><br /><span># Default-Stop:      0 1 6</span><br /><span># Should-Start:      broker</span><br /><span># Should-Stop:       broker</span><br /><span># Short-Description: start really small message broker (broker)</span><br /><span>### END INIT INFO</span></p> 
>     
>     <p>
>       <span>pushd /usr/local/bin</span><br /><span>su -c "nohup /usr/local/bin/broker /usr/local/etc/broker.cfg >> /dev/null &" broker</span><br /><span>popd</span></span>
>     </p></blockquote> 
>     
>     <p>
>       <b><span>Testing the Install</span></b>
>     </p>
>     
>     <p>
>       Broker comes with a couple of other binaries, which can be used to publish messages to a channel, and also to view messages on a channel.  Testing broker is quite easy.
>     </p>
>     
>     <ul>
>       <li>
>         Start up broker either manually (good idea the first time) or with the init.d script.
>       </li>
>       <li>
>         In one window, run <span>stdoutsub example</span> to start listening on channel "example".
>       </li>
>       <li>
>         In another window, run <span>stdinpub example</span> and then start typing in lines.  You should see each "message" you enter appear on the stdoutsub window.
>       </li>
>       <li>
>         If you do, great.  If you don't, verify that the ports are all OK and opened on your firewall (if any).
>       </li>
>     </ul>
>     
>     <p>
>       <b><span>Next Steps</span></b>
>     </p>
>     
>     <p>
>       Right, getting the broker up provides the underpinning that gets used by the rest of the software that I'm discussing
>     </p>
>     
>     <p>
>       From <a href="http://www.cpan.org/">CPAN</a>, you'll need to go and install <a href="http://search.cpan.org/~njh/WebSphere-MQTT-Client-0.03/lib/WebSphere/MQTT/Client.pm">Websphere::MQTT</a> - that's the CPAN module for interfacing with IBM Websphere's MQTT implementation.  But because it's MQTT compliant, it'll work just fine with RSMB.  That module will be used fairly heavily in the other scripts.  You'll also need <a href="http://search.cpan.org/~cook/Device-SerialPort-1.04/SerialPort.pm">Device::SerialPort</a> and <a href="http://search.cpan.org/~rdf/Clone-0.31/Clone.pm">Clone</a> , for other parts of the scripts.
>     </p>
>     
>     <p>
>       Followup posts will be outlining how to set up <a href="http://www.acme.com/software/thttpd/">THTTPD</a> and <a href="http://oss.oetiker.ch/mrtg/">MRTG</a>, and then tying it all together with Perl and Bash glue.
>     </p>