---
id: 910
title: Customizing Unit Files in Systemd
date: 2016-06-14T21:17:15+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=910
permalink: /2016/06/customizing-unit-files-systemd/
categories:
  - Technical
tags:
  - kvm
  - linux
---
On a KVM virtual machine I have, I want to have the MySQL (well, MariaDB) database running on NFS, which means that I need MariaDB to only start up after NFS becomes available.  This would normally require editing the default systemd unit file for MariaDB.  This is a bad idea, since your changes will be reverted every package upgrade.  Here's how to fix that.

Create a new file in /etc/systemd/system/mariadb.service , containing;

<pre>.include /usr/lib/systemd/system/mariadb.service

[Unit]
RequiresMountsFor=/var/lib/mysql</pre>

In this case, I want to import all the settings from the original unit file, but then add an additional requirement - requiring /var/lib/mysql to be mounted.

Once this is done, you have to **disable** and then re-enable that unit.  This causes systemd to redo all of its internal symbolic links to suit your new override file.  If you fail to do this, your override will be ignored.

<pre>systemctl disable mariadb.service
systemctl enable mariadb.service</pre>

If you now do a status on that unit, you should see something like this;

<pre>[root@yourhost ~]# systemctl status mariadb.service
● mariadb.service - MariaDB database server
 Loaded: loaded (/etc/systemd/system/mariadb.service; enabled; vendor preset: disabled)</pre>

Note how the unit file is now originating from /etc/systemd/system/mariadb.service ?  That shows the override has taken.  Also;

<pre>[root@yourhost ~]# systemctl list-dependencies mariadb.service
mariadb.service
● ├─-.mount
● ├─system.slice
● ├─var-lib-mysql.mount
● └─basic.target</pre>

In the list of dependencies, you can see there's a new dependency - the mount target you specified.  Note that in systemd land, mounts specified in /etc/fstab become targets like everything else.  You can even do a status or list-dependencies on them.

Obviously you can apply this to any changes you want to make to the unit files for any service.  Have fun!