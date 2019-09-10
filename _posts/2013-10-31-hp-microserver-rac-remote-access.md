---
id: 696
title: HP Microserver RAC Remote Access
date: 2013-10-31T12:49:43+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=696
permalink: /2013/10/hp-microserver-rac-remote-access/
categories:
  - Technical
---
Now that I've got my Microserver's remote access card working, I've spent a bit of time enabling remote access in a reasonably secure fashion.  I found out that you can use SSH to access the RAC, and that its SSH implementation supports port forwarding.  This is exactly what I wanted.

**<span style="color: #ff0000;">NOTE:  If you're setting this up, I'd strongly recommend you forward some other port than 22, and only leave the forward up when you may need to get access to the RAC from outside your firewall.  The OpenSSH implementation in the RAC may have vulnerabilities.</span>**

Anyway, enough with the disclaimers.  In order to set this up, here's what you'll need to do;

  1. Using your router, set up port forwarding from some port (eg, 2222) to port 22 on your Microserver (we'll call it hp-rac here).
  2. If you're running ssh, run the following;  
    ssh -v username@yourrouter -p 2222 -L 80:hp-rac:80 -L 443:hp-rac:443 -L 2068:hp-rac:2068
  3. If you're not running SSH, you will need to configure the following forwards;  
    Local port redirect from local port 80 to hp-rac at port 80  
    Local port redirect from local port 443 to hp-rac at port 443  
    Local port redirect from local port 2068 to hp-rac at port 2068
  4. Log in via SSH.  Now, fire up a web browser, and browse to http://localhost/ .  You should see the RAC login page.
  5. Log into the RAC login page.  Run the vKVM remote console.
  6. When the vKVM remote console loads, it'll _think_ it's connecting to the vKVM at localhost, but it's actually getting pushed straight through to the RAC through the SSH tunnel!

Now, some important security stuff.  The user logon attempt counter you set up in the RAC GUI does not work for SSH, it only applies for GUI logins.  Therefore, you should not use the default administrator name, and you should change its password to something REALLY REALLY hard (20 character maximum).  Additionally, leaving the port forward disabled most of the time would be prudent.

That all said, doing this gives you an easy way into your Microserver remotely if you need to get at it while everything else is down.

PS: You need to have your Java cache enabled (it's on by default) for this to work.