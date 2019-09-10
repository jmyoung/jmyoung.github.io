---
id: 56
title: BackupPC for MythTV
date: 2011-11-19T07:58:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=56
permalink: /2011/11/backuppc-for-mythtv/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/11/backuppc-for-mythtv.html
categories:
  - Technical
tags:
  - backup
  - mythtv
---
I was having some trouble getting [BackupPC](http://backuppc.sourceforge.net/) to back up my MythTV's operating system to my Microserver.  I kept getting aborts all the time from broken pipes and such.

<div>
</div>

<div>
  <pre>Got fatal error during xfer (aborted by signal=PIPE)</pre>
</div>

<div>
</div>

<div>
  Anyway, the solution turns out to have been <a href="http://adsm.org/lists/html/BackupPC-users/2008-07/msg00166.html">here</a>.  Disable TCP segmentation offloading on the client end, and now it all works!
</div>