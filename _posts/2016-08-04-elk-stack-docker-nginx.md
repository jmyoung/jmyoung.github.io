---
id: 949
title: ELK Stack in Docker with NGINX
date: 2016-08-04T19:33:22+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=949
permalink: /2016/08/elk-stack-docker-nginx/
categories:
  - Technical
tags:
  - docker
  - elkstack
  - linux
---
I've done a bit of work in the past few days modifying a [Docker ELK](https://github.com/deviantony/docker-elk) Github repository I came across, to make it more suited to my needs.

You can find my efforts at [my Github repository](https://github.com/jmyoung/docker-elk).  This setup, when brought up with `docker-compose up`, will put together a full ELK stack composed of the latest versions of [ElasticSearch](https://www.elastic.co/products/elasticsearch), [Logstash](https://www.elastic.co/products/logstash), [Kibana](https://www.elastic.co/products/kibana), all fronted by [NGINX](https://nginx.org/en/) with login required.

The setup persistently stores all Elasticsearch data into the `./esdata` directory, and accepts [syslog](https://en.wikipedia.org/wiki/Syslog) input on port 42185 along with JSON input on port 5000.

In order to access Elasticsearch, use the Sense plugin in Kibana.  You can get at Kibana on port 5601, with a default login of admin/admin.  You can change that by using `htpasswd` and creating a new user file at `./nginx/htpasswd.users` .

A couple of things about Docker in this setup.  When you link containers, _it's not necessary to expose ports between the containers_.  Exposing is only required to make a port accessible from outside Docker.  When containers are linked, they get access to _all_ ports on the linked container.

This means that it's not required to specifically expose all the internal ports of the stack - you only have to expose the entry/exit points you want on the stack as a unit.  In this case, that's the entry ports to Logstash and the entry point in nginx.

Also, if you use a version 2 docker-compose specification, Docker Compose will also create an isolated network bridge just for your application, which is great here.  It will also manage dependencies appropriately to make sure the stack comes up in the right order.

Oh yeah.  If you bring up the stack with `docker-compose up`, press `Ctrl+\` to break out of it without taking the stack down.

Magic!