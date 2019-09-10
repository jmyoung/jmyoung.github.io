---
id: 16
title: Password Selection
date: 2012-12-05T05:27:00+09:30
author: James Young
layout: post
guid: http://wordpress/wordpress/?p=16
permalink: /2012/12/password-selection/
blogger_blog:
  - coding.zencoffee.org
blogger_author:
  - James Young
blogger_permalink:
  - /2012/12/password-selection.html
categories:
  - Computers
tags:
  - security
---
The following sums up about what this post will be regarding perfectly.

<table cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td>
      <a href="https://i1.wp.com/imgs.xkcd.com/comics/password_strength.png"><img alt="" src="https://i1.wp.com/imgs.xkcd.com/comics/password_strength.png?resize=320%2C259" width="320" height="259" border="0" data-recalc-dims="1" /></a>
    </td>
  </tr>
  
  <tr>
    <td>
      Courtesy <a href="http://xkcd.com/936/">XKCD 936</a>
    </td>
  </tr>
</table>

As it turns out, the IT Industry has spent an awful lot of time trying to convince people use horribly complicated passwords which are terribly difficult for a human to remember.  But they're really easy for a computer to guess.  This leads to a number of security failures that people do to try and fit into the restrictions of their systems;

  * They use a password which is based on a single dictionary word and then tack on some symbols to fit into the requirements of whatever system they're using.  Enter stuff like 'Password2012!'.
  * They use the same base password, and then just increment some number at the end every time it expires.  So they wind up using 'Password15', 'Password16' and so on.
  * They use a decent password, but use it everywhere.  I'll talk about password re-use later.
  * They use a decent password, but it's derived from a formula where the name of the service or similar is bound into the password, making it easy to reverse engineer the password.  For example 'Myhotmail1!' or something like that.

Now, mathematically speaking, a long password is VERY MUCH harder to guess than a shorter, but more complex one.  The above cartoon illustrates this.  Selecting words in your native language, if you pick enough of them, is much much more secure than a nearly random bunch of punctuation and capital letters.

## Why are random words easier to remember?

Interestingly, such a password is actually easier for a human to remember than a complex symbol-based password.  Why?  Because human memory works in symbols.  Your memory can store in correct order between 6-8 symbols with not too many transposition errors.  Four symbols is trivial to remember.  Your memory is able to store words in your native tongue as individual symbols, so a string of four random words is stored as only four symbols - easy to remember, easy to get in the right order.  However, the complex password above with punctuation symbols will be stored by your memory as several symbols - one will be the dictionary word you've based it on, then individual symbols for all the permutations you made to it.  Suddenly you're trying to store 6 or more symbols in your memory at once.  This is near your upper limit, and transposition errors and other mistakes creep in.

## So quotes and stuff are great, right?

Actually, no.  See, it turns out that humans are absolutely terrible at picking random strings of text.  Cracking dictionaries now contain the most common quotes that people tend to use, meaning their effective strength is greatly reduced.

You're best off selecting a number of RANDOM words.

## Ok, so REALLY random words.  What do we do?

Which brings us to the following resources;

  * XKCD's Password Generator - <http://passphra.se/>
  * ZenCoffee's Password Generator - <http://www.zencoffee.org/passwordgenerator/>

The password generator I wrote uses the [General Service List](http://en.wikipedia.org/wiki/General_Service_List), a list of ~2k commonly-used English words.  The list used is very similar to the list that the XKCD Generator uses, with the notable exception that my generator uses a Mersenne Twister random number generator, which produces much better quality random numbers than the random() implementation in base JavaScript.  Both generators use client-side Javascript so they don't record or otherwise log any of the passwords generated.

The beauty here is that it doesn't matter if the word list is publically available.  It doesn't matter that the algorithm used to generate the passwords is published.  The generated passwords are still strong.

Go forth and pick good passwords!

### References:

  * XKCD - Password Strength:  <http://xkcd.com/936/>
  * Baekdal - The Usability of Passwords:  <http://www.baekdal.com/insights/password-security-usability>
  * Wikipedia - Short-Term Memory:  <http://en.wikipedia.org/wiki/Short-term_memory>
  * IRE Transactions on Information Theory - Human Memory and the Storage of Information:  <http://ieeexplore.ieee.org/xpls/abs_all.jsp?arnumber=1056815&tag=1>