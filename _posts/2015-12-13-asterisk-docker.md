---
id: 836
title: Asterisk in Docker
date: 2015-12-13T14:02:42+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=836
permalink: /2015/12/asterisk-docker/
categories:
  - Computers
  - Technical
  - Telephony
tags:
  - asterisk
  - docker
---
I've decided to bite the bullet, and I'm working on converting my existing Microserver Centos 6 setup across to [Centos 7](https://www.centos.org/) with [Docker](https://www.docker.com/) containers for all my applications.

Why Docker?  Why not [OpenVZ](https://openvz.org/Main_Page) or [KVM](http://www.linux-kvm.org/page/Main_Page)?  KVM was out straight away because my Microserver simply doesn't have the spare CPU and RAM to be running full virtual machines.  OpenVZ is an attractive option, but there's no non-beta release of OpenVZ for Centos 7.  So that leaves Docker amongst the options I wanted to look at.

Asterisk poses some challenges for Docker, namely that the RTP ports are pseudo-dynamic, and there's a lot of them.  Docker does proxying for each port that's mapped into a container, and spawns a docker-proxy process for each one.  That's fine if you have 1-2 ports, but if you may have over 10,000 of them that's a big problem.  The solution here is to configure the container to use the host's networking stack, then do some config on the container so that it uses a different IP from the host (to keep the host's IP space "clean").  We'll also be configuring the container as non-persistent so it pulls config (read-only) from elsewhere on the filesystem and stores no state between restarts.  And lastly, we'll be using CentOS 6 as the Asterisk container OS (since Asterisk is available in the EPEL repository for that version).  It's not a very new version of Asterisk, but it's stable.

Let's get started.  For the impatient, here's the [gist](https://gist.github.com/jmyoung/a815823f2176c630c8f8).

# Create the Asterisk Container

First, we'll assemble a [Dockerfile](https://gist.github.com/jmyoung/a815823f2176c630c8f8#file-dockerfile).  We'll base it off CentOS 6, and just install Asterisk.  We use the ENTRYPOINT command so that we can pass additional arguments straight to Asterisk on running the container.

<pre>FROM centos:6
MAINTAINER James Young &lt;jyoung@zencoffee.org&gt;

# Set up EPEL
RUN curl -L http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm -o /tmp/epel-release-6-8.noarch.rpm && \
 rpm -ivh /tmp/epel-release-6-8.noarch.rpm && \
 rm -f /tmp/epel-release-6-8.noarch.rpm

# Update and install asterisk
RUN yum update -y && yum install -y asterisk

# Set config as a volume
VOLUME /etc/asterisk

# And when the container is started, run asterisk
ENTRYPOINT [ "/usr/sbin/asterisk", "-f" ]</pre>

Pretty simple stuff.  Note that processes should always run non-daemonized in Docker so that it can track the pid properly.

# Prepare the Docker Host

Use whatever tool is appropriate (I'm forcing systemd, firewalld and network-manager on myself) in order to configure a second IP for your Docker host's primary network interface.  Bleh.  Network Manager.

Be aware that when you use the host's network stack in Docker and don't explicitly expose the ports you'll be using, Docker does not configure the firewall.  You'll need to do that on the host.  We'll cover that in the Makefile.

# Create the Makefile

We'll use a [Makefile](https://gist.github.com/jmyoung/a815823f2176c630c8f8#file-makefile) to handle all the tasks we're dealing with in this container.  Here it is;

<pre>CONTAINER=asterisk
SHELLCMD=asterisk -rvvvvv

all: build install start

build:
 docker build -t zencoffee/$(CONTAINER):latest .

install:
 cp -f $(CONTAINER)_container.service /etc/systemd/system/$(CONTAINER)_container.service
 systemctl enable /etc/systemd/system/$(CONTAINER)_container.service
 firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 --proto udp -d 192.168.0.242 --dport 5060 -j ACCEPT
 firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 --proto udp -d 192.168.0.242 --dport 10000:20000 -j ACCEPT
 firewall-cmd --direct --add-rule ipv4 filter INPUT 0 --proto udp -d 192.168.0.242 --dport 5060 -j ACCEPT
 firewall-cmd --direct --add-rule ipv4 filter INPUT 0 --proto udp -d 192.168.0.242 --dport 10000:20000 -j ACCEPT

start:
 systemctl start $(CONTAINER)_container.service
 sleep 2
 systemctl status $(CONTAINER)_container.service

shell:
 docker exec -it $(CONTAINER) $(SHELLCMD)

clean:
 systemctl stop $(CONTAINER)_container.service || true
 docker stop -t 2 $(CONTAINER) || true
 docker rm $(CONTAINER) || true
 docker rmi zencoffee/$(CONTAINER) || true
 systemctl disable /etc/systemd/system/$(CONTAINER)_container.service || true
 rm -f /etc/systemd/system/$(CONTAINER)_container.service || true
 firewall-cmd --permanent --direct --remove-rule ipv4 filter INPUT 0 --proto udp -d 192.168.0.242 --dport 5060 -j ACCEPT || true
 firewall-cmd --permanent --direct --remove-rule ipv4 filter INPUT 0 --proto udp -d 192.168.0.242 --dport 10000:20000 -j ACCEPT || true
 firewall-cmd --direct --remove-rule ipv4 filter INPUT 0 --proto udp -d 192.168.0.242 --dport 5060 -j ACCEPT || true
 firewall-cmd --direct --remove-rule ipv4 filter INPUT 0 --proto udp -d 192.168.0.242 --dport 10000:20000 -j ACCEPT || true</pre>

Of course, I'm using firewalld here (bleh again) and systemd (double bleh).  You can see that this simply does a build of the container, then puts the systemd service into place and punches all the appropriate RTP and SIP ports on the IP address that Asterisk will be using.

# Configure the Systemd Unit

Now we need a [unit](https://gist.github.com/jmyoung/a815823f2176c630c8f8#file-asterisk_container-service) for systemd, so we can make this run on startup.  Here it is;

<pre>[Unit]
Description=Asterisk Container
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker run --rm=true --name asterisk -v /docker/asterisk/config:/etc/asterisk:ro -v /docker/asterisk/logs:/var/log/asterisk -v /docker/asterisk/codecs/codec_g723-ast18-gcc4-glibc-x86_64-pentium4.so:/usr/lib64/asterisk/modules/codec_g723-ast18-gcc4-glibc-x86_64-pentium4.so:ro -v /docker/asterisk/codecs/codec_g729-ast18-gcc4-glibc-x86_64-pentium4.so:/usr/lib64/asterisk/modules/codec_g729-ast18-gcc4-glibc-x86_64-pentium4.so:ro --net=host zencoffee/asterisk:latest
ExecStop=/usr/bin/docker stop -t 2 asterisk

[Install]
WantedBy=multi-user.target</pre>

The run command there does a number of things;

  * Pulls Asterisk config from /data/asterisk/config (read-only)
  * Writes Asterisk logs to /docker/asterisk/logs
  * Pulls in a g723 codec and a g729 codec for Asterisk to use (read-only)
  * Enables host networking

If you are missing those codecs, remove the two -v's that talk about them.  Also, you will likely have differently optimized versions anyway (Microserver has a pretty weak CPU, so Pentium4 is the right one to use for that).

# Edit the Asterisk Config

You'll need the default Asterisk config, which you can extract by building the container and running it up with;

<pre>docker run -d --name extract -v /docker/asterisk/config:/mnt zencoffee/asterisk:latest
docker exec -it extract /bin/bash
cp /etc/asterisk/* /mnt/
exit
docker stop extract
docker rm extract</pre>

From there, you can put in your own customized Asterisk config.  There's a few bits you need to tweak.  In sip.conf, set **udpbindaddr** and **tcpbindaddr** to the secondary IP that you want Asterisk listening on.  in rtp.conf, ensure that **rtpstart** and **rtpend** match the ports you set up the firewall for.

# Finally, putting it together!

Put your **asterisk_container.service**, **Dockerfile** and **Makefile** into the same directory.  Put your config into **/docker/asterisk/config** (in this example), your codecs into **/docker/asterisk/codecs**, and create a blank **/docker/asterisk/logs** .

You will also need a **cdr-csv** and **cdr-custom** directory in the logs dir if you want that functionality (Asterisk doesn't create it).

_Quickstart:  Just **make all** to do the whole lot and start it 🙂_

  1. Run **make build** to construct the image.
  2. Run **make install** to configure firewalld rules and put the systemd unit in place
  3. Run **make start** to start the container
  4. Run **make shell** to get an Asterisk prompt inside the container

You can also do a docker logs asterisk to see what's going on, and you can start/stop the container like a normal systemd service.

Good luck!