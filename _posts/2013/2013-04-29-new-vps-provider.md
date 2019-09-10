---
id: 306
title: New VPS Provider
date: 2013-04-29T09:34:58+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=306
permalink: /2013/04/new-vps-provider/
categories:
  - Other
tags:
  - backup
  - linux
  - vps
---
Well, cutting off from the old VPS provider and onto a new one was remarkably painless.  The new provider is [Iniz](http://iniz.com/), I picked up a plan for GBP 4.50 a month, that includes 2Gb of RAM, 4 vCPU, 2Gb RAM, 1Gb swap, 100Gb disk, 1Gb/s (max) pipe, and 1Tb of monthly bandwidth.

Considering that a VPS runs a shared kernel (and therefore shared system cache!), the 2Gb memory allocation is actually quite significant since it's only used for applications you run.  The deal seems pretty good, we'll have to see how they go for uptime and networking etc.

There's a (minor!) catch though.  Seems that Iniz doesn't supply reverse DNS functionality, whereas [BitAccel](http://www.bitaccel.com/) did.  Not a huge deal, but having reverse DNS would have been nice.