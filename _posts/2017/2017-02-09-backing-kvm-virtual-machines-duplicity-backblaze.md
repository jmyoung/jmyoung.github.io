---
id: 998
title: Backing up KVM Virtual Machines with Duplicity + Backblaze
date: 2017-02-09T09:33:28+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=998
permalink: /2017/02/backing-kvm-virtual-machines-duplicity-backblaze/
categories:
  - Computers
  - Technical
tags:
  - kvm
  - linux
---
As part of my home DR strategy, I've started pushing images of all my virtual machines (as well as my other data) across to [Backblaze](https://www.backblaze.com/) using [Duplicity](http://duplicity.nongnu.org/).  If you want to do the same, here's how you can do it.

First up, you will need a [GnuPG](https://www.gnupg.org/) keypair.  We're going to be writing encrypted backups.  Store copies of those keys somewhere offsite and safe, since you will absolutely need those to do a restore.

Secondly, you'll need a Backblaze account.  Get one, then generate an API key.  This will be comprised of an account ID and an application key.  You will then need to create a bucket to store your backups in.  **Make the bucket private**.

Now that's done, I'm assuming here that you have your /var/lib/libvirt library where your VMs are stored on its own LV.  If this isn't the case, make it so.  This is so you can take a LV snapshot of the volume (for consistency) and then replicate that to Backblaze.

<pre>#!/bin/bash

# Parameters used by the below, customize this
BUCKET="b2://ACCOUNTID:APPLICATIONKEY@BUCKETNAME"
TARGET="$BUCKET/YOURFOLDERNAME"
GPGKEYID="YOURGPGKEYIDHERE"
LVNAME=YOURLV
VGPATH=/dev/YOURVG

# Some other parameters
SUFFIX=`date +%s`
SNAPNAME=libvirtbackup-$SUFFIX
SOURCE=/mnt/$SNAPNAME

# Prep and create the LV snap
umount $SOURCE &gt; /dev/null 2&gt;&1
lvremove -f $VGPATH/$SNAPNAME &gt; /dev/null 2&gt;&1
lvcreate --size 10G --snapshot --name $SNAPNAME $VGPATH/$LVNAME || exit 1

# Prep and mount the snap
mkdir $SOURCE || exit 1
mount -o ro,nouuid $VGPATH/$SNAPNAME $SOURCE || exit 1

# Replicate via Duplicity
duplicity \
 --full-if-older-than 3M \
 --encrypt-key $GPGKEYID \
 --allow-source-mismatch \
 $SOURCE $TARGET

# Unmount and remove the LV snap
umount $SOURCE
lvremove -f $VGPATH/$SNAPNAME
rmdir $SOURCE

# Configure incremental/full counts
duplicity remove-all-but-n-full 4 $TARGET
duplicity remove-all-inc-of-but-n-full 1 $TARGET</pre>

Configure the parameters above to suit your environment.  You can use `gpg --list-keys` to get the 8-digit hexadecimal key ID of the key you're going to encrypt with.  The folder name in your bucket you use is arbitrary, but you should only use one folder for one Duplicity target.  The 10G LV snap size can be adjusted to suit your environment, but it **must be large enough to hold all changes made while the backup is running**.  I picked 10Gb, because that seems OK in my environment.

Obviously this means I need to have 10Gb free in the VG that the libvirt LV lives in.

Retention here will run incrementals each time it's run, do a full every 3 months, ditch any incrementals for any fulls except the latest one, and keep up to 4 fulls.  With a weekly backup, this will amount to a 12 month recovery window, with a 3-monthly resolution after 3 months, and a weekly resolution less than 3 months.  Tune to suit.  Drop that script in `/etc/cron.daily` or `/etc/cron.weekly` to run as required.

**Important**.  Make sure you can do a restore.  Look at the documentation for `duplicity restore` for help.