---
id: 1007
title: Converting a bunch of OGG music to MP3, preserving metadata
date: 2017-04-04T10:55:54+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=1007
permalink: /2017/04/converting-bunch-ogg-music-mp3-preserving-metadata/
categories:
  - Technical
format: aside
---
Quick one.  If you have a heap of OGG music that you want to convert to MP3 format, and also want to conserve the metadata that's in the music, run this from Ubuntu;

<pre>for name in *.ogg; do ffmpeg -i "$name" -ab 128k -map_metadata 0:s:0 "${name/.ogg/.mp3}"; done</pre>

Done and dusted!