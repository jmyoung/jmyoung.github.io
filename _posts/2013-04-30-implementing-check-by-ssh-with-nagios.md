---
id: 308
title: Implementing check-by-ssh with Nagios
date: 2013-04-30T13:38:25+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=308
permalink: /2013/04/implementing-check-by-ssh-with-nagios/
categories:
  - Technical
tags:
  - linux
  - nagios
---
I wanted to get some Nagios checks running from my home Nagios box to my new VPS, and I wanted to do it via SSH (at the time I didn't know about NSClient++ with certificates).  Fortunately, this is (reasonably!) easy to do.

First, you need a **nagios** account on the target server.  We'll assume you already have one, and its shell is set to **/bin/bash**.  It does not need a password, and indeed it shouldn't even have one.  We're going to use SSH keys the whole way through.

# Server Configuration

On your Nagios server, we'll need to swap over to the **nagios** user and create a public key for ssh with no password;

<pre>sudo su -
sudo -u nagios bash
cd
ssh-keygen
cat ~/.ssh/id_rsa.pub</pre>

With that in place, you're ready to configure the target.  Leave this window open, and copy the outputted key into the clipboard.

# Target Configuration

On your target machine, edit **/etc/ssh/sshd_config** and add the following;

<pre>Match User nagios
PasswordAuthentication no
RSAAuthentication yes
PubkeyAuthentication yes</pre>

Doing the above sets things up so that the **nagios** user must use public key authentication when logging into the target server, and cannot use a password.  Things are more secure that way.

Now, you'll need to paste in the /var/spool/nagios/.ssh/id_rsa.pub file you created on the server into the client with;

<pre>sudo su -
sudo -u nagios bash
cd
mkdir ~/.ssh
cat &gt;&gt; ~/.ssh/authorized_keys
[PRESS CTRL-D WHEN PASTED]
chmod -R og= ~/.ssh</pre>

With that in place, you're in a good position to test out the connection.

# Testing the SSH Connection

All of the following tests will happen on the server machine, using the terminal you already have open logged in as the **nagios** user.

Check that you can ssh into your target as the **nagios** user;

<pre>ssh nagios@target.example.com</pre>

If this doesn't work, examine the error message.  You may have port 22 blocked, the **nagios** user may not be allowed to log in via SSH, or the nagios user's shell may be set to **/sbin/nologin**.

If this works, now try and log in with the various permutations that may be used for the hostname, eg;

<pre>ssh nagios@target
ssh nagios@192.168.1.1</pre>

Each time you should be prompted to accept the key, and do so (if the fingerprint is right).  You're doing this to populate the known\_hosts file for the nagios user on your server, so that check\_by_ssh can work properly.

Now, we can test check\_by\_ssh directly.  Do this;

<pre>cd /usr/lib64/nagios/plugins
./check_by_ssh -H target.example.com -n target -C uptime
<span style="color: #666666; font-family: Consolas;">./check_by_ssh -H target.example.com -n target -C '/usr/lib64/nagios/plugins/check_disk -w 20% -c 10%'</span></pre>

You should see first the uptime of the host followed by a regular looking Nagios check for checking the local disk.  If you don't, go check that you actually have the check_disk plugin in that location, and make sure that SELinux isn't causing grief.

# Configuring Nagios on the server

Now that you've established that the check\_by\_ssh plugin can work, you need to define a new command definition for it.  We'll do an example for running the check_disk plugin, and assume that $USER1$ corresponds to **/usr/lib/nagios/plugins** on both machines.

<pre>define command{
        command_name    check_byssh_disk
        command_line    $USER1$/check_by_ssh -H $HOSTADDRESS$ -n $HOSTNAME$ -C '$USER1$/check_disk -w $ARG1$ -c $ARG2$ -p $ARG3$'
}</pre>

Now you have a new command check\_byssh\_disk, which works exactly like the regular check_localdisk check does, except it will run against a remote host using SSH.  The host is connected to by its specified address using **address** in the host definition block, and the name is set using the **host_name** field in the host definition block.

NOTE - This is a fairly simple way of getting this going, but be aware that Nagios checks via SSH are fairly resource hungry (SSH session establish/teardown is needed for every check).  There's a better way - using NSClient++ with certificates.