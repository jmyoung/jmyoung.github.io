---
id: 138
title: Making your own OpenSSL Certification Authority (CA)
date: 2013-04-15T16:03:19+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=138
permalink: /2013/04/making-your-own-openssl-certification-authority-ca/
categories:
  - Technical
tags:
  - linux
  - openssl
---
If you want to make your own CA, usually for the purposes of signing certificates internally for testing and such, you can do that pretty easily with CentOS.  On a secure box somewhere, you'll need to create a CA certificate.

Edit **/etc/pki/tls/openssl.cnf** and change the various entries to match the name etc for your organization, then do the following;

<pre>touch /etc/pki/CA/index.txt
echo '01' &gt; /etc/pki/CA/serial
openssl req -new -x509 -keyout /etc/pki/CA/private/cakey.pem -out /etc/pki/CA/cacert.pem -days 3650</pre>

The above will generate an OpenSSL local CA with an expiry date 10 years in the future.  Now, after doing that you'll have to copy your new cacert.pem into your trusted store so your machine will automatically trust it.

<pre>cp /etc/pki/CA/cacert.pem /etc/pki/tls/cacert.pem
ln -s /etc/pki/tls/cacert.pem `openssl x509 -noout -hash -in /etc/pki/tls/cacert.pem`.0</pre>

The above will generate a symlink with the hash code of the certificate and place it in the right spot.  You should now distribute cacert.pem as appropriate to the places that should trust it.

Now, we'll generate a simple certificate, sign it, and verify the signature;

<pre>openssl req -new -nodes -keyout server.example.com.key -out server.example.com.csr
openssl ca -policy policy_anything -out server.example.com.crt -infiles server.example.com.csr
openssl verify server.example.com.crt</pre>

You should see an 'OK'.  If you don't, go over everything again, in particular make sure that the symlink was created properly.