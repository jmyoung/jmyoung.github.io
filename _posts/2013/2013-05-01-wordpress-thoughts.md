---
id: 569
title: 'WordPress &#8211; Thoughts'
date: 2013-05-01T18:56:04+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=569
permalink: /2013/05/wordpress-thoughts/
categories:
  - Other
---
Well, now I've got WordPress set up and running, a few thoughts and comments about it are in order.  So far, it's pretty good.  Cleaner than Blogger, but it does require more maintenance to run.

On CentOS, installation was very easy.  You can follow [this basic guide here](https://www.digitalocean.com/community/articles/how-to-install-wordpress-on-centos-6--2) (although I used the yum package from EPEL instead of using the tarball).  After installation, go into <tt>wp-config.php</tt> and edit it.  Add this somewhere;

<pre><span style="color: #666666; font-family: Consolas;">/** Define method used to update filesystem - direct is forced */
define('FS_METHOD', 'direct');</span></pre>

WordPress checks whether the <tt>wp-content</tt> directory is writable before determining whether it will be able to upload plugins.  With the yum package,  <tt>wp-content</tt> is not writable by <span style="font-family: Courier New;">apache</span>, but the  <tt>wp-content/plugins</tt> directory is.  Technically plugin installation does not require write access to  <tt>wp-content</tt> but does require it to <tt>wp-content/plugins</tt>, so I guess WordPress has a bug.  Anyway, the above fragment will force WordPress to use the direct method, which will work.

# Blogger Importing

After setup, the first thing I did was to install the [Blogger Importer](http://wordpress.org/extend/plugins/blogger-importer/) plugin, and go and import all my old Blogger posts.  This worked pretty well, brought in all comments and posts, and linked them up right.  However, it did break some formatting in the posts - particularly with headings and blockquoted code segments.

I also had to spend a fair bit of time retagging and recategorizing all my posts to tidy them up.  Annoyingly you can't mass edit a group of posts and _remove_ a category easily, but you can mass edit and add categories and tags.  You can then strip categories off posts with MySQL queries if you're brave.

I also had to go through my posts and edit several of them to clean up the layout, insert preformatted blocks and headings and such.

Could have been a lot worse.

# Essential Plugins

The collection of plugins I have installed by default are;

  * <strong style="line-height: 1.714285714; font-size: 1rem;">Limit Login Attempts</strong> <span style="line-height: 1.714285714; font-size: 1rem;">- Helps prevent brute force attacks against your WP logins.  Easy to set up, no real reason not to have it. </span>
  * <strong style="line-height: 1.714285714; font-size: 1rem;">Jetpack by WordPress.com</strong> <span style="line-height: 1.714285714; font-size: 1rem;">- Adds a vast raft of features to your WP install.  You'll need to sign up for a WordPress.com account to get all the features, but it's worth it. </span>
  * <span style="line-height: 1.714285714; font-size: 1rem;"><strong>Google XML Sitemaps</strong> - Automatically notifies Google when your blog changes so that search works properly</span>
  * <span style="line-height: 1.714285714; font-size: 1rem;"><strong>Easy Table</strong> - Allows really easy table generation in blog posts.</span>
  * **Akismet** - Spam control for comments.

<span style="line-height: 1.714285714; font-size: 1rem;">All of the above are very easy to set up, and Jetpack in particular is a must have.</span>

# Cool stuff

With those plugins installed, you can do really cool stuff when posting that wasn't so easy with Blogger.  Some of those are...

## Maths Formulas with LaTeX

It's possible to use a special latex tag in order to make text get rendered using Latex, the defacto standard for mathematical typesetting.

<pre>$ latex <span style="color: #666666; font-family: Consolas;">\displaystyle \sin(x) = \displaystyle\sum_{n=0}^\infty \frac{(-1)^n}{(2n+1)!}\ x^{2n+1} = x - \frac{x^3}{3!} + \frac{x^5}{5!}- \frac{x^7}{7!}\ ...</span> &s=2$</pre>

When used somewhere will render as

<img src="//s0.wp.com/latex.php?latex=%5Cdisplaystyle+%5Csin%28x%29+%3D+%5Cdisplaystyle%5Csum_%7Bn%3D0%7D%5E%5Cinfty+%5Cfrac%7B%28-1%29%5En%7D%7B%282n%2B1%29%21%7D%5C+x%5E%7B2n%2B1%7D+%3D+x+-+%5Cfrac%7Bx%5E3%7D%7B3%21%7D+%2B+%5Cfrac%7Bx%5E5%7D%7B5%21%7D-+%5Cfrac%7Bx%5E7%7D%7B7%21%7D%5C+...+&#038;bg=ffffff&#038;fg=000&#038;s=2" alt="&#92;displaystyle &#92;sin(x) = &#92;displaystyle&#92;sum_{n=0}^&#92;infty &#92;frac{(-1)^n}{(2n+1)!}&#92; x^{2n+1} = x - &#92;frac{x^3}{3!} + &#92;frac{x^5}{5!}- &#92;frac{x^7}{7!}&#92; ... " title="&#92;displaystyle &#92;sin(x) = &#92;displaystyle&#92;sum_{n=0}^&#92;infty &#92;frac{(-1)^n}{(2n+1)!}&#92; x^{2n+1} = x - &#92;frac{x^3}{3!} + &#92;frac{x^5}{5!}- &#92;frac{x^7}{7!}&#92; ... " class="latex" /> 

That's pretty awesome.  Oh yeah, you don't actually have a space between the $ and the latex word above, I just had to put it there to stop it being interpreted.

## Easy Tables

With the Easy Table plugin, you can render a table very easily like this;

<pre>[ table class="table table-striped"]
Number,Letter
1,A
2,B
3,C
4,D
5,E
6,F
[/table]</pre>

And that will then render like this;

<div class="table-responsive">
  <table  style="width:100%; "  class="easy-table easy-table-default table table-striped" border="0">
    <tr>
      <th >
        Number
      </th>
      
      <th >
        Letter
      </th>
    </tr>
    
    <tr>
      <td >
        1
      </td>
      
      <td >
        A
      </td>
    </tr>
    
    <tr>
      <td >
        2
      </td>
      
      <td >
        B
      </td>
    </tr>
    
    <tr>
      <td >
        3
      </td>
      
      <td >
        C
      </td>
    </tr>
    
    <tr>
      <td >
        4
      </td>
      
      <td >
        D
      </td>
    </tr>
    
    <tr>
      <td >
        5
      </td>
      
      <td >
        E
      </td>
    </tr>
    
    <tr>
      <td >
        6
      </td>
      
      <td >
        F
      </td>
    </tr>
  </table>
</div>

Awesome.  Drop the space between [ and table, of course if you want to give it a go yourself.

## Preformatted text blocks

There are a few above.  They Just Work(tm) in WordPress, but in Blogger your experience can be random.

There's various other plugins that can be installed do do nice stuff like syntax highlighting for code and so-on.  I'll check those out later, but the plugins I've listed above do most things quite nicely.

All in all, I'm pretty happy with it so far.