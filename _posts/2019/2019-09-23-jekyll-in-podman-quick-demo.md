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

Now what's going on here is that Jekyll will run as `apache`, which means it needs to have R/W access to the `Gemfile.lock` file in your build root.  Hence why we touch it and then set it world writeable.  We then just run up Jekyll with the version that Github Pages uses and tell it to serve in Drafts mode.  Really easy.

## But what about Windows?

It's also really easy to get this running in Windows, so you don't have to go and install Ruby and try and get that going.  Get [Docker Desktop](https://www.docker.com/products/docker-desktop), and once that's going, do this;

```
# Make sure these folders exist!
# Assume blog is in c:\stuff\blog
# Assume bundle tempstore is in c:\stuff\bundle

docker run -it --rm --name jekyll `
  -v c:\stuff\blog:/srv/jekyll:rw `
  -v c:\stuff\bundle:/usr/local/bundle:rw `
  --publish 4000:4000 `
  -e JEKYLL_UID=48 `
  -e JEKYLL_GID=48 `
  docker.io/jekyll/jekyll:3.8.5 `
  jekyll serve --drafts
```

It's not mandatory you use the UID/GID feature since Docker Desktop will map them as it likes, so it will just work.

You will have to go into Docker Settings -> Shared Drives, and tick the drive that you want to be able to use in volumes first though.

Once that's all done, you can find your draft site at http://localhost:4000/

Have fun!