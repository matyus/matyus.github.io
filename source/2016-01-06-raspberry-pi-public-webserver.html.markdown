---
title: Raspberry Pi Public Web Server
date: 2016-01-06
tags: raspberry pi, raspbian, ruby on rails
---

#Raspberry Pi Public Web Server

What does it take to get Raspberry Pi running as a public web server? This article will outline the basics of getting a Rails app started on a Raspberry Pi.


## Installing RVM

The Ruby Version Manager is worthwhile for two reasons: you have an easy way to maintain your version of Ruby, and secondly, you'll need the `rvmsudo` command to run your rails server publicly (more on that later).

Install `rvm` in Single-User Mode because then you won't have to worry about prefixing `sudo` every time you `gem install <some-gem>`. The [RVM Install](https://rvm.io/rvm/install) suggests installing it, and then adding the execution path to your `.bash_profile`, if you're using something like ZSH, then you're probably savvy enough to know that you're going to have to change `.bash_profile` to `.profile` or even `.zshrc` in the example:

    \curl -sSL https://get.rvm.io | bash -s -- --ignore-dotfiles
    echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile

The run the `rvm` command in your terminal to make sure it's working. The next thing I do is install the latest stable version of ruby (at the time of writing, it is `v2.3.0`).

    rvm install 2.3.0 --default


You'll notice that installing and compiling Ruby like this takes forever on a Raspberry Pi…

## Installing Rails

When I ran `gem install rails` it took forever, and then got hung up at the end when it was building the docs for the rails gem. So, if you don't want to risk that happening, build it without the docs:

    gem install rails --no-ri --no-rdoc

Once that's done, you're ready to create a new rails app.

## Running a Rails Server Publicly

Normally, to run a server in development, it's perfectly acceptable to run `bundle exec rails server`, but the default port `3000` isn't useful unless you're on localhost. Port `80` is where public servers run, and as a safety precaution, running `bundle exec rails server -p 80` will get an error that contains this information:

    /home/pi/.rvm/rubies/ruby-2.3.0/lib/ruby/2.3.0/socket.rb:205:in `bind': Permission denied - bind(2) for 127.0.0.1:80 (Errno::EACCES)

So that's where `rvmsudo` comes into play:

    rvmsudo bundle exec rails s -b 0.0.0.0 -p 80

`rvmsudo` is better than `sudo` because it carries all the ruby environment variables along with it. `-b` binds to any IP, and `-p` opens port 80. [More info](http://ruby.about.com/od/rubyversionmanager/qt/Rvm-And-Sudo.htm)

## We're almost there

So now, your server is pseudo-public, meaning that anyone connected to your WIFI network can freely access your rails server, most likely by visiting `http://raspberrypi.local/`. There's some port-forwarding magic that needs to happen if you're going to let the whole world visit your site.

We now have to enter the wonderful world of Optimum Online. If you're like me and recently signed up for internet access with Optimum, you'll notice that they included a Wifi router with the Modem installation. At first I thought this was weird, and silly, but now I'm realizing just how amazing it is...

## Optimum Wifi Config

Optimum, for some strange reason, went through all the trouble of providing a complete web interface for your router. What happens is when you visit `http://192.168.1.1` to access your Wifi config, it redirects you to an Optimum.net login screen where you can adjust the settings from.

What you need to do when you get to this landing page is navigate to `Router Settings > Advanced Settings > Advanced Settings > Port Manangement`. We're going to setup is **Portforwarding** so that you can tell your Modem that all Web requests go to the same place (the Rails server on the Pi).

Click "Add Port Forwarding Rule" to set it up so that the "Service" changes from "User-Defined Service" to "HTTP Web Access", this setting will bake in forwarding for ports 80, 8000, 8080, 8888, and 3127. Then change "Select a Host" to "`raspberrypi | MAC ADDRESS | IP ADDRESS`". Also update "Locate Device By" to "Host Name" radio button. Then save your changes.

Depending on your service plan, you may have to upgrade your access to actually gain control of ports 25 and 80. I found this out the hard way when I wandered onto a product page for [Port Configuration/Dynamic DNS service](https://www.optimum.net/internet/boost/):

> You do not currently have access to these features.
>
> In order to manage Port 25, Port 80 or Dynamic DNS, you must subscribe to Optimum Online Ultra 50, Optimum Online Ultra 75 or Optimum Online Ultra 101. Please visit optimum.com for more information or to upgrade your service.

Unfortunately I'm the cheapskate who needs to upgrade to _Optimum Online Ultra 50_.
is is an example article. You probably want to delete it and write your own articles!



