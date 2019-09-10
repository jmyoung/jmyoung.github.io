---
id: 927
title: Deploying OpenShift Origin on CentOS Atomic
date: 2016-07-29T07:46:27+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=927
permalink: /2016/07/deploying-openshift-origin-centos-atomic/
categories:
  - Technical
tags:
  - docker
  - kvm
  - linux
  - openshift
---
For my work, we're looking at [OpenShift](http://openshift.org/), and I decided I'd set up an OpenShift Origin setup at home on my KVM box using [CentOS Atomic](http://www.projectatomic.io/download/).  This is a really basic setup, involving one master, two nodes, and no NFS persistent volumes (yet!).  We also don't permit pushing to DockerHub, since this will be a completely private setup.  I won't go into how to actually setup Atomic instances here.

Refer to the [OpenShift Advanced Install](https://docs.openshift.org/latest/install_config/install/advanced_install.html) manual for more.

# Prerequisites

  * One Atomic master (named `os-master1` here)
  * Two Atomic nodes (named `os-node1` and `os-node2` here)
  * A wildcard domain in your DNS (more on this later, it's named `*.os.localdomain` here)
  * A hashed password for your admin account (named `admin` here), you can generate this with `htpasswd`.
  * A box elsewhere that you can SSH into your Atomic nodes from, without using a password (read about `ssh-copy-id` if you need to).  We'll be putting Ansible on this to do the OpenShift installation.

# Setting up a Wildcard Domain

Assuming you're using BIND, you will need the following stanza in your zone;

<pre>; Wildcard domain for OpenShift
$ORIGIN os.localdomain.
* IN CNAME os-master1.localdomain.
$ORIGIN localdomain.</pre>

Change to suit your domain, of course.  This causes any attempts to resolve anything in `.os.localdomain` to be pointed as a CNAME to your master.  This is required so you don't have to keep messing with your DNS setup whenever you deploy a new pod.

# Preparing the Installation Host

As discussed, you'll need a box you can do your installation from.  Let's install the pre-reqs onto it (namely, Ansible and Git).  I'm assuming you are using CentOS here.

<pre>yum install -y epel-release
yum install ansible python-cryptography python-crypto pyOpenSSL git
git clone https://github.com/openshift/openshift-ansible</pre>

As the last step, we pull down the OpenShift Origin installer, which we'll be using shortly to install OpenShift.

You will now require an inventory file for the installer to use.  The following example should be placed in `~/openshift-hosts` .



Substitute out the hashed password you generated for your admin account in there.

# About the infrastructure

That inventory file will deploy a fully working OpenShift Origin install in one go, with a number of assumptions made.

  * You have one (non-redundant!) master, which runs the router and registry instances.
  * You have two nodes, which are used to deploy other pods.  Each node is in its own availability zone (named `left` and `right` here).

More dedicated setups will have multiple masters, which do not run pods, and will likely set up specific nodes to run the infrastructure pods (registries, routers and such).  Since I'm constrained for resources, I haven't done this, and the master runs the infrastructure pods too.

It's also very likely that you'll want a registry that uses NFS.  More on this later.

# Installing OpenShift

Once this is done, installation is very simple;

<pre>cd openshift-ansible
ansible-playbook -i ../openshift-hosts playbooks/byo/config.yml</pre>

Sit back and wait.  This'll take quite a while.  When it's done, you can then (hopefully!) go to;

<pre>https://os-master1:8443/console/</pre>

To log into your OpenShift web interface.  You can ssh to one of your masters and run `oc` commands from there too.

I'll run through a simple quickstart to test the infrastructure shortly.

&nbsp;