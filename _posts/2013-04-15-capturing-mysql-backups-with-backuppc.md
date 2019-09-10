---
id: 133
title: Capturing MySQL Backups with BackupPC
date: 2013-04-15T11:44:41+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=133
permalink: /2013/04/capturing-mysql-backups-with-backuppc/
categories:
  - Technical
tags:
  - backup
  - linux
  - mysql
---
BackupPC with its default configuration will catch the MySQL databases, but I don't consider that kind of backup to be particularly reliable.  Much safer is to do a mysqldump of any relevant databases and then capture that with BackupPC.

Firstly, you'll need to create a special user on your MySQL install who will be used to do the backups.  Do this in mysql as root.  We'll assume the database you want to back up is **your_database**, and the backup user will be **backup**.

<pre>GRANT USAGE ON *.* TO <a href="mailto:backup@localhost">backup@localhost</a> IDENTIFIED BY 'passwordgoeshere';
GRANT SELECT,LOCK TABLES ON your_database.* to backup@localhost;
FLUSH PRIVILEGES;</pre>

At the end of that, you'll have a new user.  Now, in the home directory of the account which will run mysqldump (we'll assume this is **backup**), create a file .my.cnf by running the following commands;

<pre>sudo -u backup bash
cd
cat &gt; ~/.my.cnf &lt;&lt; EOF
[mysqldump]
user = backup
password = passwordgoeshere
EOF
chmod og= .my.cnf</pre>

This will let your backup user run mysqldump.  Now, we'll test it;

<pre>sudo -u backup bash
cd
mysqldump -u backup -h localhost your_database | gzip &gt; test.sql.gz</pre>

You should wind out with a test.sql.gz which will be a dump of all the commands necessary to rebuild that database.  Now we create a new script as backup to manage our backups;

<pre>sudo -u backup bash
cd
mkdir your_database
<strong>[Create the mysql_backup script below]</strong>
chmod u+x ~/mysql_backup</pre>

The script you want to create is;

<pre>#!/bin/bash
DBNAME=your_database
HOME=/home/backup
FILENAME=$HOME/$DBNAME/`date "+%Y%m%d.%H%M%S"`.sql.gz
mysqldump -u backup -h localhost $DBNAME | gzip &gt; $FILENAME
chmod og= $FILENAME
find $HOME/$DBNAME -name "*.sql.gz" | sort -r | tail -n +8 | xargs rm -f</pre>

That will make a backup of your database and then throw it into the folder we created.  It will keep the 7 latest backups, and delete any older ones.  You can then back that up with BackupPC and get a consistent backup.

The last step is to add it to your crontab;

<pre>crontab -u backup -e
0 0 * * * /home/backup/mysql_backup
<strong>[Ctrl-D]</strong></pre>

And that will make the backup run at midnight each night.  Enjoy!