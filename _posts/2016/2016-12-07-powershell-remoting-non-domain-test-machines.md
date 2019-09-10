---
id: 987
title: Powershell Remoting for Non-Domain Test Machines
date: 2016-12-07T10:43:24+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=987
permalink: /2016/12/powershell-remoting-non-domain-test-machines/
categories:
  - Computers
  - Technical
tags:
  - powershell
  - windows
---
**NOTE - This isn't particularly secure, but it works.  It's a bit better than configuring WinRM in unencrypted mode though.**

Got some non-domain joined Windows machines and you want to get WinRM running in a hurry so you can do some stuff remotely?  Do this.

On the server (the thing you are remoting to);

<pre>Invoke-WebRequest -Uri https://github.com/ansible/ansible/blob/devel/examples/scripts/ConfigureRemotingForAnsible.ps1 -OutFile ConfigureRemotingForAnsible.ps1
.\ConfigureRemotingForAnsible.ps1
winrm quickconfig</pre>

That script is taken from Ansible, and configures a host with a self-signed SSL cert for use with WinRM.  The final line then configures up the WinRM listeners and firewall rules.

Then, on the client (the thing you're remoting from);

<pre># enter local admin creds here
$creds = get-credential  

$so = New-PSSessionOption -SkipCACheck -SkipCNCheck
Invoke-Command -Computername YOURSERVERHERE -UseSSL -SessionOption $so -Credential $creds -ScriptBlock { get-childitem env: }</pre>

You should see a dump of the local environment variables on the target machine, indicating that the invoke worked.  You can now do whatever Powershell remoting stuff you want to do.

Note, this doesn't actually check the CA cert provided, so you can be MITM'ed and have your credentials captured.  For better security you should use a properly signed certificate on the server and trust it on the client correctly, but this will work fine for a home setup where you're in control of all the layers (network, client and server).

Good luck.