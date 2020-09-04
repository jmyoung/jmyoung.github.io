---
layout: page
title: Modded Minecraft Notes and Documentation
permalink: /docs/minecraft/index.html
is_index: true
---

{% for page in site.docs_minecraft -%}
  {% unless page.is_index -%}
  * [{{ page.title }}]({{ page.url }})
  {% endunless -%}
{% endfor -%}

