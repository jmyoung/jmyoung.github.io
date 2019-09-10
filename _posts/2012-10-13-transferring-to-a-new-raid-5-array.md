---
id: 22
title: Transferring to a new RAID 5 Array
date: 2012-10-13T09:57:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=22
permalink: /2012/10/transferring-to-a-new-raid-5-array/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2012/10/transferring-to-new-raid-5-array.html
categories:
  - Technical
tags:
  - linux
---
As discussed before, I have a HP Microserver.  Currently it was running my data volume group (vgdata) on a single disk.  Anyway, I finally bit the bullet and bought four 3Tb [Western Digital Red](http://wdc.com/en/products/products.aspx?id=810) drives for it.  Now, I want to re-lay out the four drive slots in my Microserver to be a single RAID-5 array, but I don't want to have to backup/restore the existing VG anywhere.  So here's what I did.

Leaving the 2Tb Seagate in place, I put in the other three WD Reds.  Drive layout is therefore this;

<pre>/dev/sda Seagate 2TB
/dev/sdb Second WD Red
/dev/sdc Third WD Red
/dev/sdd Fourth WD Red
/dev/sde Scratch USB
/dev/sdf Boot USB</pre>

First, we'll create the MDADM RAID set, and move the existing extents on the Seagate drive to it;

<pre>mdadm --create /dev/md0 --chunk=512 --level=raid5 --raid-devices=4 missing /dev/sdb /dev/sdc /dev/sdd
pvcreate /dev/md0
pvscan
vgextend vgdata /dev/md0
pvmove /dev/sda1 /dev/md0</pre>

That will take a LONG time to finish running.  At the end, you'll have all your extents on the raid array (which is technically in degraded mode), so you'll then need to remove the old (redundant) device from the VG;

<pre>vgreduce vgdata /dev/sda1
pvremove /dev/sda1
pvscan</pre>

Now, edit your /boot/grub/grub.conf and add "**bootdegraded=true**" to the kernel options.  This allows MD to start up with a degraded array, which is probably want you want for a non-OS array.

At this point, the Seagate drive can now be removed, and replaced with the new WD Red (which will also become /dev/sda).  Watch out, the deviceID of md0 has probably changed when you rebooted!  Just do a cat /proc/mdstat to see it.

<pre>mdadm --add /dev/md0 /dev/sda</pre>

Wait a minute, then view what's happening;

<pre>cat /proc/mdstat</pre>

The array should now be rebuilding!  Yay!  This will also take ages.  But we're not done yet, not by a longshot.  We currently have the issue where the stride and stripe width of the existing filesystem on vgdata/data is incorrectly configured for the new disk geometry.  Rather than adjust it, we'll instead make a new logical volume and dump/restore all the files into it.  Note - I could have just done the dump/restore directly to a new vg on md0, but I didn't want to leave the array in a degraded state any longer than required.

<pre>yum install dump
lvcreate -l 10000 -n newdata vgdata
mkfs.ext4 /dev/mapper/vgdata-newdata
mount /dev/mapper/vgdata-newdata /mnt
tune2fs -r 0 /dev/mapper/vgdata-newdata
cd /mnt
dump -0uan -f – /data | restore -r -f -</pre>

All done.  Now, in my case, I actually split the volume group by doing several dump/restores so that my previously large vg was divided up into a few separate ones.  The procedure is similar, except instead of using dump, you do something like;

<pre>rsync -av -H --delete --numeric-ids /data/backups /mnt/backups</pre>

Note, this preserves hardlinks.  Since my backup data is made by using BackupPC and a script which generates huge numbers of hardlinks, I really want to keep all the hardlinks.