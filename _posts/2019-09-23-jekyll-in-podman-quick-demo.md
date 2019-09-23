---
title: Jekyll in Podman - A Quick Demo
date: 2019-09-23T10:08:00+09:30
author: James Young
layout: post
categories:
  - Technical
tags:
  - linux
  - podman
  - jekyll
---

As discussed earlier, I've switched over to using [Jekyll](https://jekyllrb.com/) for generating this blog.  So far, so good.  But what I wanted to do was run the Jekyll serve components in Podman, so I could preview changes without having to have local Ruby installs.

Fortunately, this turns out to be pretty easy.  What you need is;

* Podman (or Docker, whatever you prefer)
* Your checked-out Github Pages site
* A directory that you can give Jekyll r/w access to in order to store the Gem bundle

Now, assuming that you want Jekyll to run as UID 48 / GID 48 (the `apache` user on CentOS), you just do this;

```
#!/bin/bash

# Gemfile lock has to be owned by apache:apache
touch ./YOURPAGESSITE/Gemfile.lock
chmod a+w ./YOURPAGESSITE/Gemfile.lock

# Jekyll runs as Apache
podman run -it --rm --name jekyll \
  -v ./YOURPAGESSITE:/srv/jekyll:rw,slave,Z \
  -v ./bundle:/usr/local/bundle:rw,slave,Z \
  --publish 4000:4000 \
  -e JEKYLL_UID=48 \
  -e JEKYLL_GID=48 \
  docker.io/jekyll/jekyll:3.8.5 \
  jekyll serve --drafts
```

Now what's going on here is that Jekyll will run as `apache`, which means it needs to have R/W access to the `Gemfile.lock` file in your build root.  Hence why we touch it and then set it world writeable.  We then just run up Jekyll with the version that Github Pages uses and tell it to serve in Drafts mode.

Really easy.