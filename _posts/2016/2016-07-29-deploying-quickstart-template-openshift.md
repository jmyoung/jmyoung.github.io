---
id: 933
title: Deploying a Quickstart Template to Openshift (GUI)
date: 2016-07-29T10:55:56+09:30
author: James Young
layout: post
guid: https://blog.zencoffee.org/?p=933
permalink: /2016/07/deploying-quickstart-template-openshift/
categories:
  - Technical
tags:
  - docker
  - linux
  - openshift
---
In my last post, I talked about how to set up a quick-and-dirty OpenShift environment on Atomic.  Here, we'll talk about firing up a test application, just to verify that everything works.

First, log into your OpenShift console, which you can find at (replace hostname);

<pre>http://os-master1.localdomain:8443/console</pre>

Once in, click the New Project button.  You'll see something like this;

[<img class="size-full wp-image-934 aligncenter" src="https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart1.png?resize=785%2C573&#038;ssl=1" alt="os-quickstart1" width="785" height="573" srcset="https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart1.png?w=785&ssl=1 785w, https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart1.png?resize=300%2C219&ssl=1 300w, https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart1.png?resize=768%2C561&ssl=1 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" data-recalc-dims="1" />](https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart1.png?ssl=1)

Enter `quickstart-project` for the name and display name, and click Create.  You'll now be at the template selection screen, and will be presented with an enormous list of possible templates.

[<img class="aligncenter size-full wp-image-935" src="https://i0.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart2.png?resize=774%2C540&#038;ssl=1" alt="os-quickstart2" width="774" height="540" srcset="https://i0.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart2.png?w=774&ssl=1 774w, https://i0.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart2.png?resize=300%2C209&ssl=1 300w, https://i0.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart2.png?resize=768%2C536&ssl=1 768w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" data-recalc-dims="1" />](https://i0.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart2.png?ssl=1)

Enter "quickstart django" into the list, then click 'django-example'.  Here is where you would normally customize your template.  Don't worry about that for now.  Scroll down the bottom

[<img class="aligncenter size-full wp-image-936" src="https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart3.png?resize=760%2C551&#038;ssl=1" alt="os-quickstart3" width="760" height="551" srcset="https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart3.png?w=760&ssl=1 760w, https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart3.png?resize=300%2C218&ssl=1 300w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" data-recalc-dims="1" />](https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart3.png?ssl=1)

You don't need to change anything, just hit Create.  You now get the following window;

[<img class="aligncenter size-full wp-image-937" src="https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart4.png?resize=763%2C565&#038;ssl=1" alt="os-quickstart4" width="763" height="565" srcset="https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart4.png?w=763&ssl=1 763w, https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart4.png?resize=300%2C222&ssl=1 300w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 984px) 61vw, (max-width: 1362px) 45vw, 600px" data-recalc-dims="1" />](https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart4.png?ssl=1)

Click Continue to overview.  While you can run the `oc` tool directly from the masters, it's better practice to not do that, and instead do it from your dev box, wherever that is.

If you've been stuffing around like I did, by the time you get to the overview, your build will be done!

[<img class="aligncenter size-large wp-image-938" src="https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart5.png?resize=840%2C328&#038;ssl=1" alt="os-quickstart5" width="840" height="328" srcset="https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart5.png?resize=1024%2C400&ssl=1 1024w, https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart5.png?resize=300%2C117&ssl=1 300w, https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart5.png?resize=768%2C300&ssl=1 768w, https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart5.png?resize=1200%2C469&ssl=1 1200w, https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart5.png?w=1255&ssl=1 1255w" sizes="(max-width: 709px) 85vw, (max-width: 909px) 67vw, (max-width: 1362px) 62vw, 840px" data-recalc-dims="1" />](https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2016/07/os-quickstart5.png?ssl=1)

Click the link directly under SERVICE, named `django-example-quickstart-project.YOURDOMAINHERE`.  You should now see the Django application splash screen pop up.

If so, congratulations!  You've just deployed your first application in OpenShift.

Have a look at the build logs, click the up and down arrows next to the deployment circle and watch what they do.