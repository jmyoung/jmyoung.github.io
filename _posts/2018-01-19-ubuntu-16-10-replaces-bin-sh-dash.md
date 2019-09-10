---
id: 1052
title: Ubuntu replaces /bin/sh with Dash
date: 2018-01-19T10:24:11+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=1052
permalink: /2018/01/ubuntu-16-10-replaces-bin-sh-dash/
categories:
  - Technical
format: aside
---
Trap for young players.  Ubuntu replaces the default interpreter for /bin/sh from Bash to Dash.  This was done for performance reasons, but certain scripts really don't like this.  You can easily change it back with;

<pre>sudo dpkg-reconfigure dash</pre>

Information about this can be found [here](https://wiki.ubuntu.com/DashAsBinSh).  This was done quite a long time ago, apparently, but for whatever reason scripts that ultimately wind up calling the PHP 7.1 interpreter while under Dash break badly under some circumstances (resulting in PHP segfaulting).

&nbsp;

&nbsp;