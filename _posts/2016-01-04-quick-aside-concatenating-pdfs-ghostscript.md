---
id: 844
title: 'Quick aside &#8211; concatenating PDFs with Ghostscript'
date: 2016-01-04T12:32:43+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=844
permalink: /2016/01/quick-aside-concatenating-pdfs-ghostscript/
categories:
  - Other
format: aside
---
A useful little snippet.  This will concatenate multiple PDFs together into one;

<pre>gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=firstANDsecond.pdf -dBATCH first.pdf second.pdf</pre>

&nbsp;