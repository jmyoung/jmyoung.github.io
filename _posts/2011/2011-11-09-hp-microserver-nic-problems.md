---
id: 58
title: 'HP Microserver &#8211; NIC Problems'
date: 2011-11-09T01:13:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=58
permalink: /2011/11/hp-microserver-nic-problems/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/11/hp-microserver-nic-problems.html
categories:
  - Technical
tags:
  - linux
---
I came across a peculiar bug with my CentOS build, which apparently also happens with Fedora, RHEL and Debian, but mysteriously didn't happen with my Ubuntu install.

In short, sometimes when I reboot, my network card starts up, but doesn't pass packets.  Grepping dmesg shows "<span>ADDRCONF(NETDEV_UP): eth0: link is not ready</span>", which never gets followed up with a ready.  Doing a **<span>service network restart</span>** usually solves the problem, but that's no good for something that's remote control only.

The solution (for now), appears to be to add the following into a new file in <span>/etc/modprobe.d/tg3.conf</span>; 

> <span>install tg3 /sbin/modprobe broadcom; /sbin/modprobe --ignore-install tg3<br />remove broadcom /sbin/modprobe -r tg3; /sbin/modprobe --ignore-remove -r broadcom</span>

It appears that the force install of the broadcom driver does "something" that allows the tg3 driver to actually work properly.  After doing this, I've rebooted my Microserver a few times and it's come up fine each time.  <span>dmesg</span> results for the tg3 driver now look a lot more normal.

**Edit 9th May 2012: ** Turns out that this fix didn't actually fully resolve the problem for me.  But what has resolved the problem entirely is putting the following script into /etc/rc.local so it gets run after boot;

> <span>#!/bin/bash<br /># Restarts NIC if the link did not come up properly</p> 
> 
> <p>
>   function testnic()<br />{<br />        local result=`dmesg | grep ADDRCONF | tail -1 | grep "link becomes ready"`<br />        if [ "$result" != "" ]; then<br />                # echo NIC is available<br />                testnic=0<br />        else<br />                #echo NIC is unavailable<br />                testnic=1<br />        fi<br />}</span><br /><span><br /></span><br /><span>for i in {1..5}; do<br />        testnic<br />        if [ "$testnic" = "0" ]; then<br />                echo NIC is available.  Exiting.<br />                break<br />        else<br />                echo NIC is unavailable.  Restarting.<br />                /sbin/ifdown eth0<br />                /sbin/ifup eth0</span><br /><span>                /bin/sleep 3<br />        fi<br />done</p> 
>   
>   <p>
>     exit $testnic</span>
>   </p></blockquote> 
>   
>   <p>
>     The above solution is horribly rough and I hate it, but it does the job.  It basically just tries restarting eth0 up to five times if it doesn't report as up.
>   </p>