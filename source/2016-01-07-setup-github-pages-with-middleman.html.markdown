---
title: Setup Github Pages with Middleman
published: false
description: How to use Middleman for a GitHub user page.
date: 2016-01-07
tags: github, github pages, middleman
---

# Setup Github Pages with Middleman

The main reason why I'm using Middleman instead of Jekyll is that Middleman is significantly more *modular*. By default Middleman is just a static site generator that you can use to build any kind of website. However, if you're going to use it for blogging, there's a gem that you can add, aptly named [`middleman-blog`](https://github.com/middleman/middleman-blog), which will set you up with the fundamental parts of a blog: layouts for calendars, tags, and obviously posts. (Jekyll sets you up with all of the blog-awareness even if you don't necessarily want it.)

The Middleman community is pretty active, and you'll find there's a [growing list](https://directory.middlemanapp.com/#/extensions/all/) of extensions. For instance, setting up syntax highlighting for code samples (like in this blog post) was extremely easy with the [`middleman-syntax`](https://github.com/middleman/middleman-syntax) gem.


## Github User Pages vs. Project Pages

The most important thing to know when creating a "GitHub Pages" for your username is that User pages ignore the `gh-pages` branch that Project pages rely on. What this means is that if you're using something besides Jekyll (ie. Middleman) then you have to keep your source on a branch besides `master`, and then copy the built files as the root of the `master` branch.

It's easier to understand if you just look how I setup my project:

Compare the structure of my [Master](https://github.com/matyus/matyus.github.io/tree/master) branch with my [Dev](https://github.com/matyus/matyus.github.io/tree/dev) branch.

## But don't gems exist for this?

Only if you use a version that's less than `Middleman v4`  then the gems `middleman-deploy` and `middleman-gh-pages` will not work.


## Setup

Using my repo as an example, I keep two copies of the repo side-by-side like so:

```bash
# container for everything
$ mkdir my-blog/

$ cd my-blog/

$ git clone git@github.com:matyus/matyus.github.io.git blog-source
# then checkout this folder on the dev branch

$ git clone git@github.com:matyus/matyus.github.io.git blog-deploy
# keep this folder on the master branch
```

When you're done, it should reflect this:

```bash
|- my-blog/
|   |- blog-source/ #dev branch
|   |- blog-deploy/ #master branch
|   `- deploy.sh
```

What's going on is that `blog-deploy` is an orphaned copy of `blog-source`. The `deploy` folder **only ever has the built files as the root of the project** while the `source` folder only ever needs to be on the `dev` branch. Dev is where you run `middleman build` so that you can then copy those built files to the root of `master`.

## Deploying

Below is my deploy script:


```bash
#!/bin/bash

# copy the files from the latest build/ directory into empty folder:
cp -Rv blog-source/build/* blog-deploy/

# change-directory into the deploy folder
cd blog-deploy/

# add all the file changes and make a commit
git add --all

# this script requires a commit message
git commit -m "$1"

# push changes and then check <username>.github.io
git push origin master
```

So when I'm ready to deploy, I run it like this:

```bash
$ cd my-blog/

# commit message must be in quotes.
$ ./deploy.sh "this is my commit message"
```

## Process Recap

What I do is keep my working files on a branch called `dev`, and when I'm done with my update I just run `middleman build` and then `cd ..` and run the `deploy.sh` script which copies those built files in `blog-source` to  `blog-deploy` and commits them to `master`.

## Feedback

I really hope there's a better way to do this, if you have an idea please let me know!
