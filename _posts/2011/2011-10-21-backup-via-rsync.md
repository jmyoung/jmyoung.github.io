---
id: 60
title: Backup via rsync
date: 2011-10-21T05:16:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=60
permalink: /2011/10/backup-via-rsync/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/10/since-my-microserver-keeled-over-and.html
categories:
  - Technical
tags:
  - backup
  - linux
---
Since my Microserver keeled over and died and I didn't have a good backup in place, I was in search of a quick and easy way to back up the USB key on a regular basis so I could recover easily.

The first thing I did was to run a daily cron job to tar up the whole USB key and shove it onto rust somewhere.  This went OK, but it wasn't very elegant.

So, enter the below script.  I got this off a work colleague of mine, and adapted it slightly to suit my purposes...

<a name="more"></a>

> <span>#!/bin/sh<br />#<br /># Script adapted from backup script written by David Monro<br />#<br />SCRIPTDIR=/data/backups<br />BACKUPDIR=/data/backups<br />SOURCE="/"<br />COMPLETE=yes<br />clonemode=no<br />while getopts "d:c" opt<br />do<br />        case $opt in<br />                d) date=$OPTARG<br />                ;;<br />                c) clonemode=yes<br />                ;;<br />        esac<br />done</p> 
> 
> <p>
>   echo $date<br />echo $clonemode<br />if [ "$clonemode" = "yes" ]<br />then<br />        SOURCE="$BACKUPDIR/current/"<br />        COMPLETE=no<br />fi
> </p>
> 
> <p>
>   mkdir -p $BACKUPDIR/incomplete \<br />  && cd $BACKUPDIR \<br />  && rsync -av --numeric-ids --delete \<br />    --exclude-from=$SCRIPTDIR/excludelist \<br />    --link-dest=$BACKUPDIR/current/ \<br />    $SOURCE $BACKUPDIR/incomplete/ \<br />    || COMPLETE=no<br />if [ "$COMPLETE" = "yes" ]<br />then<br />    date=`date "+%Y%m%d.%H%M%S"`<br />    echo "completing - moving current link"<br />    mv $BACKUPDIR/incomplete $BACKUPDIR/$date \<br />      && rm -f $BACKUPDIR/current \<br />      && ln -s $date $BACKUPDIR/current<br />else<br />    echo "not renaming or linking to \"current\""<br />fi</span>
> </p></blockquote> 
> 
> <div>
>
> </div>
> 
> <div>
>   <span><span>What</span><span> this will do is generate a backup named for the current date and time in the specified location.  This script will find the latest current backup, and will then generate a new backup hardlinked to the previous one, saving a LOT of disk space.  Each backup will then only contain the changes made since the last one.</span></span>
> </div>
> 
> <div>
>
> </div>
> 
> <div>
>   <span><span>After running this for a while (about a month), I've now got a 4.6Gb backups folder, with a 1.7Gb base backup - so a month's worth of daily backups has only take up double the space of a single backup.  Note however that there's been some inefficiencies around updatedb that has blown more disk space than otherwise should be th<span>e case.</span></span></span>
> </div>
> 
> <div>
>
> </div>
> 
> <div>
>   <span><span>In order to check the size of each backup, just do a "du -sch *" in the folder your backups are in.</span></span>
> </div>
> 
> <div>
>
> </div>
> 
> <div>
>   <span><span>A very important safety tip.  Since each file is generate through hardlinks, do not under any circumstances try and edit files in the backups.  Let's say you haven't changed /etc/passwd in a long time.  While it looks like you have 30 copies of it, you actually only have one (ie, the hardlink).</span></span>
> </div>
> 
> <div>
>   <span><span> </span></span>
> </div>
> 
> <div>
>   <span><span>If you go and edit /etc/passwd, you will change it on every backup at once, effectively.  So don't do that.  It's safe to just flat-out delete a backup, you won't trash anything.  Just don't edit things.</span></span>
> </div>