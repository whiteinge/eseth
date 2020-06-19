TITLE({"Dotfiles"})
CATEGORY({"computing, unix, zsh, screen, vim"})
DATE({"2005-10-08"})

Dotfiles
========

I've long enjoyed painstakingly constructing dotfiles or \*rc files for
various programs I use frequently. They allow such exact configuration
and are so portable between systems. [If only Firefox worked so
simply](../2006/firefox-boxen-hopping.html).

Here are some of mine:

-   Zsh is an amazing shell. It has unbelievable completion abilities,
    and is just gorgeous (pictured). I enjoy Vi-mode in my shells and
    [my zshrc has a Vi-style mode
    display](https://github.com/whiteinge/dotfiles/blob/master/.zshrc)
    that I cobbled together from a few examples on the 'net. It also
    includes a small shell-function called
    [dotsync](https://github.com/whiteinge/dotfiles/blob/6a2377c/.zshrc#L228)
    that keeps the rest of these dotfiles current.
-   I've spent days of my life fine-tuning the [best goddamn vimrc in
    the whole
    world](https://github.com/whiteinge/dotfiles/blob/master/.vimrc).
    Parts of it are very much tailored to me, but I've tried to comment
    all my reasons for each option.
-   GNU screen brings tabs and resume-able sessions to your command-line
    work, this utility is too useful to overlook. [My screenrc file
    illustrates
    tabs](https://github.com/whiteinge/dotfiles/blob/master/.screenrc)
    as best as possible (pictured).

There's no reason you should work with an ugly terminal. It's 2005,
your computer can handle it. And nothings beats sitting down at a new
computer and typing `dotsync` to have your shell, editor, and browser
preferences and bookmarks instantly configured just they way you like
'em. :-)

_Update 2009-12-16_

I have long-since switched from the home-rolled dotsync() to keeping my
\*rc files under version control.

![My terminal running Gnu screen and Vim](./colorterm.jpg)
