---
id: 115
title: WIDCOMM Bluetooth = Crap
date: 2007-03-23T04:26:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=115
permalink: /2007/03/widcomm-bluetooth-crap/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2007/03/widcomm-bluetooth-crap.html
categories:
  - Technical
---
So, I got hold of an [i-Mate Smartflip](http://www.imate.com/t-DETAILS_SMARTFLIP.aspx) smartphone for work, and wanted to configure it for ActiveSync over Bluetooth. I've got a [Compaq nc8430](http://www.notebookreview.com/default.asp?newsID=3217) laptop. Here's where the fun begins.

In a nutshell, ActiveSync doesn't work using the default WIDCOMM Bluetooth stack that comes with the HP. And the Bluetooth chip that's on the nc8430 doesn't work with Microsoft's Bluetooth stack (that comes with Windows XP SP2).

That's not <span>entirely</span> true. The chip is completely compatible with Microsoft's Bluetooth driver and stack. It's just not in the INF file, so the MS driver won't install. To fix, we crack out Notepad, open up C:\WINDOWS\INF\BTH.INF, and add in a line for the transceiver, as follows;

> <span></span><span>[HP.NT.5.1]</span>  
> <span>"HP USB BT Transceiver [1.2]"= BthUsb, USB\Vid_03F0&Pid_0C24</span>  
> <span>"HP Integrated BT Transceiver [2.0]"= BthUsb, USB\Vid_03F0&Pid_171D</span>

<span></span>The bolded part is the bit you add. This then allows the Microsoft Bluetooth driver to think that the BT chip in the nc8430 is compatible, and then allows you to install it (when you select Advanced and pick the driver). When you go and install the driver again, the Microsoft Bluetooth stack installs itself and you're rolling.

Once that's done, create an incoming COM port on your laptop. Then turn on discovery, and in ActiveSync on the phone, tell it to connect via Bluetooth, and follow the instructions to pair. Fixed.

Of note, the Microsoft stack doesn't seem to work too well with the [Nokia 6230i](http://www.cnet.com.au/mobilephones/phones/0,239025953,240055724,00.htm). You need to use the WIDCOMM stack for that.