---
id: 14
title: 'Pushover &#8211; Easy Notifications'
date: 2012-12-16T11:11:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=14
permalink: /2012/12/pushover-easy-notifications/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2012/12/pushover-easy-notifications.html
categories:
  - Computers
  - Mobile Devices
tags:
  - i9305
  - nagios
---
Recently got myself a new work phone - a [Galaxy S3 4G](http://www.gadgetguy.com.au/product/samsung-4g-galaxy-s3-gt-i9305/).  At the same time, I decided to do some research on what I could do about getting notifications to the phone.  Notifications of things like RAID array problems, stuff going onto UPS power, that sort of thing.

Enter [Pushover](https://pushover.net/).  This thing's pretty awesome.  Basically, you buy the app for whatever device it's going on, and then you sign into their website and get your user key.  From there, you can create an 'application', which is an API key you can use to send notifications from other things.  You can use all sorts of languages to send notifications, and you can even send a special CURL request from a normall shell script to send alerts.  Something like this;

<pre>curl -s -k \
 -F "token=YOURAPIKEYHERE" \
 -F "user=YOURUSERKEYHERE" \
 -F "message=Content Here" \
 -F "title=Title Here" \
 -F "priority=0" \
 https://api.pushover.net/1/messages.json</pre>

<div>
</div>

Fire that off, and tada!  You get an alert to your phone!  It's pretty awesome.  You can also tie it together with [IFTTT](https://ifttt.com/dashboard) to receive notifications from all sorts of things (your favourite RSS feed getting updated, email matching specific criteria landing in your inbox etc).

Give it a go.