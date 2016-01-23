---
title: Vim :substitute Tricks & Tips
description: A few extremely powerful tricks and tips for vim's substitute command.
date: 2016-01-23
tags: vim, tricks and tips
---

#Vim :substitute Tricks & Tips

I sometimes look up the documentation of commonly used methods to see if they have other features that I'm not aware of. For instance, did you know in that in Javascript you can construct an empty array just by passing the constructor an integer (`new Array(10)`)? I'm not sure why you'd need to do that …[but you can](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array#Syntax).

Below are a couple Vim tricks that I've recently unearthed!

###Finding and Replacing URLs or File Paths

If you use Vim, you know how annoying it is to have to search of file paths, because you need to escape every forward slash.

For example, if you want to replace `http://mysite.com/path/to/awesome/thing.html` with `http://myothersite.com/path/to/other/thing.html`, it might look something like this:

    :s/http:\/\/mysite.com\/path\/to\/awesome\/thing.html/http:\/\/myothersite.com\/path\/to\/other\/thing.html/g

However, you should know that Vim is ridiculously flexible, and you should know that you can change the delimiters (using `#`) on the fly to simplify this action:

    :s#http://mysite.com/path/to/awesome/thing.html#http://myothersite.com/path/to/other/thing.html#g


Isn't that beautifully simple?


###Replacing Subsets of a Pattern

Let's say you have a really long css selector, like `.section-subsection-box-thing`, and you need to change `box` to `module`. It might be too risky to find and replace ALL occurrences of the term "`box`" if you use it elsewhere in the document. For example, there might be occurrences of `box-sizing: border-box;`. A naïve find-and-replace would alter your css selector, but it would also change your declaration, giving you: `module-sizing: border-module;`. Bleh.

If you are like the old me, you might decide to be super explicit by replacing the entire phrase: `:s/section-subsection-box-thing/section-subsection-module-thing/g` which at the end of the day isn't a big deal.

But doesn't it just _feel_ like there should be a better way? Well there is! There's nifty flags for __start and end of pattern__ that look like this:  __`\zs`__ and __`\ze`__.

Using the example of having to replace `section-subsection-box-thing`:

    :s/section-subsection-\zsbox\ze-thing/module/g

Isn't that _also_ beautifully simple?

Source: [http://vim.wikia.com/wiki/Search\_and\_replace](http://vim.wikia.com/wiki/Search_and_replace)
