---
title: Migration to Github Pages!
date: 2019-05-02T13:57:00+09:30
author: James Young
layout: post
categories:
  - Technical
tags:
  - github
---

# Migration to Github Pages!

I've had a bee in my bonnet the past few weeks about Markdown vs. Wikitext and HTML.  In short, I hugely prefer [Markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet).  There's a couple of reasons for this;

* It's a lot smoother to actually write.
* It's very much like how I'd write notes and such in a text editor anyway.
* It has easy integration with Git, editors like VS.Code, and other things.

Now I know full well that Wordpress can use Markdown plugins, and some of those are pretty excellent.  But I've also been interested in getting rid of a server-based blogging platform entirely and instead just using something like [Jekyll](https://jekyllrb.com/) to generate and [Github Pages](https://pages.github.com/) to host.

What you're looking at right now is that attempt.  I wound out using the [Reverie](https://jekyllthemes.io/theme/reverie) theme, and also incorporated [Mermaid](https://mermaidjs.github.io/#/) so I can easily do charts and things.

# Setting up Jekyll on Windows

For reasons of having a Windows machine as my main desktop, I wanted to be able to preview what output will look like without having to actually push it live.  This process will require [Windows Services for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10) to be installed.

The basic shape of the process looks like this;

<div class="mermaid">
graph LR;
  Install[Install Ruby] --> SetPath[Set Gem Path];  
  SetPath --> GemUpdate[Update Local Gems];
  GemUpdate --> InstallBundler[Install Bundler];
</div>

From a Windows 10 Bash prompt, do the following;

```
sudo apt-add-repository ppa:brightbox/ruby-ng
sudo apt-get update
sudo apt-get install ruby2.5 ruby2.5-dev build-essential dh-autoreconf zlib1g-dev
```

Then, you will need to edit your `.profile` and add the following;

```
export GEM_HOME=$HOME/.gems
export PATH=$HOME/.gems/bin:$PATH
```

Restart your bash prompt after this.  This will enable Ruby to install gems locally without you needing to elevate.  You can now install Bundler and the Github Pages gem with;

```
gem update
gem install bundler github-pages
```

Lastly, run `jekyll -v` to view your Jekyll version.  You can compare the versions of the various plugins that GitHub themselves use [here](https://pages.github.com/versions/).

# Making a base site

Following the instructions for [Reverie](https://github.com/amitmerchant1990/reverie), I simply forked the project and renamed it to the name of my Github account + `.github.io`.  This is then checked out.

From there, you create a Gemfile which looks like this;

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

This contains all the settings that are in the `_config.yml` that are relevant to configuring Jekyll.  Now you should be able to run up Jekyll locally.

# Start Jekyll locally

The process for running Jekyll locally and serving your files looks like this;

<div class="mermaid">
graph LR;
  X[cd into the site] --> A;
  A{Is the bundle installed?} -->|Yes| B[bundle exec jekyll serve];
  A -->|No| C[bundle update];
  C --> B;
  B --> D[open browser to localhost:4000]
</div>

Assuming that your checked out site is in '~/github_pages', that would look like this;

```
cd ~/github_pages
bundle update
bundle exec jekyll serve
```

You can then browse to http://localhost:4000/ and find your site.  Give Jekyll a bit of time to actually render everything though and start serving.

# Push the changes up to GitHub

So if all has rendered correctly, you should now be able to push that up to GitHub Pages to make it live very easily, with something like this;

```
git add .
git commit -m 'I made a post!'
git push origin master
```

And it'll be live.

# What now?

Well, I have a fair bit of tuning to do.  Fixing up logos, adding links, and I'm also toying with the idea of adding [Disqus](https://disqus.com/) support.  I'll see how it goes.