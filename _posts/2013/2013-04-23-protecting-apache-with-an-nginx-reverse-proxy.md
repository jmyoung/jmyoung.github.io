---
id: 157
title: Protecting Apache with an nginx Reverse Proxy
date: 2013-04-23T17:23:23+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=157
permalink: /2013/04/protecting-apache-with-an-nginx-reverse-proxy/
categories:
  - Technical
tags:
  - apache
  - linux
  - nginx
---
[Nginx](http://nginx.org/en/) is a multi-purpose web server / reverse proxy which is commonly used to front busy websites.  It can also be used in reverse proxy mode to help secure websites from unexpected vulnerabilities.  It also allows you to do some pretty cool stuff with redirection and can serve up content all on its own.  In this example, we'll just be using nginx to protect specific content.

As is usual on this blog, I'm assuming you're running CentOS 6.  Installation methods vary for other distributions.

# Architecture

The planned architecture for this project is such that nginx triages requests from the Internet, and then translates and passes those requests to the local Apache web server as required.  Therefore, we have the following setup;

  * nginx listens on port 80 and 443, on the external-facing interface (ie, the one that Internet users will connect to.  Nginx terminates any SSL connectivity at its interface.
  * Apache only listens on localhost (127.0.0.1) port 80.  Specifically, this means that Apache will never directly serve content to anything outside of this machine.
  * Apache can be configured with virtual hosts if this is desirable, but this is unnecessary because we can handle most of the URL translation and virtual hosting tasks internally in nginx
  * nginx will reverse proxy connections from the Internet into the local Apache web server.  This means that nginx needs some way to tell the Apache web server what the real IP address of incoming connections is.  It does this with the X-Forwarded-For header.
  * Your monitoring solution needs some way to cleanly identify whether the thing listening on port 80 is nginx or if it's Apache, in case there's a misconfiguration.

# Installing nginx

Installation of nginx is very easy.  You'll need two main components - nginx itself, and mod_rpaf for Apache.  You will need [EPEL](http://fedoraproject.org/wiki/EPEL) set up in order to install nginx, which you can get from the link.

<pre>yum install nginx</pre>

Once you've got nginx installed, don't start it.  We need to configure a lot of things first.

# Installing mod_rpaf for Apache

In order for your Apache access logs to look normal (ie, not have everything coming from localhost), you'll need to set up [mod_rpaf](http://stderr.net/apache/rpaf/).  mod_rpaf converts the X-Forwarded-For header that was passed in by nginx into what looks like a normal source address for Apache.

In order to build mod_rpaf, you'll need to do a few things.  Unfortunately there's no tidy RPM package that I've found for CentOS 6, so you'll have to build it yourself.

<pre>wget http://stderr.net/apache/rpaf/download/mod_rpaf-0.6.tar.gz
yum install -y httpd-devel 
tar xvfz mod_rpaf-0.6.tar.gz
cd mod_rpaf-0.6
sed -ie 's/apxs2/apxs/' Makefile
make rpaf-2.0
make install-2.0</pre>

After that's done, you can create a /etc/httpd/conf.d/mod\_rpaf.conf with the following content to enable mod\_rpaf and configure it.

<pre>LoadModule rpaf_module modules/mod_rpaf-2.0.so

&lt;IfModule mod_rpaf-2.0.c&gt;
RPAFenable On
RPAFsethostname on
RPAFproxy_ips 127.0.0.1
&lt;/IfModule&gt;</pre>

# Configuring Apache

Configuration changes to Apache are pretty straightforward.  Besides the mod_rpaf config change as above, we need to edit /etc/httpd/conf/httpd.conf and change the listen address like this;

<pre>Listen 127.0.0.1:80</pre>

This will make sure that Apache only listens on port 80 on the loopback interface, and does not listen on the external interfaces.  Restart apache with **service httpd restart** and then try this (assuming your external interface is **www.example.com**)

<pre>telnet www.example.com 80</pre>

You should get no response, which tells you that nothing is listening on port 80.  If you wanted to, you could put Apache on another port (81, say), but I prefer to make it only listen to localhost.

# Configuring nginx

First, some assumptions about the configuration.

  * You want nginx to listen on port 80 only (we'll talk about SSL termination later).
  * You want nginx to only serve requests which have a valid Host header (this is a good idea, since it'll block most exploit bots which hit you by IP address and no host header)
  * You want the URL http://www.example.com/application/ to redirect through to your local Apache instance
  * You want the URL http://www.example.com/image.gif to redirect through to your Apache instance
  * You want the URL http://myblog.example.com/ to redirect to http://localhost/blog on your Apache instance
  * You want the URL http://www.example.com/monitoring to redirect through to Apache, but only for specific IP addresses
  * You want a URL http://www.example.com/nginx-works to return a 200 if nginx is working
  * The IP address of the interface that nginx will listen on is 192.168.1.1

In /etc/nginx/conf.d, move all the files there somewhere else.  We don't want them.  Now, create a new config.conf , and let's get working.

## Defining the listeners

First, the listener.  We define two listeners on port 80 and include a set of locations.  We'll also define a default listener which just rejects everything.

<pre># http://www.example.com/
server {
  listen 192.168.1.1:80;
  server_name www.example.com;
  include /etc/nginx/conf.d/locations-www.inc;
}

# http://myblog.example.com/
server {
  listen 192.168.1.1:80;
  server_name myblog.example.com;
  include /etc/nginx/conf.d/locations-blog.inc;
}

# http://192.168.1.1/
server {
  listen 192.168.1.1:80;
  return 444;
}</pre>

It's perfectly OK to have two listeners defined on the one port, as long as they have different server_names.  In this case, a host header of www.example.com will serve whatever locations are in locations-www.inc and a host header of locations-blog.inc will serve whatever locations are in locations-blog.inc.  Lacking a host header gets a HTTP 444 error return.

## Defining locations for www.example.com

Now, we'll create a new file locations-www.inc and define some locations in it.  We'll have a catch-all rule down the bottom to reject anything else not specifically allowed.

<pre># Return a HTTP 200 if http://www.example.com/nginx-works is called
location /nginx-works {
  return 200;
}

# Pass through http://www.example.com/image.gif (exactly!) to Apache
location = /image.gif {
  proxy_pass http://localhost;
  include /etc/nginx/conf.d/proxy.inc;
}

# Pass through http://www.example.com/application (and sub-URIs) to Apache
location /application {
  proxy_pass  http://localhost;
  include /etc/nginx/conf.d/proxy.inc;
}

# Pass through http://www.example.com/monitoring to Apache for specific IPs
location /monitoring {
  allow 192.168.0.0/16;
  deny all;
  proxy_pass http://localhost;
  include /etc/nginx/conf.d/proxy.inc;
}

# Deny everything else
location / {
  return 444;
}</pre>

With that defined, we have all the locations we want to pass defined, and block everything else.  What will happen in the proxy_pass sections is that the request will be reverse proxied to localhost (ie, Apache), with a configuration to be specified next.

## Defining reverse proxy settings

Now, we need to define a proxy.inc, which defines the default reverse proxy configuration we want to use.  Use something like this;

<pre>proxy_redirect          off;
proxy_set_header        Host            $host;
proxy_set_header        X-Real-IP       $remote_addr;
proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
client_max_body_size    10m;
client_body_buffer_size 128k;
proxy_connect_timeout   90;
proxy_send_timeout      90;
proxy_read_timeout      90;
proxy_buffers           32 4k;</pre>

What this will do is set up various configuration settings for nginx.  In particular, note the three headers we're configuring.  First, we ensure that the Host header is set to the same host that the user originally requested.  Secondly, we make sure that the X-Real-IP is set to the IP address that the user came from, and then we set X-Forwarded-For correctly.  Both of these allow mod_rpaf to be able to correctly interpret the IP address that the user originally came from.

If you don't do this, all your Apache access logs will appear to have all accesses coming from localhost, since nginx is a reverse proxy.  That isn't ideal.

## Defining locations for myblog.example.com

We make a new location-blog.inc, and then make it look like this;

<pre>location / {
  # Doing something strange like trying to fetch /blog/blog/* results in just /blog/*
  rewrite ^/blog$ / redirect;
  rewrite ^/blog(.*)$ $1 redirect;

  # Otherwise just add /blog to the front and pass to the backend
  rewrite ^(.*)$ /blog$1 break;

  proxy_pass http://localhost;
  include /etc/nginx/conf.d/proxy.inc;
}</pre>

This will allow you to redirect your blog which may be at http://localhost/blog to work properly when people access it with http://myblog.example.com/ .

# Testing it out

Restart nginx like this;

<pre>chkconfig nginx on
service start nginx</pre>

Now, assuming it started OK (fix it if it didn't), you should be able to test various URL fetches with curl to see what happens.  Try from a different machine, as follows;

<pre># These should work
curl -v http://www.example.com/nginx-works
curl -v http://www.example.com/application
curl -v http://myblog.example.com/

# These should blow up
curl -v http://www.example.com/application/../../../../etc/passwd
curl -v http://www.example.com/image.gif/badstuff

# This should redirect a few times and then wind up at your blog
curl -v -L http://myblog.example.com/blog/blog/blog/blog</pre>

Try out various things.  Remember to test things that should NOT work as well as things that should.

Good luck!