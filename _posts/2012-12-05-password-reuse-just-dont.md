---
id: 15
title: 'Password Reuse &#8211; Just Don&#8217;t.'
date: 2012-12-05T06:59:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=15
permalink: /2012/12/password-reuse-just-dont/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2012/12/password-reuse-just-dont.html
categories:
  - Computers
tags:
  - security
---
Another XKCD to illustrate poignantly the evil that is password re-use;

<table align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <a href="https://i0.wp.com/imgs.xkcd.com/comics/password_reuse.png" imageanchor="1"><img border="0" height="320" src="https://i0.wp.com/imgs.xkcd.com/comics/password_reuse.png?resize=129%2C320" width="129"  data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Courtesy <a href="http://xkcd.com/792/">XKCD 792</a>
    </td>
  </tr>
</table>

Many people re-use the same password (or a simple permutation of a master password) in multiple locations.  **Don't do this!**

The greatest threat to your passwords in modern times isn't brute force guessing (assuming you haven't picked something really terrible like your name and birthday).  It's having an account sniffed/compromised/phished in one place, and then that same password being successfully used to compromise another service.

This sort of thing happens **all the time**.  If you don't believe me, go search the Web for articles about companies losing cleartext password databases.

You also shouldn't use passwords where the name of the service is bound up in the password, thus enabling an attacker to determine what your password may be for other services (eg, 'facebookilovepuppies2012' gives an attacker a pretty good indication your Paypal password may be 'paypalilovepuppies2012').  Each service should have its own, unique password.

## But that's a pig to remember!

Yes, it is.  However, there are various services around that can help out, such as [LastPass](http://lastpass.com/), [1Password](https://agilebits.com/onepassword), among many others.  Make sure your master password you select to unlock the others is a good one, and you don't use it anywhere else.

## But, an important safety tip...

Don't go locking yourself out of everything by forgetting your master password.  Make sure you provide yourself a way to get back into wherever you have stored all your passwords without requiring a password (which you might forget).  I'm going to say something now that flies in the face of what we've been told by the IT Industry for decades;

<div>
  <strong>It's OK to write passwords down on paper.</strong>
</div>

... as long as you store the paper somewhere safe.  Writing down your master password on a Post-It and sticking it on your monitor at work is a bad idea.  Putting it in a sealed envelope with your will being held by your attorney is a good idea.  Even putting your master password in your wallet is a reasonably safe idea, since anyone who steals your wallet is unlikely to know what to do with it before you go and change it (putting your ATM card's PIN in your wallet is a bad idea however).

Also pay attention to any security unlock emails required for these services.  Don't put in a security unlock email address which requires a password that you need the service to get into!  Using your ISP's email address isn't a bad idea, since you can walk up to your ISP's head office with a driver's license and get them to reset your password to get back into that even if you suffer from a blow to the head and forget everything at once.

## So, in summary...



  * Use unique passwords for everything.
  * Make sure you always have a way to get back into your password databases.
  * It's OK to write down passwords if you store them somewhere safe.