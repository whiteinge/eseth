.. _dotfiles:

========
Dotfiles
========

.. index:: computing, unix, zsh, screen, vim

:pubdate: 2005-10-08

I've long enjoyed painstakingly constructing dotfiles or \*rc files for
various programs I use frequently. They allow such exact configuration and
are so portable between systems. :ref:`If only Firefox worked so simply
<firefox-boxen-hopping>`.

Here are some of mine:

*   Zsh is an amazing shell. It has unbelievable completion abilities,
    and is just gorgeous (pictured). I enjoy Vi-mode in my shells and :rc:`my
    zshrc has a Vi-style mode display <zshrc>` that I cobbled together from a few
    examples on the 'net. It also includes a small shell-function called
    `dotsync() <zshrc@9366c5b532a5#228>` that keeps the rest of these dotfiles current.
*   I've spent days of my life fine-tuning the :rc:`best goddamn vimrc in the
    whole world <vimrc>`. Parts of it are very much tailored to me, but I've tried
    to comment all my reasons for each option.
*   GNU screen brings tabs and resume-able sessions to your command-line work,
    this utility is too useful to overlook. :rc:`My screenrc file illustrates
    tabs <screenrc>` as best as possible (pictured).

There's no reason you should work with an ugly terminal. It's 2005, your
computer can handle it. And nothings beats sitting down at a new computer and
typing ``dotsync`` to have your shell, editor, and browser preferences and
bookmarks instantly configured just they way you like 'em. :-)

.. note:: Update 2009-12-16

    I have long-since switched from the home-rolled dotsync() to keeping my
    \*rc files under version control.

.. image:: ./colorterm.jpg
    :alt: My terminal running Gnu screen and Vim

.. _my zshrc has a Vi-style mode display: ../filez/prefs/zshrc
.. _My screenrc file illustrates tabs: ../filez/prefs/screenrc
.. _`best goddamn vimrc in the whole world`: ../filez/prefs/vimrc
