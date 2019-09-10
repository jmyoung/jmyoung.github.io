---
id: 153
title: Creating and signing an SSL cert with alternative names
date: 2013-04-22T13:47:06+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=153
permalink: /2013/04/creating-and-signing-an-ssl-cert-with-alternative-names/
categories:
  - Technical
tags:
  - linux
  - openssl
---
In my previous post I outlined how you can create your own self-signed CA.  With that CA in hand, you should be able to deploy your CA public certificate in any place you want certificates signed by it to be trusted, and then create your own SSL certificates.

# Signing an existing CSR (no Subject Alternative Names)

Making an SSL certificate is pretty easy, and so is signing a CSR (Certificate Signing Request) that you've gotten from something else.  Essentially, you do this;

<pre>openssl ca -policy policy_anything -out server.example.com.crt -infiles server.example.com.csr</pre>

You should then have three main artifacts from that process -

  * **CSR file** - This can now be deleted.  The CSR is only used for the signing process, to decouple the private key from the signed public key.
  * **KEY file** - This is the private key that was generated when you created the CSR.  This bit is secret, and should be kept safe.  Notably, the machine doing the signing does not need the KEY at any time, this is what the CSR is for.
  * **CRT file** - This is the public certificate signed by your CA which you add to your service.

Now, that's all peachy, but what happens when you have a certificate with Subject Alternative Names (SANs) attached?  It's possible for a CSR to contain SANs, but the signer does not have to include all SANs requested, and can add SANs themselves when they sign.  How do we handle that?

# Creating a CSR with embedded SANs

In order to do this, you'll need to copy **/etc/pki/tls/openssl.cnf** somewhere, and then edit it.  Let's assume you've called it '**server.example.com.cnf**'.

Go and find the **[ req ]** section, and add the following;

<pre>req_extensions = v3_req</pre>

This causes the v3_req section to be read when you make a request (ie, when you generate a CSR using this config file).  Then, make the **[ v3_req ]** section look something like this;

<pre>[ v3_req ]
# Extensions to add to a certificate request

basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names</pre>

These constraints prevent this certificate being used to make a new CA (a bloody good idea for most things), and specify some normal key usage restrictions - notably this certificate can't be used for code signing.  Typically you won't need that for most purposes.  And notably, we import the alt_names section to define all the Subject Alternative Names.

And lastly, make a new section called [ alt_names ] which looks something like this (include ALL the Subject Names you may want, you can have up to a hundred of them);

<pre>[ alt_names ]
DNS.1 = www.server.example.com
DNS.2 = server.example.com</pre>

Then, you create the key and CSR like this;

<pre>openssl req -new -nodes -keyout server.example.com.key -out server.example.com.csr -config server.example.com.cnf</pre>

You'll wind out with a new CSR which will have the embedded SANs.

# Signing a CSR with embedded or desired SANs

Remember how I said that a signer doesn't have to use the SANs embedded in the CSR?  This is where things might get annoying, but fortunately because you have the openssl.cnf you used to create the CSR, it's actually pretty easy.

First up, let's have a look at the CSR and see what SANs were requested;

<pre>openssl req -text -noout -verify -in server.example.com.csr</pre>

Scroll down and look for the **X509v3 Subject Alternative Name** section.  Now, if you want to include all those SANs, then the openssl.cnf you used to sign will have to have all those SANs already defined.  Plus you can add some more if you want (like, if someone forgot to request www.foo.com as a SAN).  Let's assume that you're just going to sign the CSR you made from above, and you already have an openssl.cnf that's all good.

Sign the CSR using a custom openssl.cnf file;

<pre>openssl ca -policy policy_anything -out server.example.com.crt -config server.example.com.cnf -extensions v3_req -infiles server.example.com.csr</pre>

Doing this forces the v3\_req section to be included (it normally wouldn't), which then enforces all the SANs specified in the alt\_names section you defined above.

And then finally, check the resulting certificate;

<pre>openssl x509 -text -noout -in server.example.com.crt</pre>

You should see the SANs defined in the **X509v3 Subject Alternative Name** section, along with all the other constraints.