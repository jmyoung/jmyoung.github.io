---
id: 10
title: Getting data from HWiNFO64 to Nagios
date: 2013-01-02T02:12:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=10
permalink: /2013/01/getting-data-from-hwinfo64-to-nagios/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2013/01/getting-data-from-hwinfo64-to-nagios.html
categories:
  - Technical
tags:
  - nagios
---
As discussed, I recently setup [Nagios](http://www.nagios.org/) for monitoring on my home network.  On my main PC, I use [HWiNFO64](http://www.hwinfo.com/download64.html) for keeping track of CPU temperatures and fan speeds.  I wanted a way to get HWiNFO data into Nagios, and also into Cacti for graphing performance data (in particular, temperatures).

It turns out that HWiNFO64 supports a Vista sidebar gadget.  If you enable this functionality and then enable various sensors to appear in the Gadget, what HWiNFO64 actually does is creates a whole bunch of registry keys and updates those with the appropriate sensor telemetry.  You can then leverage this using [NSClient++](http://www.nsclient.org/nscp/) and an appropriate external check script to get this data into Nagios.

You can get the external check script from my [Google Code repository](http://code.google.com/p/zencoding-blog/source/browse/trunk/scripting/nagios/check_hwinfo.vbs).  This script will go and check any HWiNFO checks you've named and then check them against any warning and critical thresholds you supply.  You'll need to know the SID that your HWiNFO data is under - look in HKEY_USERS using REGEDIT, and find which SID has the \Software\HWiNFO64\VSB key in it.

Now that's in place, you need to edit your nsclient.ini (you did install NSClient++, right?), and add a few things.  This is what you'll need;

<pre>[/settings/NRPE/server]
allow arguments = true

[/settings/external scripts]
allow arguments = true

[/settings/external scripts/wrappings]
vbs=cscript.exe //T:30 //NoLogo scripts\lib\wrapper.vbs %SCRIPT% %ARGS%

[/settings/external scripts/wrapped scripts]
check_hwinfo=check_hwinfo.vbs /sid:"$ARG1$" /sensor:"$ARG2$" /warn:"$ARG3$" /crit:"$ARG4$"</pre>

Now, from your Nagios box, you should be able to run something like;

<pre>/usr/lib64/nagios/plugins/check_nrpe -H YOURWINDOWSHOSTADDRESS -c check_hwinfo -a 'YOURSIDHERE' 'CPU Package,Motherboard,CPU Fan' '70,40,500:' '80,50,100:'</pre>

Your SID should look like 'S-1-5-21-NUMBERS-NUMBERS-NUMBERS-NUMBERS'.  This example above will do the following (note that your text labels in HWiNFO64 must match at least partially what you search for above);

  * Read the 'CPU Package' sensor.  Return CRITICAL if it's 80 degrees or above, WARNING if it's 70 degrees or above
  * Read the 'Motherboard' sensor.  Return CRITICAL if it's 50 degrees or above, WARNING if it's 40 degrees or above
  * Read the 'CPU Fan' sensor.  Return CRITICAL is it's under 100 rpm, or WARNING if it's under 500 rpm

If you see nothing, run check\_nrpe as above, but use the alias\_disk command.  If you see nothing, there's something wrong with your NSClient configuration.  Maybe the service isn't running?  Or maybe you need to restart it?  Firewall issues?

Once that's done, add a check to Nagios as you normally would, and you'll be able to monitor your HWiNFO64 data from Nagios.  Perfdata comes through normally, so you can use that to graph stuff too.

More on pnp4nagios and Cacti shortly.