---
id: 908
title: Static MAC Generator for KVM
date: 2016-06-07T21:49:16+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=908
permalink: /2016/06/static-mac-generator-kvm/
categories:
  - Other
tags:
  - kvm
  - linux
format: aside
---
The following line will generate (pseudo-randomly) a static MAC address, suitable for use with a KVM virtual machine;

<pre>date +%s | md5sum | head -c 6 | sed -e 's/\([0-9A-Fa-f]\{2\}\)/\1:/g' -e 's/\(.*\):$/\1/' | sed -e 's/^/52:54:00:/'</pre>

Similar nonsense can be done with Hyper-V and VMware.