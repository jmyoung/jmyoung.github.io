---
id: 130
title: 'Remote backing up a Linux host over the &#8216;net with BackupPC'
date: 2013-04-15T10:59:52+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=130
permalink: /2013/04/remote-backing-up-a-linux-host-over-the-net-with-backuppc/
categories:
  - Technical
tags:
  - backup
  - linux
---
I've recently moved my blog across to a [VPS](http://en.wikipedia.org/wiki/Virtual_private_server) service.  A VPS is akin to a chroot jail, where you have your own server, but you're running a common Linux kernel.  This also means you don't really have your own filesystem - so for the sakes of paranoia I don't want the VPS to have any privileged data on it, and I don't want the VPS to be able to remote back into my main infrastructure to back itself up.

Enter SSH+rsync+BackupPC.  Putting these together allows you to back up a remote host that has SSH access in a secure way.  We'll discuss how to get backups running through BackupPC to back up a remote host through SSH.

# Step 1 - Connectivity.

We'll assume that you have a working SSH connection, and you have BackupPC installed on the backup host (we'll call this SERVER).  On the client machine (the one you want to back up), you'll need to create a new user account;

<pre>adduser backup -c 'Backup SSH Account'</pre>

Don't set a password on this account, you will never log in using it, ever.  Now, on the server machine you will need to switch over to the backuppc account and create an appropriate SSH ID;

<pre>sudo -u backuppc bash
ssh-keygen</pre>

This will create a new file **/var/lib/BackupPC/.ssh/id_rsa.pub** which you'll want to grab the contents of.  On the client, SUDO as the backup account and do this;

<pre>sudo -u backup bash
cd
mkdir .ssh
cat &gt;&gt; .ssh/authorized_keys
<strong>PASTE IN YOUR ID_RSA.PUB FILE HERE AND THEN PRESS CTRL-D
</strong>chmod -R og= .ssh</pre>

Now you've got the key in place on both sides of the connection.  Now, on the server machine, you're going to switch to the backuppc account and try to ssh to your client;

<pre>sudo -u backuppc bash
ssh <a href="mailto:backup@client.domain.com">backup@client.domain.com</a></pre>

You should be prompted to accept the host key (do it!), and then you should see a prompt as your backup user on the client machine.  Exit and do it again, and there should be no prompting.  It's critical you see no prompts, since any prompting will cause weird breakages in BackupPC.  Make sure that the hostname you ssh in as is the exact host name you will use when configuring BackupPC.

Connectivity set up.  Now we'll configure SUDO on the client to work properly for the backup user.

# SUDO Access

On the client server, add the following lines to your **/etc/sudoers** file (use **visudo** for this);

<pre># Allows backup to take backups only
#backup       ALL=NOPASSWD: /usr/bin/rsync --server --sender *

# Allows backup to do backups and restores
backup        ALL=NOPASSWD: /usr/bin/rsync --server *</pre>

Note that in this fragment, the backup user will be able to do both backups and restores.  This may be dangerous, since a crafty attacker who gets access to the backup account can push arbitrary files up onto the client.  Use your discretion.

Lastly, you'll have to edit your /etc/sudoers file and change the line that says

<pre>Defaults requiretty</pre>

To say

<pre>Defaults !requiretty</pre>

If you don't do that, you can't ssh in as a non-tty (ie, backuppc can't work).  Once that's in place, you'll need to run it once to avoid the sudo prompt, like this (from the server);

<pre>sudo -u backuppc bash
ssh <a href="mailto:backup@client.domain.com">backup@client.domain.com</a>
sudo /usr/bin/rsync --server --help</pre>

Run it again if you get prompted to verify that all you see is the rsync help page.  If you do, then you're all ready to go.  Next we configure BackupPC.

# BackupPC Configuration

Define a new host in /etc/BackupPC/hosts like you usually would.  For the config file for that client, you'll want something like this;

<pre style="width: 756px; height: 495px;"><span style="color: #666666; font-family: Consolas;">$Conf{BackupFilesExclude} = {
 '*' =&gt; [
    '/cgroup',
    '/data',
    '/dev',
    '/lost+found',
    '/misc',
    '/mnt',
    '/net',
    '/proc',
    '/selinux',
    '/sys',
    '/tmp',
    '/var/tmp',
    '/var/cache/yum'
  ]
};
$Conf{ClientNameAlias} = 'client.domain.com';
$Conf{PingMaxMsec} = '1000';
$Conf{XferMethod} = 'rsync';
$Conf{RsyncClientCmd} = '$sshPath -q -x -l backup $host /usr/bin/sudo $rsyncPath $argList+ $shareName';
<span style="color: #666666; font-family: Consolas;">$Conf{RsyncClientRestoreCmd} = '$sshPath -q -x -l backup $host /usr/bin/sudo $rsyncPath $argList+ $shareName';</span></span></pre>

The customized rsync commands gets BackupPC to run rsync through an SSH tunnel.  Now, run your backup, and hope!

# Gah!  It broke!

The most likely thing you'll see will be something about Pipe broken or invalid data or some such.  That usually means that the ssh tunnel got prompted somewhere, so no sensible rsync data came through.  Re-run the SSH connectivity process, and be sure you are specifying _exactly_ the same name in the ssh command as you have set for $Conf{ClientNameAlias} above.

Good luck.