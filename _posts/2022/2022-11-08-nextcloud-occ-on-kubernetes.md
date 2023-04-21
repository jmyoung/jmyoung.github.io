---
title: 'NextCloud OCC on Kubernetes'
author: James Young
layout: post
categories:
  - technical
tags:
  - kubernetes
  - microk8s
  - nextcloud
---

Turns out it's been nearly a year since I've posted.  Whoops.

Currently I'm running [NextCloud](https://nextcloud.com/) in Kubernetes, and in an effort to secure it a bit better, I had need of disabling the default `admin` user, along with a piece of enabling MFA for all other users.  For obvious reasons, if you're going to disable the default break-glass admin user, you really need a way of re-enabling it again.

This can be done through the `occ` NextCloud configuration utility.  However, that utility must run as the `www-data` user, and when running under Kubernetes, it's not entirely clear how one can do that.  So here's how you can do exactly that.

We assume that your NextCloud deployment is in the namespace `nextcloud` and you are only running one replica.

```bash
# Get the name of your NextCloud pod
kubectl -n nextcloud get pods -o name

# Jump into the pod, become the www-data user and change into the install folder
# Replace the text below with your actual pod name
kubectl -n nextcloud exec -it nextcloud-664f28882-fiajn -- su -s /bin/bash - www-data
cd /var/www/html

# Disable the default admin user, allowing 512Mb of memory for the occ command to run in
PHP_MEMORY_LIMIT=512M php occ user:disable admin

# Exit out of the pod
exit
```

And there you have it.  Obviously to re-enable the user you just do the same but with `occ user:enable admin`.

