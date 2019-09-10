---
id: 1090
title: AussieBroadband CheckMK Plugin
date: 2018-09-12T10:11:16+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=1090
permalink: /2018/09/aussiebroadband-checkmk-plugin/
categories:
  - Computers
  - Technical
tags:
  - checkmk
  - linux
  - nagios
  - python
---
I've recently changed my ISP to AussieBroadband.  Since I'm now working under a quota, I want a way to monitor my quota in [CheckMK](https://mathias-kettner.com/index.html).  Enter a bit of python.  If you want to use this, you'll need to adjust the hashbang to suit your actual OMD site, and then pass a parameter which is your username:password to get onto your ABB account.

<pre class="wp-block-preformatted">#!/omd/sites/checkmk/bin/python2.7<br />#<br /># Parses AussieBroadband Quota Page to generate a CheckMK alert and stats pages<br />#<br /><br />import requests<br />import re<br />import time<br />import sys<br />import json<br /><br />status = 0<br />statustext = "OK"<br /><br />try:<br />    creds = sys.argv[1].split(":")<br /><br />    # Create a new session<br />    s = requests.Session()<br /><br />    # Process a logon<br />    headers = {<br />        'User-Agent': 'abb_usage.py'<br />    }<br />    payload = {<br />        'username': creds[0],<br />        'password': creds[1]<br />    }<br />    s.post('https://myaussie-auth.aussiebroadband.com.au/login', headers=headers, data=payload)<br /><br />    # Fetch customer data and service id<br />    r = s.get('https://myaussie-api.aussiebroadband.com.au/customer', headers=headers)<br />    customer = json.loads(r.text)<br />    sid = str(customer["services"]["NBN"][0]["service_id"])<br /><br />    # Fetch usage of the first service id<br />    r = s.get('https://myaussie-api.aussiebroadband.com.au/broadband/'+sid+'/usage', headers=headers)<br />    usage = json.loads(r.text)<br />    quota_left = usage["remainingMb"]<br />    quota_up = usage["uploadedMb"]<br />    quota_down = usage["downloadedMb"]<br /><br />    # Derive some parameters for the check<br />    total = quota_left + quota_up + quota_down<br />    critthresh = 0.10*total<br />    warnthresh = 0.25*total<br /><br />    # Determine the status of the check<br />    if quota_left &lt; critthresh:<br />        status = 2<br />        statustext = "CRITICAL"<br />    elif quota_left &lt; warnthresh:<br />        status = 1<br />        statustext = "WARNING"<br /><br />    # Format the output message<br />    print "{7} - {1} MB quota remaining|left={1};{2};{3};0;{4}, upload={5}, download={6}".format( \<br />        status, \<br />        int(quota_left), \<br />        int(warnthresh), \<br />        int(critthresh), \<br />        int(total), \<br />        int(quota_up), \<br />        int(quota_down), \<br />        statustext)<br /><br />except:<br />    print "UNKNOWN - Unable to parse usage page!"<br />    status = 3<br />    statustext = "UNKNOWN"<br /><br />sys.exit(status)</pre>

Enjoy.&nbsp; It's pretty quick and dirty, but it works.&nbsp; You put this into your site's local/lib/nagios/plugins directory, then add it as a classical check.