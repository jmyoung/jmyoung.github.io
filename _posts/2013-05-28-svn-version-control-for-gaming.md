---
id: 616
title: SVN Version Control for Gaming
date: 2013-05-28T11:17:52+09:30
author: James Young
layout: post
guid: http://blog.zencoffee.org/?p=616
permalink: /2013/05/svn-version-control-for-gaming/
categories:
  - Gaming
tags:
  - gaming
  - subversion
---
[DCS World](https://www.digitalcombatsimulator.com/en/world/) is a big, complex game.  And it gets updated a fair bit.  And sometimes, just sometimes those updates break it.  In addition, I make customizations to the game's scripts to make it work with my setup, and so I tend to lose those changes every update.  A better solution is required.

Enter [Subversion](http://subversion.apache.org/) (SVN).  Subversion is a version control system usually used for managing versioning for source code.  It allows you to commit changes into a repository, roll back changes if required, and also bundle up sets of changes into branches or tags.

It's possible to set up your own local SVN repository and use that to manage game installations like this, even if the game is already installed.  First, go and get [TortoiseSVN](http://tortoisesvn.net/) and install it.  Then, go and edit the security settings for your game folder so you can have write access to it without needing to elevate (if you're using Vista/7/8).

For this example, the game we'll be bringing into versioning will be in **D:\Example\Game**, and we'll be making a local SVN repository in **D:\Example\SVN**.  We'll do an initial import, tag it, edit some stuff, commit a new tag, and roll back.

# Step 1 - Create the Repository

Create the folder D:\Example\SVN, however you're going to.  Then right click on it, and click TortoiseSVN.  Click Create repository here.

[<img class="aligncenter size-full wp-image-617" alt="Create SVN Repository" src="https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2013/05/step1.png?resize=529%2C234" width="529" height="234" data-recalc-dims="1" />](https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2013/05/step1.png)

Now, in the dialog box that appears, click "Create folder structure" followed by OK.

[<img class="aligncenter size-full wp-image-618" alt="Create default folders" src="https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2013/05/step2.png?resize=405%2C225" width="405" height="225" data-recalc-dims="1" />](https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2013/05/step2.png)

# Step 2- Importing Content

Now, right click on your game folder, then click TortoiseSVN, Import.  This will open the Import dialog;

[<img class="aligncenter size-full wp-image-619" alt="SVN Import Settings" src="https://i0.wp.com/blog.zencoffee.org/wp-content/uploads/2013/05/step4.png?resize=478%2C358" width="478" height="358" data-recalc-dims="1" />](https://i0.wp.com/blog.zencoffee.org/wp-content/uploads/2013/05/step4.png)

Edit the repository URL to **file:///D:/example/SVN/trunk** .  This causes the folder to be imported into the trunk of the SVN repository.  Type in a sensible import message, like "Initial import of version FOO".  Tick "Include ignored files" to make sure you get absolutely everything, and hit OK.

Wait.  This will take a while.  All the content in that folder is being imported into the repository and being marked.  Note that this will take a fair amount of disk space, but disk space usually isn't at a real premium these days.

# Step 3 - Changing over your install to the SVN Repository

Now that you've imported everything, you have something scary to do.  You're going to delete/move your entire game folder somewhere else and then check out SVN into it.

Go into your game folder, and move its entire contents somewhere else, or delete them.  You want that entire folder clear.  Then, right click on the game folder, and click SVN Checkout.

[<img class="aligncenter size-full wp-image-620" alt="SVN Checkout" src="https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2013/05/step5.png?resize=484%2C396" width="484" height="396" data-recalc-dims="1" />](https://i1.wp.com/blog.zencoffee.org/wp-content/uploads/2013/05/step5.png)

Make sure that the repository URL is the location that you imported the folder into (the trunk of your SVN repository).  Make sure that the checkout directory is the game directory you just cleared.  And check out the HEAD revision (this means the latest revision in SVN).

This will also take a while to run.  Once it's done, you should see a green check mark on the game folder.  This means that the folder and all its recursive contents are consistent with SVN.  Congratulations.  Now we need to learn how to do some SVN housekeeping.

# Committing changes to the trunk

The trunk is where the main, currently active version of your game should reside.  This is what you currently have checked out.  Now, let's assume you just ran a game update, and it modified files and added some new ones. The modified ones are picked up with a red cross, the new ones are missed.  In order to commit all the new files into SVN, we'll need to do a commit.

Right click on the game folder, then click Commit.

[<img class="aligncenter size-full wp-image-621" alt="SVN Commit Dialog" src="https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2013/05/step6.png?resize=637%2C536" width="637" height="536" data-recalc-dims="1" />](https://i2.wp.com/blog.zencoffee.org/wp-content/uploads/2013/05/step6.png)

In this box, review the list of changes made.  Make sure that 'Show unversioned files' is selected - this will show you files that got added to the game's folder since the last commit.  This is vital so you can add files that may have been added by the patcher.  Tick 'Check: All' if you're happy with the list of changes made, enter a reasonable message and click OK.

All the changes made will be commited into the repository you have checked out (most likely the trunk), and that version will then be the new head revision.

# Making a tag

Tags are commonly used to mark a specific revision of your SVN repository.  For our purpose, we have a perfect use for tags - saving specific versions of our game.  Let's assume that the current committed version is version 1.1 of the game and you want to make a tag for that so you can roll back to it at another stage.

First, we'll need to create a folder in your repository for tags to live.  Right click on your game folder, then click TortoiseSVN and Repo-browser.

In the repository browser, right click on the very top of your tree on the left, and click Create Folder.  Name the folder 'tags'.  Run through the message box, and let it finish.  Then click on the top of the tree, right click and click Refresh.  You should now see the 'tags' folder.  Hit OK on the repository browser to close it.

Now, right click on your game folder, which should already have all the changes committed, click on TortoiseSVN, then click "Branch/Tag...".

[<img class="aligncenter size-full wp-image-622" alt="SVN Branch/Tag Dialog" src="https://i0.wp.com/blog.zencoffee.org/wp-content/uploads/2013/05/step7.png?resize=569%2C595" width="569" height="595" data-recalc-dims="1" />](https://i0.wp.com/blog.zencoffee.org/wp-content/uploads/2013/05/step7.png)

In this box, change the path to **/tags/release-1.1** .  This is what you're going to create the tag as.  Note that your source data is from the trunk.  Enter an appropriate log message, and hit OK.  Creating a tag from existing committed data is very fast, and takes very little disk space.  You can select 'HEAD revision' to definitely create the tag from the head revision, otherwise it'll use whatever revision you currently have checked out to make the tag.  Or the working copy of the data (which may have uncommitted changes).

If you now go into the Repo Browser you'll see your created tags under /tags .

# Reverting to the currently checked out revision

Let's say you accidentally blew up some files, or a patch went bad or similar.  There's a few ways you can revert effectively, but you need to be able to revert a few kinds of changes;

  * Files that were modified
  * Files that were deleted
  * Files that were added

Now, by definition all files that were added will be unversioned.  So, right click on your game folder, click TortoiseSVN, then click Revert.  Check 'Select all' to make sure everything's selected and review the list.  Now click 'Delete unversioned items' review that list, and hit OK to clear out any items that were added by accident.  Finally, hit OK on the Revert dialog box to revert back to the checked out revision.

Your install is now back the way it was.  Easy!

# Reverting to a different tag

Let's say that you need to (for some reason) roll back to a whole different release you previously tagged.  First, make sure that your currently checked out working copy is all committed and OK, since it's going to go away in a moment.

Right click on the game folder, then click TortoiseSVN, Switch.  Click the '...' next to the dialog box, and go find the tag you want to switch to.  Hit OK, and your working copy will change to the tagged release.

**WARNING!**  When you switch, your working copy is no longer of the trunk revision!  It's now of the tagged revision!  This means that if you commit any changes, they will be commited to the _tag_, not to the trunk.  This is probably not what you want.  Then again, it may be.  Just be aware that a switched working copy is no longer of your trunk, and that tags aren't necessarily static.  Note that at any time, you can review the commit log for the trunk or a tag so you can review what was changed.  This is why messages are so important.

To change back to the trunk, repeat the process, but select '/trunk' as the path.  Select 'HEAD revision' to make sure you get the latest revision of the trunk.

# Conclusions

With those basic processes, you can use TortoiseSVN to manage updates and do version control for all sorts of things - including game files which are largely binary.  The basic scenarios you'll need to handle with SVN are;

  * **Saving a working game update:**  Commit, then Tag the HEAD revision appropriately.
  * **Reverting broken, uncommitted changes to the HEAD revision:**  Revert, selecting to delete all unversioned files.
  * **Switching to a previously tagged release:**  Switch to the tag you made.  Keep in mind that your working copy is now the tag, not the trunk.

Have fun!