m4TITLE({"Browse devdocs.io from the CLI"})
m4CATEGORY({"computing, unix"})
m4DATE({"2020-01-25"})
m4SUMMARY({"Browse devdocs.io from the CLI with a fuzzy-finder and Lynx"})

# Browse devdocs.io from the CLI

Hopefully you're already familiar with
[https://devdocs.io/](https://devdocs.io/) but if not go use it and then come
back. It's a great way to quickly drill down on reference documentation for
a big list of available docs, and it works completely offline. I use it
constantly.

My daily workflow involves a full-screen web browser and a full-screen terminal
so it's not out of my way to pull up devdocs.io at any time. However, I do tend
to prefer terminal workflows. The devdocs.io folk have a pretty simple layout
to lookup topics in an index and then fetch the full docs for that topic, and
it turns out it's not too hard to do that using jq, Lynx, and a fuzzy-finder:

<video src="./devdocs-io-cli.webm" controls loop preload="none" width="100%"></video>

The code is currently a tad opinionated and uses a couple things from my
dotfiles so it's not exactly a drop-in install but hopefully it could be
a starting point for your own implementation. You can view it here:

[https://github.com/whiteinge/dotfiles/blob/9b3650b/bin/devdocs-local](https://github.com/whiteinge/dotfiles/blob/9b3650b/bin/devdocs-local)
