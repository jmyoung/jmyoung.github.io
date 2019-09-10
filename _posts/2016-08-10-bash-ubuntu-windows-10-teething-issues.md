---
id: 952
title: 'Bash on Ubuntu on Windows 10 &#8211; Teething Issues'
date: 2016-08-10T16:09:30+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=952
permalink: /2016/08/bash-ubuntu-windows-10-teething-issues/
categories:
  - Technical
tags:
  - linux
  - windows
---
Just set up the new Bash on Windows 10 feature that comes with the Anniversary Update.  It's not bad.  But there's a few annoying things it does that grind my gears.

# The default umask is 0000

Yeah.  That's what I said.  This means all files you create from the Bash shell are read/write/execute to EVERYBODY.  Not smart.  SSH hates that.

<pre>echo "umask 0022" &gt;&gt; /etc/profile</pre>

To fix that one.

# Sudo doesn't inherit root's HOME

This causes many commands (pip for example) to dump files into your user directory as root, resulting in an inability to modify files in your own homedir.  Not great.

Add the following in your `/etc/sudoers` somewhere;

<pre>Defaults always_set_home</pre>

More as I come across it.