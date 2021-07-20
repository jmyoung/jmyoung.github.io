---
title: 'HP Reverb G2 Printed Accessories'
author: James Young
layout: post
categories:
  - gaming
tags:
  - 3dprinting
  - vr
  - reverb
---

I've got a [HP Reverb G2](https://www.hp.com/au-en/vr/reverb-g2-vr-headset.html) VR Headset, which I'm pretty happy with.  It requires some pretty serious GPU power to drive it though, which can be quite challenging.  While the headset as it comes out of the factory is pretty well right, there's some additional parts one can 3d print in order to improve it.

[This article](https://reverb.danol.cz/3d-printable-g2-accessories/) outlines a number of printable accessories.  While there's a lot of options, what I wound out printing was a lens adapter, an upwards cable clip, a replacement holding cable clip, and a replacement thinner gasket.

# Lens Adapters

I don't typically wear glasses, but my left eye is slightly short and astigmatic.  The right is slightly long and also astigmatic.  This leads to the headset being a bit uncomfortable visually due to being left eye dominant.  So, I went and printed a set of [HP Reverb G2 Zenni #550021 adapters](https://www.thingiverse.com/thing:4690554), and ordered the matching glasses.

I misunderstood the instructions and ordered the glasses for my actual IPD of 68mm, which means I needed to adjust the offsets in the Fusion360 model to 3mm.  If I had understood it better I would have ordered the glasses for a 63mm IPD (which matches the offset of the default STLs) and saved myself some trouble.  They printed perfectly, and are a nice push fit onto the lenses of the Reverb.  Visual clarity is dramatically improved, and due to both the left and right eyes now focusing well at the focal distance of the Reverb, stereoscopic convergence is much better.  Well worth making.  Total cost was about AU$33 including shipping for the glasses.

Note, you can't reduce the lens clearance from the default, otherwise even quite thin lenses will interfere with the Reverb's lenses.  You can make it longer though if your lenses are quite thick.

# Upwards Cable Clip

This [Upwards Cable Clip](https://www.thingiverse.com/thing:4705425) is a simple model that threads through the original Velcro head strap and provides a ring that the cable runs through.  It redirects the cable to come out the top of the headset instead of the back, which aids in strain relief particularly if you're using a pulley.  It seems to Just Work, which is nice.

# Holding Cable Clip

This [Holding Cable Clip](https://www.thingiverse.com/thing:4723188) replaces the standard cable clip on the back of the unit, and holds the cable in place for strain relief on the connector.  It's a little tight on my cable, but it should offer a better solution than having all the strain right on the connector.  Note, when you tilt the headstrap up, the cable will pull on the connector, so make sure if you're using this you provide enough strain relief from having the cord not tight when you use the clip.

# Danol Gasket

This [Danol Gasket](https://www.thingiverse.com/thing:4735821) is a replacement face gasket, which is designed to be thinner and improve FOV.  It's also wider, which is better for those of us with giant heads like me.  Printing it as it was and using it with the Lens Adapters resulted in my eyelashes brushing the lenses.  This may vary for each individual based on the precise geometry of your face.

In my case, I reprinted the gasket with a 2.3mm extension, bringing the `distanceFromLenses` parameter from 8mm to 10.3mm.  I found that I could not select any value between those, because it broke the model somehow.  After reprinting the gasket, it works fine - my eyelashes don't brush the lenses and I have an expanded field of view.

However, I'm not sure if I'll use it in the long term.  I tend to play flight sims, and the expanded FOV comes at a cost of reduced pixel count in the fovea region of the eye.  I'll have to mess about with it more and see what I prefer.  I did notice that when using the gasket, peripheral vision is much improved, but it was harder to clearly read instrumentation.  I'm not sure whether this was just the fit for that day or what.  More experimentation is required.
