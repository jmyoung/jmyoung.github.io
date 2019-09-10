---
id: 23
title: Offsite Backups with Amazon S3
date: 2012-10-05T02:40:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=23
permalink: /2012/10/offsite-backups-with-amazon-s3/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2012/10/offsite-backups-with-amazon-s3.html
categories:
  - Technical
tags:
  - backup
---
Recently, I've been worrying about how I have a lot of documentation in my home, and some pieces of it (receipts and other such proof of purchase) would be vital in the event of a disaster such as a house fire, God forbid.  I have a microserver backing up all my electronic documentation, but there's nothing that's offsite in case of such a thing.

What I really need is some way to get my critical documentation and other files out of the house and offsite.  It can just be a simple mirror, since the only purpose of it is for disaster recovery, in the event of the Microserver being unusable (or a lump of slag).  And since it's very, very likely that such a thing will never be used, it needs to be really cheap.

Enter [Amazon Glacier](http://aws.amazon.com/glacier/).  Glacier is Amazon's off-site backup and archival solution.  Dirt cheap storage, but it can cost a fair bit to restore.  I'm not expecting to ever need a restore, so that doesn't fuss me.  But there's no good APIs for it yet, and I'm impatient.  Amazon plans on integrating Glacier into [Amazon S3](http://aws.amazon.com/s3/) as part of the lifecycle management.  This means that for me, S3 is probably the right thing to look at, since I don't have all that much data to store and I can then use existing commands.

## Signing up with Amazon Web Services

Go to [aws.amazon.com](http://aws.amazon.com/) and sign up.  You'll want to pay very careful attention to the costings.  Very careful.  As of now, the costing for storage for the first Tb in the US Standard zone is US$0.093 per Gb per month (at the Reduced Redundancy rate).  This is US$22.32 a year for 20Gb.  Costings for Glacier will be dramatically reduced.

In addition to this, 1,000 PUT, COPY, POST or LIST requests will cost you $0.01 .  This means that backing up enormous numbers of tiny little files may cost you more than you think because of the PUT requests.  GET requests are $0.01 per 10,000 - but for this purpose they're not really relevant.

Data transfer IN to S3 has no charge.  Data transfer OUT of S3 is $0.12 per Gb after the first Gb per month up to the first 10Tb.  For this purpose, free IN transfers are great, and the cost of the OUT transfers doesn't matter much since you won't be pulling data out from it all the time.

Once you're in, you'll want to configure notifications using CloudWatch.

## Configuring an S3 Backup Upload User

In the AWS Console, click Services, then IAM.  Click Users, then Create New Users.  Follow the prompts and then make sure you copy down the Access Key Id and Secret Access Key for your new user.   What we're doing here is creating a user who only has access to S3.

Next, click Groups, Create New Group, and follow the prompts.  You want to create a group using the Amazon S3 Full Access template.  Then, go back to the Users tab, right click on your new user, and assign them to the new group you created.

This user now has full access to the S3 component of your AWS account, but nothing else.

## Installing and configuring S3CMD

I have CentOS, so since I already have the EPEL repositories set up, I just did;

<pre>sudo su -
yum install s3cmd
s3cmd --configure</pre>

Follow the prompts when configuring s3cmd.  You will want to use encryption, and you'll want to use HTTPS.  Note that while s3cmd encryption is not supported with the sync command, it is supported with put, so it's handy for other things.  This will create a config for s3 for the current user, so you should do it as root.

Now, you need to create a bucket to store your data in.  Do something like this;

<pre>s3cmd mb s3://OffsiteMirror-your.domainname.here
s3cmd ls</pre>

You should see the name of the bucket you just created dropped to the console.  You've now got a target to store your offsite mirror to.

## Plan your Sync

By default, S3 storage is private.  But it can be made public.  For this reason, create multiple buckets so your private and public data is separate, and don't make your offsite mirror public!

Keep in mind that the data you're about to mirror will be sent to S3 and will sit on Amazon's servers unencrypted.  Plan your behaviour accordingly.

Lastly, plan out what you want to sync.  We'll assume you're syncing the folder /data/ImportantStuff to S3.

## Syncing a Directory

Run this (or put it in a CRON job or whatever);

<pre>s3cmd sync --rr --delete /data/ImportantStuff/ s3://OffsiteMirror-your.domainname.here/data/ImportantStuff/</pre>

Now, the contents of that folder will be synced up to your S3 bucket, and the folder structure will be conserved inside that bucket.  You will automatically delete files in the bucket prefix that do not exist in the source data.  Note, that this means that anything in /data/ImportantStuff/ that is not in the source will be killed!  The --rr option enforces the use of Reduced Redundancy mode on S3 for reduced costs.

## Conclusions

So far, for what I need, S3 seems to be a workable solution.  I've also got some vital security data being pushed up to S3, but being encrypted first.  Once Glacier integration comes around, I'll be sorted, and can have most of this stuff pushed over to Glacier.

Once I'm more aware of how it's going, I'll probably push all the family photos and stuff like that across to it to make sure we have an offsite clone in case of a big disaster.