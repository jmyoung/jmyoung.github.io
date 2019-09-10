---
id: 973
title: Netflow with ELK Stack and OpenWRT
date: 2016-09-27T14:51:34+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=973
permalink: /2016/09/netflow-elk-stack-openwrt/
categories:
  - Technical
tags:
  - elkstack
  - openwrt
---
Now we're getting into some pretty serious magic.  This post will outline how to put together [OpenWRT](https://openwrt.org/) and [ELK Stack](https://www.elastic.co/webinars/introduction-elk-stack) to collect network utilization statistics with [Netflow](http://www.solarwinds.com/what-is-netflow/).  From there, we can use [Kibana](https://www.elastic.co/products/kibana) to generate visualizations of traffic data and flows and whatever else you want to leverage with the power of Elasticsearch.

I'm using a virtualized router instance running OpenWRT 15.05.1 (Chaos Calmer) on KVM with the [Generic x86 build](https://downloads.openwrt.org/chaos_calmer/15.05.1/x86/kvm_guest/).  Using a hardware router is still doable, but you'll need to be careful about CPU utilization of the Netflow exporter.  Setting this up will require a number of components, which we'll go through now.

You will need an OpenWRT box of some description, and an ELK Stack already configured and running.

# OpenWRT Setup

You'll need to install `softflowd`, which is as easy as;

<pre>opkg update
opkg install softflowd</pre>

Then edit `/etc/config/softflowd` and set the destination for flows to go to something like;

<pre>option host_port 'netflow.localdomain:9995'</pre>

Start up the Softflow exporter with `/etc/init.d/softflowd start` and it should be working.

Note, default config will be using Netflow version 5.  Let that stand for now.  Also, leave the default interface on `br-lan` - that way it'll catch flows for all traffic reaching the router.

# Logstash Configuration

If you're using the ELK Stack Docker project like me, you'll need to set up the Docker container to also listen on port 9995 UDP.  At any rate, you need to edit your `logstash.conf` so that you have the following input receiver;

<pre># Netflow receiver
input {
  udp {
    port =&gt; 9995
    type =&gt; netflow
    codec =&gt; netflow
  }
}</pre>

This is an extremely simple receiver which takes in Netflow data on port 9995, sets the type to `netflow` and then processes it with the built-in Netflow codec.

In your output transmitter, you'll then want something like this example;

<pre>output {
        if ( [type] == "netflow" ) {
                elasticsearch {
                        hosts =&gt; "elasticsearch:9200"
                        index =&gt; "logstash-netflow-%{host}-%{+YYYY.MM.dd}"
                }
        } else {
                elasticsearch {
                        hosts =&gt; "elasticsearch:9200"
                        index =&gt; "logstash-%{type}-%{+YYYY.MM.dd}"
                }
        }
}
</pre>

What this does is pretty straightforward.  Everything gets sent to the Elasticsearch engine at `elasticsearch:9200`.  But, messages with the type of `netflow` get pushed into an index that has the IP address that the flow was collected from in it (this will probably be your router).

Restart Logstash and you should start getting flows in within a few minutes.

# Kibana Setup

From there, just go into Kibana and add a new index pattern for `logstash-netflow-*`.  You can then visualize / search all your Netflow data to your heart's content.

Nice!