---
id: 118
title: NTP Time Synchronization in VI3
date: 2007-03-09T05:31:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=118
permalink: /2007/03/ntp-time-synchronization-in-vi3/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2007/03/ntp-time-synchronization-in-vi3.html
categories:
  - Technical
tags:
  - vmware
---
Time synchronization is of critical importance in a VMWare infrastructure. If it goes wrong, all hell breaks loose, especially in a Windows 200x environment using Kerberos.

Due to how system clocks work in VMWare, this means that you need to use VMWare Tools' sync capability to keep your VMs right on time. This means that all your hosts need to be properly synchronized.

So, how do you do this? If you're using any fancy deployment solution like Altiris, disable time synchronization in it. Why? Because if you don't, you'll forget six months down the track, virtualize your deployment solution, and then wonder why all your clocks go crazy.

Read [this](http://kb.vmware.com/KanisaPlatform/Publishing/408/1339_f.SAL_Public.html) article and implement it. That'll get your NTP daemon sorted out, but that's not quite enough. You need to get your machine's system clock and hardware clock in sync before NTP can slew the clock and keep it synchronized.

In order to do that, get into a console on your VI3 server, and do the following (I assume that firewall.contoso.com is one of your NTP sources, change to suit);

<span></span>

> <span>service ntpd stop</span>  
> <span>ntpdate firewall.contoso.com</span>  
> <span>hwclock --systohc</span>  
> <span>service ntpd start</span>  
> <span>watch "ntpq -p"</span>

<span></span>

That will configure your system and hardware clocks to be close to the NTP source you named, and then start a watch process showing you the state of your NTP peers.

After a while, you should see an asterisk appear next to one of the peers (not LOCAL, that's your host's internal clock). When that happens, you're all good.