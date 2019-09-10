---
id: 762
title: 'A minimalist Google Authenticator &#8211; in Python!'
date: 2014-06-27T22:30:11+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=762
permalink: /2014/06/minimalist-google-authenticator-python/
categories:
  - Technical
tags:
  - linux
  - security
---
So, after an argument with someone about how RFC6238 authenticators work (ie, the authenticator does not need to know any detail or be able to communicate with the service being authenticated to), I decided to cobble together a highly minimalist (and functional) Authenticator which spits out tokencodes that are compatible with Google Authenticator, in Python.

Just run this with the relevant secret key as a command-line parameter and you'll get your tokencodes.

<pre>#!/usr/bin/python
import time
import struct
import hmac
import hashlib
import base64
import sys

# derive components
secretkey = base64.b32decode(sys.argv[1])
tm = int(time.time() / 30)

# convert timestamp to raw bytes
b = struct.pack("&gt;q", tm)

# generate HMAC-SHA1 from timestamp based on secret key
hm = hmac.HMAC(secretkey, b, hashlib.sha1).digest()

# extract 4 bytes from digest based on LSB
offset = ord(hm[-1]) & 0x0F
truncatedHash = hm[offset:offset+4]

# get the code from it
code = struct.unpack("&gt;L", truncatedHash)[0]
code &= 0x7FFFFFFF;
code %= 1000000;

# print code
print "%06d" % code</pre>

Enjoy!