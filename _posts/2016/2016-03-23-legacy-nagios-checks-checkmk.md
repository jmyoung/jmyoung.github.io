---
id: 860
title: Legacy Nagios checks with CheckMK
date: 2016-03-23T15:15:43+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=860
permalink: /2016/03/legacy-nagios-checks-checkmk/
categories:
  - Computers
  - Technical
tags:
  - checkmk
  - linux
  - nagios
---
I've recently started converting my old Nagios installs across to using [CheckMK](http://mathias-kettner.com/check_mk.html).  As part of this, I have a collection of old Nagios checks that I want to be able to use verbatim in CheckMK as [legacy checks](http://mathias-kettner.com/checkmk_legacy_checks.html).  Here's how you do that.

After you create your site using OMD, go into the site with 'su - <sitename>'.  Then, edit etc/check_mk/main.mk and add something like this;

<pre>legacy_checks = [
  ( ( "check_solar!250!100", "Solar Output", True), [ "inverter" ] ),
]

extra_nagios_conf += r"""
  # 'check_solar' - Checks status of solar array
  # ARG1 = Warning level
  # ARG2 = Critical level
  define command{
    command_name check_solar
    command_line $USER2$/check_solar $ARG1$ $ARG2$
  }
"""</pre>

Now, put your script (in this case it's check_solar) into local/lib/nagios/plugins/ .  What's going on here is this;

  * Define a legacy Nagios check calling the command **check_solar** with parameters 250 and 100.  The check will have a description of **Solar Output**, outputs performance statistics, and will be assigned to the host named **inverter**.
  * Define a chunk of legacy Nagios config defining the **check_solar** command.

Then, go into your inverter host, edit services, and the manual service should appear.  Save config and you're done!  Pretty easy.

&nbsp;

&nbsp;