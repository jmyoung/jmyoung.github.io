---
id: 955
title: 'Bash on Windows &#8211; X Server!'
date: 2016-08-15T10:39:44+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=955
permalink: /2016/08/bash-windows-x-server/
categories:
  - Technical
tags:
  - linux
---
It turns out that you can use Bash on Windows 10 to run X applications, including through ssh tunnels.  Here's how.

First, go and install [XMing](https://sourceforge.net/projects/xming/).  I'd strongly suggest **not** allowing it to get access to your network, so it stays on localhost.  This is so that an attacker can't draw stuff on your screen through your X server.

Run XMing, put it in your startup if you want.  You now have an X server.  Next up, you'll need to fire up Bash on Windows, and run `sudo apt-get install xauth`.  Then edit your ~/.bashrc .  Right down the bottom, add the following;

<pre>export DISPLAY=localhost:0
xauth generate $DISPLAY</pre>

This causes your session to be configured so that you can use X applications and they'll be pointed to your X server.  It also provides the correct X authentication tokens to make things like ssh work.

Now, log out and back in again.  Start up Bash for Windows, then you can run stuff.