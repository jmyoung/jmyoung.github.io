---
title: Rootless Podman on CentOS
date: 2020-02-03T11:20:00+09:30
author: James Young
layout: post
categories:
  - Technical
tags:
  - linux
  - podman
---

It's possible to run Podman as non-root, such that it runs in the context of a standard user.  This is pretty good for a number of reasons, but there's a few steps that need to be done to make this happen.

First, we'll talk about subuids and subgids.  When you run rootless, UID 0 in the container is mapped to the UID of the user who is running `podman`.  However, a container may utilize other UIDs.  Those UIDs are mapped to other UIDs on the host that the user is granted permission to use.  The same thing happens with GIDs.

You add users to the subuid/subgid mapping with the `usermod` and `groupmod` commands, or by directly editing the `/etc/subuid` and `/etc/subgid` files directly.  We will do the latter.  Note though, subuids/subgids do not grant the user id access to those directories, so if anything gets mapped, the original uid will lose access to those files!  For this reason, rootless will often work better if the container does not attempt to change UID, and does everything as UID 0.

Do the following in CentOS7 as root;

```bash
echo 'user.max_user_namespaces=127357' > /etc/sysctl.d/01-maxusernamespaces.conf
sysctl --system
echo "username:100000:65536" >> /etc/subuid
echo "username:100000:65536" >> /etc/subgid
yum install -y podman slirp4netns
```

Replace `username` with your username, of course.  This will assign that userid a subuid/subgid mapping of up to 65536 digits, starting from 100000.  The onus is on the administrator to ensure there is not a conflict.

You can review the mappings done by podman at this point with;

```
$ podman unshare cat /proc/self/uid_map
         0      12345          1
         1     100000      65536
```

This mapping tells us that one uid starting from 0 (ie, uid 0 only) is mapped to host uid `12345`, and that 63356 uids starting from uid 1 is mapped to the range of host uids starting at 100000.  This is what we expected to see.  `/proc/self/gid_map` produces similar output.

It's worth mentioning `podman unshare`.  This runs an arbitrary process in a new user namespace, which means it has some uses for clearing out data that got chowned to the mapped IDs.

From there, you should just be able to run containers as normal, but as a regular user.  Note that you can't open privileged ports (ones below 1024), and you can't map things you wouldn't have access to as your regular uid.  uid/gid mapping will happen automatically.

If you want to customize the mapping, you can.  But be aware that in rootless mode, the `host_uid` parameter of `--uidmap` maps relative to the base UID of your subuid range, not 0.  Also you cannot remap arbitrary uids inside the container to your uid.

