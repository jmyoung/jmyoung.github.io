---
id: 976
title: NGINX Rate Limiting for Unsecured Apps
date: 2016-11-03T21:53:06+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=976
permalink: /2016/11/nginx-rate-limiting-unsecured-apps/
categories:
  - Technical
tags:
  - nginx
---
Some applications don't properly support IP blackholing in the case of failed login attempts.  There's a few ways to handle that, but one nice way is to make use of nginx in the front of the application to apply rate limiting.

I'm considering using nginx as a reverse proxy for your application here as out of scope for this article.  It's a good idea to get used to using it to front your applications and control access to them.

# Rate Limiting in NGINX

We'll be making use of the [ngx\_http\_limit_req](http://nginx.org/en/docs/http/ngx_http_limit_req_module.html) module.  Simply put, you create a zone using `limit_req_zone`, then define allowed locations that will use the zone using `limit_req`.

The mental abstraction you can use for the zone is a bucket.  The zone definition describes a data table which will hold IP addresses (in this case), and how many requests they've made.  The requests (which are water in the bucket in this analogy) flow out a 'hole' in the bucket at a fixed rate.  Therefore, if requests come in faster than the rate, they will 'fill' the bucket.

The 'size' of the bucket is determined by the parameters you've set on `limit_req` for the allowed burst size.  So a large burst size enables a lot of requests to be made in a time period that exceeds the recharge rate, but it'll fill the bucket up eventually.  They then slowly recharge at the described rate.

**IMPORTANT** - If you do not use the `nodelay` option in `limit_req`, what happens is that nginx delays incoming requests to force them to match the rate - irrespective of bursts.  In this article, we'll use nodelay, because we want to flat out return errors when the burst size is exceeded.

# Configuring Rate Limiting

In the http context of your nginx.conf, insert a zone definition like this;

<pre>limit_req_zone $binary_remote_addr zone=myzone:10m rate=1r/m;</pre>

This defines a new zone named `myzone` which will be populated with the binary forms of remote addresses of clients of size 10Mb.  This will hold a large number of addresses, so it should be fine.  It will recharge limits at a rate of one per minute (which is very slow, but this is intentional, as you'll see).

Then, let's assume your app has a login page that you know is at `/app/login`, and the rest of the app is under `/`.  You could write some locations like this;

<pre>location = /app/login {
    limit_req zone=myzone burst=10 nodelay;

    # whatever you do to get nginx to forward to your app here
}

location / {
    # whatever you do to get nginx to forward to your app here
}</pre>

That way, calls to `/app/login` will be rate limited, but the rest of your app will not.

In the above example, calls to `/app/login` from a single IP will be rate limited such that they can make a burst of 10 calls without limits, but then are limited to an average rate of one per minute.

For something that's a login page, this should be sufficient to allow legitimate logins (and likely with a mistyped password or two), but it'll put a big tarpit on dictionary attacks and the like.