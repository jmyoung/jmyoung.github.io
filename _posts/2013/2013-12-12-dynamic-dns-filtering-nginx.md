---
id: 706
title: Dynamic DNS filtering for NGINX
date: 2013-12-12T09:25:24+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=706
permalink: /2013/12/dynamic-dns-filtering-nginx/
categories:
  - Technical
tags:
  - linux
  - nginx
---
[Nginx](http://nginx.org/en/) is something that I've really come to appreciate since I moved my blog across to my own server.  However, it's lacking a really great feature that I would love to have - the ability to dynamically update rules through DNS resolution.  I don't have a static IP address for my home Internet connection, but I do use dynamic DNS.

In its default configuration, Nginx can't do this (largely for performance reasons).  There are modules available for Nginx for this ([like this](https://github.com/flant/nginx-http-rdns)), but I didn't want to use one because there isn't a whole lot of point.  So I made my own.

Nginx configurations revolve around include files.  What if we had a scripted process that generates an include file based on a DNS resolve and then reloads Nginx?  That's exactly what I did.

Firstly, let's assume the dynamic DNS record of your home connection is myhome.local .  Make a script in /etc/cron.daily or /etc/cron.hourly (depending how often you want nginx to reload, don't do it too often);

<pre>#!/bin/bash
host myhome.local | grep "has address" | sed 's/.*has address //' | awk '{print "allow\t\t" $1 ";\t\t# Home IP" }' &gt; /etc/nginx/conf.d/homeip.inc
service nginx reload &gt; /dev/null 2&gt;&1</pre>

Now, when that script runs, a file will be created at /etc/nginx/conf.d/homeip.inc that looks like this;

<pre>allow           192.168.1.1;                # Home IP</pre>

From there, it's a simple matter to make an Nginx rule to let things coming from that IP through, for example;

<pre>location /zomgitworks {
    include /etc/nginx/conf.d/homeip.inc;
    deny all;

    alias /var/www/html/zomgitworks;
}</pre>

And now when you call http://yournginxbox/zomgitworks, you will get a 200 OK and content when you're on your home IP, or a 403 Forbidden if you're not.  Notably, if the DNS name doesn't resolve for some reason, the generated file is blank so it does the right thing anyway (it just denies all access).

Of course, if your home IP changes, the rule will break until the next time the cron job runs.  You can run it yourself, of course.  So this won't be suitable for things that change IP a lot (you should use the module for that), but it should be fine for things that change IP infrequently.