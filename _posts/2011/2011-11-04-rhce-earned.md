---
id: 59
title: RHCE Earned!
date: 2011-11-04T03:43:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=59
permalink: /2011/11/rhce-earned/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/11/rhce-earned.html
categories:
  - Computers
  - Other
---
Last week I was sent by my work to do the Red Hat Certified Engineer ([RHCE](http://www.redhat.com/certification/rhce/)) course, which was a compressed 4-day course (cramming in 8 days worth of content into half the time).  It was bundled with the [RHCSA](http://www.redhat.com/certification/rhcsa/) certification at the same time.

Anyhow, after some trepidation (not having used Red Hat for a long time), I went and did the course, picked up all the new stuff, sat the exams, and got 100% for both!

Given this, I figured it would be a good idea for me to keep my newfound skills sharp by swapping over my Microserver to an OS that was more RHEL-like and less Debian-like.  After looking at a couple of options, I wound out settling with [CentOS](http://www.centos.org/).

<a name="more"></a>

CentOS is basically RHEL6, recompiled from source and with the branding stripped.  It's also free (as in beer).  Because CentOS is driven as a community effort, security updates and such will frequently lag behind proper RHEL.  The current version of CentOS is based off RHEL 6.0, whereas the latest version of RHEL is 6.1 .  So there's certainly some advantages to using Red Hat's distribution that should be considered - but in my circumstance, I'm after a RHEL-like OS that's not going to cost me a subscription.

Installation is (as you'd expect) exactly like RHEL6, with the same lurks (SELinux, I'm looking at you!).

I've moved my Microserver across to using CentOS now, so any discussion henceforth will be more CentOS oriented, although things can be hacked about to work on any distro.

A few key changes necessary for the Microserver were to mount /var/tmp as tmpfs as well as /tmp, and turn down/off Apache logging.  I'm still in the discovery phase of working out what's logging / modifying too much data on USB, so I can take care of it.  A big violator at this time is the RPM database, but I expect that's just because I'm fooling with it a lot installing packages.

Besides the base repository that CentOS comes with, you'll probably want [RPMforge](http://wiki.centos.org/AdditionalResources/Repositories/RPMForge) and [EPEL](http://fedoraproject.org/wiki/EPEL/FAQ#How_can_I_install_the_packages_from_the_EPEL_software_repository.3F) at minimum - this will cover off most of the third-party software you may want to install.  There's a yum repository for Mosquitto that you can find as well at [this location](http://download.opensuse.org/repositories/home:/oojah:/mqtt/CentOS_CentOS-6/) too.

So far, everything's going fine.  Keep in mind that because CentOS leaves the root user enabled and by default configures sshd_config to let the root user log in, I would very strongly advise creating a user account for yourself, setting up sudoers appropriately, and then disabling root logins to ssh.  I've been considering locking out root entirely, but I'm not sure what will happen if you have to drop to maintenance mode with that.