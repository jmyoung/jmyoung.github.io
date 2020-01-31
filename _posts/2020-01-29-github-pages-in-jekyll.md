---
title: Github Pages in Jekyll - Revisited
date: 2020-01-29T11:40:00+09:30
author: James Young
layout: post
categories:
  - Technical
tags:
  - linux
  - podman
  - jekyll
---

As I discussed in [my post on Jekyll](/2019/09/jekyll-in-podman-quick-demo/), you can run Jekyll in a container.  I've since modified this process somewhat due to running into what looks like a [2020 windowing bug](https://www.newscientist.com/article/2229238-a-lazy-fix-20-years-ago-means-the-y2k-bug-is-taking-down-computers-now/) with old versions of Ruby.

# Inital Setup

You'll need a directory, which we will call `/opt/jekyll`, which will contain a directory `bundle` and a directory `blog.github.io`, both of which should be owned by the `apache` user.  I assume this user is UID 48 and GID 48.

```
mkdir -p /opt/jekyll/bundle
mkdir -p /opt/jekyll/blog.github.io
chown -R apache:apache /opt/jekyll/bundle /opt/jekyll/blog.github.io
```

Your Github Pages site should be checked out to that directory above.  You will also need a `Gemfile` in there, with content like this;

```ruby
source "https://rubygems.org"
gem "github-pages", group: :jekyll_plugins

# Review https://pages.github.com/versions/ for versions
group :jekyll_plugins do
  gem "jekyll-sitemap"
  gem "jekyll-feed"
  gem "jekyll-seo-tag"
  gem "jekyll-paginate"
end

# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
install_if -> { RUBY_PLATFORM =~ %r!mingw|mswin|java! } do
  gem "tzinfo", "~> 1.2"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.1", :install_if => Gem.win_platform?
```

# Constructing the Ruby environment

First of all, we're going to use the Dockerhub [jekyll image](https://hub.docker.com/r/jekyll/jekyll/).  Specifically, the tag `docker.io/jekyll/jekyll:pages`, which is made for replicating Github Pages.  I'm also assuming you are using `podman`, change the commands to Docker if you're using that.

```bash
podman pull docker.io/jekyll/jekyll:pages
```

Now it's necessary to run up the container and get into it so you can set up the initial environment.  Remove the `,z` from the mounts if you don't have SELinux;

```bash
podman run -it --rm --name jekyll \
  -v /opt/jekyll/blog.github.io:/srv/jekyll:rw,z \
  -v /opt/jekyll/bundle:/usr/local/bundle:rw,z \
  -e JEKYLL_UID=48 \
  -e JEKYLL_GID=48 \
  docker.io/jekyll/jekyll:pages \
  bash
```

This will drop you into a Bash prompt in a transient container which will be removed when you exit.  To set up the environment, we have to install some packages first, then run Jekyll to install the rest.

```bash
cd /srv/jekyll
apk --no-cache add --virtual build_deps make gcc build-base ruby-dev libc-dev linux-headers libxml2-dev libxslt-dev
bundle install
bundle exec jekyll build --drafts
```

After that's done, Jekyll should have built your site into `_site` and should have completed.  Now we can set up the container to run properly.

# Running it in Serve mode

Because Jekyll will by default serve to localhost, we need to override that.  We'll also allow drafts because this is a local install.  And we will publish port 4000 on the container out of the host so we can get at it with a browser;

```bash
podman run -it --rm --name jekyll \
  -v /opt/jekyll/blog.github.io:/srv/jekyll:rw,z \
  -v /opt/jekyll/bundle:/usr/local/bundle:rw,z \
  --publish 4000:4000 \
  -e JEKYLL_UID=48 \
  -e JEKYLL_GID=48 \
  docker.io/jekyll/jekyll:pages \
  bundle exec jekyll serve --drafts --host=0.0.0.0
```

And that's pretty well it.

# Updating your Gems

In order to update your gems, repeat the command above that got you into a Bash prompt, then;

```
cd /srv/jekyll
rm Gemfile.lock
apk --no-cache add --virtual build_deps make gcc build-base ruby-dev libc-dev linux-headers libxml2-dev libxslt-dev
bundle update
```

Exit out, then restart the container.
