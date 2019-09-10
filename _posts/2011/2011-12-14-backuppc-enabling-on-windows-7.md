---
id: 55
title: 'BackupPC &#8211; Enabling on Windows 7'
date: 2011-12-14T04:21:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=55
permalink: /2011/12/backuppc-enabling-on-windows-7/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - DW
blogger_permalink:
  - /2011/12/backuppc-enabling-on-windows-7.html
categories:
  - Technical
tags:
  - backup
---
By default, Windows 7 will not allow access to the C$ administrative share, so you'll have trouble getting BackupPC to work.  To solve this, run up Registry Editor and set the following registry key;

> HKEY\_LOCAL\_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\LocalAccountTokenFilterPolicy

To the REG_DWORD (32-bit) value of 1.

Source:  <http://www.howtogeek.com/howto/windows-vista/enable-mapping-to-hostnamec-share-on-windows-vista/>