---
id: 1162
title: Mermaid and Markdown in WordPress
date: 2019-09-06T16:50:31+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=1162
permalink: /2019/09/mermaid-and-markdown-in-wordpress/
categories:
  - Computers
format: aside
---
I've been doing much of my work lately in a local WikiJS and also documentation through [Markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet). So unfortunately this means that WordPress has gone by the wayside somewhat.

However, I discovered something very cool. There's multiple plugins you can use to put in Markdown support into WordPress, and some of them support [Mermaid](https://mermaidjs.github.io/#/)!

This means it's really easy to do things like `inline code blocks`,

    preformatted code blocks

| Col 1 | Col 2  |
| ----- | ------ |
| Easy  | Tables |

And even charts like;

<div class="mermaid">
sequenceDiagram
    participant Alice
    participant Bob
    Alice-&gt;&gt;John: Hello John, how are you?
    loop Healthcheck
        John-&gt;&gt;John: Fight against hypochondria
    end
    Note right of John: Rational thoughts &lt;br/&gt;prevail!
    John--&gt;&gt;Alice: Great!
    John-&gt;&gt;Bob: How about you?
    Bob--&gt;&gt;John: Jolly good!
</div>

Happy times!
