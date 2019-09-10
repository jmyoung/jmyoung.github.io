---
id: 979
title: Splunk integration with Docker
date: 2016-11-16T10:59:18+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=979
permalink: /2016/11/splunk-integration-docker/
categories:
  - Computers
  - Technical
tags:
  - docker
  - splunk
---
I've changed over my log aggregation system from [ElasticStack](https://www.elastic.co/products) to [Splunk Free](http://docs.splunk.com/Documentation/Splunk/6.5.0/Admin/MoreaboutSplunkFree) over the past few days.  The primary driver for this is that I use Splunk at work, and since Splunk Free allows 500Mb/day of ingestion, that's plenty for all my home stuff.  So, using Splunk at home means I gain valuable experience at using Splunk professionally.

What we'll be talking about here is how you integrate your Docker logging into Splunk.

# Configure an HTTP Event Collector

Firstly, you'll need to enable the Splunk HTTP Event Collector.  In the Splunk UI, click Settings -> Data Inputs -> HTTP Event Collector -> Global Settings.

Click Enabled alongside 'All Tokens', and enable SSL.  This will enable the HTTP Event Collector on port 8088 (the default), using the Splunk default certificate.  This isn't enormously secure (you should use your own cert), but this'll do for now.

Now, in the HTTP Event Collector window, click New Token and add a token.  Give it whatever details you like, and set the source type to `json_no_timestamp`.  I'd suggest you send the results to a new index, for now.

Continue the wizard, and you'll get an access token.  Keep that, you'll need it.

# Configure Docker Default Log Driver

You now need to configure the default logging method used by Docker.  NOTE - Doing this will break the `docker logs` command, but you can find everything in Splunk anyway.  More on that soon.

You will need to override the startup command for dockerd to include some additional options.  You can do this on CentOS7 by creating a `/etc/systemd/system/docker.service.d/docker-settings.conf` with the following contents;

{% raw %}
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd --log-driver=splunk --log-opt splunk-token=PUTYOURTOKENHERE --log-opt splunk-url=https://PUTYOURSPLUNKHOSTHERE:8088 --log-opt tag={{.ImageName}}/{{.Name}}/{{.ID}} --log-opt splunk-insecureskipverify=1
{% endraw %}

The options should be fairly evident.  The tag= option configures the tag that is attached to the JSON objects outputted by Docker, so it contains the image name, container name, and unique ID for the container.  By default it'll be just the unique ID, which frankly isn't very useful post-mortem.  The last option allows the use of the Splunk SSL certificate.  Get rid of this option when you use a proper certificate.

# Getting the driver in place

Now you've done that, you should be able to restart the Docker host, then reprovision all the containers to change their logging options.  In my case, this is a simple `docker-compose down` followed by `docker-compose up`, after a reboot.

The `docker logs` command will be broken now, but you can instead use Splunk to replicate the functionality, like this;

```
index=docker host=dockerhost | spath tag | search tag="*mycontainer*" | table _time,line
```

That will drop out the logs from the last 60 minutes for the container `mycontainer` running on the host `dockerhost`.

You can then start doing wizardry like this;

```
index=docker | spath tag | search tag="nginx*" 
| rex field=line "^(?&lt;remote_addr&gt;\S+) - (?&lt;remote_user&gt;\S+) \[(?&lt;time_local&gt;.+)\] \"(?&lt;request&gt;.+)\" (?&lt;status&gt;\d+) (?&lt;body_bytes&gt;\d+) \"(?&lt;http_referer&gt;.+)\" \"(?&lt;http_user_agent&gt;).+\" \"(?&lt;http_x_forwarded_for&gt;).+\"$"
| rex field=request "^(?&lt;request_method&gt;\S+) (?&lt;request_url&gt;\S+) (?&lt;request_protocol&gt;\S+)$"
| table _time,tag,remote_addr,request_url
```

To dynamically parse [NGINX](https://hub.docker.com/_/nginx/) container logs outputted by Docker, split up the fields, and then list them by time, remote IP, and the URL requested.

I'm sure there's better ways of doing this (such as parsing the logs at index time instead of at search time), but this way works pretty well and should function as a decent starting point.