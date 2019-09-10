---
id: 881
title: Blog now uses HTTPS!
date: 2016-04-14T11:36:03+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=881
permalink: /2016/04/blog-now-uses-https/
categories:
  - Other
tags:
  - nginx
---
With the release of [LetsEncrypt](https://letsencrypt.org/) to the public, I've reconfigured my blog server to use HTTPS.  Setup was pretty straightforward, I just followed the [nginx setup guide](https://www.nginx.com/blog/free-certificates-lets-encrypt-and-nginx/).  Notably though, my highly restrictive nginx setup didn't work with the rules they described.  Instead, I needed this fragment to get the Let's Encrypt authentication challenge to pass;



Notably, the certs issued only last for 90 days, so you **will** need some way to renew them automatically.  The above guide has that.

Let's see how it goes.