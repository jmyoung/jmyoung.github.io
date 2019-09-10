---
id: 630
title: Auto-Restarting a Service with Nagios
date: 2013-06-17T09:50:09+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=630
permalink: /2013/06/auto-restarting-a-service-with-nagios/
categories:
  - Technical
tags:
  - linux
  - nagios
  - nginx
---
I haven't worked out why yet, but this seems to be a common theme - the PHP/FastCGI service dies periodically, which causes outages with my blog (Nginx does not like it if the back end goes away).  So, I need a solution to fix this.  Enter Nagios!

Nagios is able to have customized event handlers.  Those event handlers can be set up to perform any action you want - such as restarting a service.  So, we'll use Nagios to restart the service every time it dies.

First, create a script in /usr/local/lib64/nagios/plugins/eventhandlers/restart-fastcgi ;

<pre>#!/bin/sh
#
# Restarts the php-fpm FastCGI service if it dies
#
# restart-fastcgi $SERVICESTATE$ $SERVICESTATETYPE$ $SERVICEATTEMPT$ $HOSTADDRESS$

case "$1" in
OK)
        ;;
WARNING)
        ;;
UNKNOWN)
        ;;
CRITICAL)
        case "$2" in
        SOFT)
                case "$3" in
                3)
			echo -n "Starting Fast-CGI service (3rd soft critical state)..."
			sudo /sbin/service php-fpm start | /bin/mail -s "[blog.zencoffee.org] FastCGI Restarted" root
			;;
			esac
		;;
	HARD)
			echo -n "Starting Fast-CGI service ..."
			sudo /sbin/service php-fpm start | /bin/mail -s "[blog.zencoffee.org] FastCGI Restarted" root
			;;
	esac
	;;
esac
exit 0</pre>

Ok, now we'll need to configure sudoers to allow the nagios user to run **'service start php-fpm**' without credentials.  Add this to your sudoers with **visudo**;

<pre>Defaults:nagios         !requiretty,visiblepw
Cmnd_Alias      NAGIOS_START_PHPFPM = /sbin/service php-fpm start
nagios          ALL=(root)      NOPASSWD: NAGIOS_START_PHPFPM</pre>

Now, we'll test that we can actually do it.  As root, do this;

<pre>su - nagios
/usr/local/lib64/nagios/plugins/eventhandlers/restart-fastcgi CRITICAL SOFT 3 127.0.0.1</pre>

You should then get an email sent to root saying it's starting the service.  Obviously it won't actually DO it (it's already running).  Check in your /var/log/secure that the sudo command worked.  If so, great!  Now we need to set up Nagios itself to do the restart.

First, we'll define a command to do the restart (note, I use $USER8$ to point to the local event handlers folder);

<pre>define command{
        command_name    restart-fastcgi
        command_line    $USER8$/restart-fastcgi $SERVICESTATE$ $SERVICESTATETYPE$ $SERVICEATTEMPT$ $HOSTADDRESS$
}</pre>

Then we'll add that event handler to the service check we already have in place for checking our FastCGI service;

<pre>define service{
        use                     generic-service
        host_name               yourhostnamehere
        service_description     PHP-FPM Service
        max_check_attempts      4
        event_handler           restart-fastcgi
        flap_detection_enabled  0
        check_command           check_local_procs!0:!1:!RSDT -C php-fpm
}</pre>

After that, everything should work.  Don't forget to restart Nagios.  Specifically, you want max\_check\_attempts to be at least one more than the limit you set in the script, since on the third SOFT failure it will try a restart - you probably don't want Nagios yelling at you about a critical error (and going to a HARD state) before it's tried a restart.  Then again, you might.  Change it as you want.

Now, we can be brave and manually stop the php-fpm service and watch Nagios to see if it restarts.  It should, after a few minutes.  You can tune the script above to make it do the restart faster (on the first soft fail if you want) if you want.

Good luck!