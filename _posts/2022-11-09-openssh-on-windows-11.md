---
title: 'OpenSSH on Windows 11'
author: James Young
layout: post
categories:
  - technical
tags:
  - windows
  - openssh
---

What a mess.  I'd upgraded my work laptop from Windows 10 to Windows 11, and discovered some strangeness with OpenSSH agent forwarding when using Windows' built-in ssh client.  Mostly, I use ssh through WSL2, but [VS Code](https://code.visualstudio.com/) obviously runs on the Windows layer, meaning that agent forwarding has to Just Work.  Which it did not.  I kept getting this sort of nonsense when trying to use a forwarded agent;

```text
channel 1: chan_shutdown_read: shutdown() failed for fd 7 [i0 o0]: Not a socket
```

Some examination revealed some strangeness, likely associated with having used Chocolatey in the past to install OpenSSH and then the upgrade to Windows 11.  It never seemed to uninstall.  So a cleanup was required.

# Getting a clean OpenSSH installation

The cleanup went along these lines;

* Ran the uninstall-sshd.ps1 script from inside the OpenSSH install directory to remove the agent and sshd services
* Deleted the install directory, removed it from the PATH (press Win+R and then `sysdm.cpl` to find environment variables)
* Deleted `C:\ProgramData\ssh`

Next I noticed there was a new optional component in Windows 11, an OpenSSH client (press Win+I, then click Apps, then Optional Features).  I installed this, and I got some strange error messages when running `ssh-agent` about not being able to get a service handle.  This turned out to be because there was no service.  So I removed that too.  This _also_ required cleanup, since it left behind all its binaries;

* Deleted `C:\Windows\system32\OpenSSH`
* Deleted `C:\ProgramData\ssh` again

Some further research shows that the Windows 11 OpenSSH client component _only_ installs `ssh`, `sftp`, and `ssh-keyscan`.  It does not install the full suite, and it does not install the `ssh-agent` component, which is what I need.  So that's no good.

At this point, there's no traces left behind of any ssh components.  So we need to install something that's going to work.  Enter `winget`.  There is a package for OpenSSH published by Microsoft in the winget repositories, which can then be installed with;

```text
winget install Microsoft.OpenSSH.Beta
```

After installation, add `C:\Program Files\OpenSSH` to your path.  This installer does install the `ssh-agent` and `sshd` components.  You'll probably want to stop and disable sshd unless you actually have cause to be able to ssh into your work laptop.  The easy way to disable it is this (run this from an administrative command prompt);

```text
sc.exe stop sshd
sc.exe config sshd start= disabled
```

# Configuring SSH

Now that it's actually configured, we'll assume you have a key you want to use already generated.  Go and put that in the `.ssh` folder in your `%HOME%`.  You now need to reset permissions on relevant files - it's recommended you do this process whenever you interfere with any ssh configuration components.  In an administrative Powershell window, run;

```powershell
C:\Program Files\OpenSSH\FixHostFilePermissions.ps1
C:\Program Files\OpenSSH\FixUserFilePermissions.ps1
```

Accept all prompts to reset permissions.  Now, the `ssh-agent` should already be running, so just run `ssh-add` to add your key.  You should now be able to use agent forwarding with;

```bash
ssh -o ForwardAgent=yes user@host
```

If you want to see whether agent forwarding appears to have worked, `echo $SSH_AUTH_SOCK` - if you get output, that's the socket that agent forwarding has enabled.

**Security Warning** - Be aware that enabling agent forwarding means a root user on the target machine can steal your ssh private key.  Don't enable it broadly, use it for ssh'ing into boxes where you will then jump onto other boxes (and don't enable forwarding for those).

Assuming what you want to do is agent forwarding and ssh'ing from this machine to others, that concludes what needs to be done.

# Enabling SSHD key-based login

If you _do_ want to enable login to your machine via ssh, you can follow the [Microsoft guide](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement) for setting it up.  The short form is;

* Set up your `authorized_keys` in `%HOME%\.ssh` for a non-administrative user.
* Set up the system-wide `administrators_authorized_keys` in `C:\ProgramData\ssh` for an administrative user.
* Reset file permissions as described above.

Note that if you _do_ enable ssh access for an administrative user, there's an obvious issue - any admin user on that machine can ssh in as any other admin user on the same machine.  However, given they're admin users and can just become each other anyway, it probably doesn't matter that badly.

But as said before, unless you actually have call to be ssh'ing into Windows boxes, don't do that.  Leave the service disabled.
