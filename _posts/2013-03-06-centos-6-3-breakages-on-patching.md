---
id: 7
title: CentOS 6.3 Breakages on patching
date: 2013-03-06T04:17:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=7
permalink: /2013/03/centos-6-3-breakages-on-patching/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2013/03/centos-63-breakages-on-patching.html
categories:
  - Technical
tags:
  - linux
---
Not much happening lately.  Recently updated my Microserver to the latest patch revisions for CentOS 6.3, and my that was fun.

SELinux policy changes appear to have broken all sorts of things.  Notably, fail2ban now needs a policy exception for it to even work (it doesn't create iptables rules otherwise).  Great for security, that.

Secondly, the latest kernel is inexplicably missing the ipmi_si.ko module, which is needed for IPMI to work.  I've since had to roll back to an earlier kernel which does have that module.  Apparently this is a known issue.

Lots of fun.