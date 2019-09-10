---
id: 61
title: 'HP Microserver &#8211; UpdateDB Bloat'
date: 2011-10-21T05:08:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=61
permalink: /2011/10/hp-microserver-updatedb-bloat/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/10/hp-microserver-updatedb-bloat.html
categories:
  - Technical
tags:
  - backup
  - linux
---
A brief discovery...  If you use a script to back up your Microserver to a mount point somewhere in your filesystem, then your updatedb database will keep growing and growing without bound.  This is bad if you're using a USB key for your root filesystem (I went from writing a 1.5Mb updatedb database once a day to writing a 60Mb one before I caught it).

The solution to this is to edit /etc/updatedb.conf and add the path to where your backups are stored to the PRUNEPATHS option.