---
id: 904
title: 'If you&#8217;re using MythTV 0.28 on Ubuntu 16.04 &#8230;'
date: 2016-06-02T19:49:00+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=904
permalink: /2016/06/youre-using-mythtv-0-28-ubuntu-16-04/
categories:
  - Technical
tags:
  - linux
  - mythtv
format: aside
---
... you'll want to know about [this bug](https://code.mythtv.org/trac/ticket/12713).  Put the following string in the end of your /etc/mysql/conf.d/mythtv.cnf ;

<pre class="wiki">sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION</pre>

You may also want to try;

<pre class="wiki">sql_mode=NO_ENGINE_SUBSTITUTION</pre>

Fixed?