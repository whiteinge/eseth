:pubdate: 2007-04-09

.. _vim-buffers:

===================================================
How I learned to stop worrying and love Vim buffers
===================================================

.. index:: computing, vim

Background
~~~~~~~~~~

Over the past six years I have used Vim with increasing exclusivity. I have
read a couple books (`User Manual`_, `Learning Vi`_) on Vim from cover-to-
cover. But I have always tried to use Vim as though it was a modern, tabbed
editor, `even before it had tabs`_. Once Vim 7 was released with support for
actual tabs, I ecstatically dove right in. I aliased ``vim`` to ``vim -p``
and created my own MyTabLine function displaying the tab number to make it
easier to jump from tab-to-tab, for example, ``8gt`` to jump to the eighth
tab. But many tabs get unwieldy and Vim quickly runs out of screen space to
display them all. It became apparent that I (and others, upon a cursory
glance at the mailing list) was trying to force a certain, modern, usage
pattern on tabs that did not fit the Vim editing pattern well.

In Vim, a buffer is a file that you have open in the editor (even if it's not
currently displayed), and a window is a view of a buffer. Well tabs in Vim 7
are really just views for windows. There isn't a mechanism in Vim to tie a
certain buffer to a certain tab [1]_ which would fit better with the modern
idea of tabs. This was *finally* impressed on me while watching `Bram
Moolenaar describe tabs`_: he doesn't use them! They are really intended to
group Vim windows without having to resort to multiple xterms or GNU Screen
windows.

.. [1] The plugin `minibufexplorer`_ actually does a very good job of mapping
    one (virtual) tab to one buffer--which may explain why it's the second-
    highest rated script on vim.org. I highly recommend using it as a sort of
    "training wheels" for eventually using buffers without a visual aid, as it
    allows you to see all available buffers as you edit.


How the old guys use Vim
~~~~~~~~~~~~~~~~~~~~~~~~

There's a third opinion in the perpetual Emacs vs. Vim holy war written by
one of those grumpy, uphill-both-ways, old guys [2]_. In an excellent
writeup of his favored text editor he mentioned something that got me
thinking: "Ed is for those who can *remember* what they are working on."
Certainly this is an exaggeration, but one that is rooted in the very real
tendency of young people to succumb to the siren call of ADHD. (Not
necessarily the actual disorder, but maybe just a faster-paced reality?) I
realize that I lazily relied on the visible list of files that were currently
open to know which files I was working on---even when I *knew* which files I
was working on if I would just give it some thought.

.. [2] http://www.gnu.org/fun/jokes/ed.msg.html

So here are some tips on how to effectively use buffers in Vim, please drop
more in the comments If you have 'em. Also, never stop reading the built-in
Vim documentation and online tips. Re-read a book on Vim every third year or
so. Editors as old as this one have so many features you'll never master them
all, the more you keep trying the more efficient you'll get at
text-wrangling—and if you edit for a living, it'll be well worth the time.


Vim Usage Tips for Young People
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Start with the excellent `Vim buffer FAQ`_! And search other Vim tips for
'buffer' for a lot of additional ideas.

Switch to a specific (N) buffer: ``:bN`` or ``N`` ``CTRL-^``. Or switch to a
buffer by (partial)-name: ``:b`` ``filena<CR>`` for a file named
filename.php, for example. I'm using a variant of `tip 821`_ to quickly jump
between buffers by pressing <F2> followed by a buffer number or name
fragment: ``map <F2> :ls<CR>:b<Space>``

Use ``:bd`` or ``:bw`` to get rid of buffers you no longer need.

Configure ``:set path`` to useful locations for your type of editing and use
``:find`` ``filename`` a lot. In fact, you can start Vim from the shell to
edit a certain file somewhere on your Vim path like this: ``$ vim "+find
filename"``.

Use the alternate buffer to quickly jump between two files: ``CTRL-^`` (or
``CTRL-6`` if you're lucky) also you can do ``:b#``. My `custom statusline`_
displays the alternate buffer filename to remind me.

To open a bunch of additional files after you've already opened Vim use
``:args`` ``filename*`` or ``:argadd files*.py``. Try using Vim's
``:Explore`` browser or just ``:cd`` and ``:cd -`` around the filesystem to
get closer to the files you need to add.

Map a key to ``:ls`` or ``:args`` for quick reference when you need to see
all the buffers you've got open. (Mine is F1 ``map`` ``<F1>`` ``:ls<cr>``.)

.. _User Manual: http://vimdoc.sourceforge.net/htmldoc/usr_toc.html
.. _Learning Vi: http://www.bookpool.com/sm/1565924266
.. _even before it had tabs: http://www.vim.org/tips/tip.php?tip_id=173
.. _Bram Moolenaar describe tabs: http://video.google.com/videoplay?docid=2538831956647446078#1h15m
.. _minibufexplorer: http://www.vim.org/scripts/script.php?script_id=159
.. _Vim buffer FAQ: http://www.vim.org/tips/tip.php?tip_id=135
.. _tip 821: http://www.vim.org/tips/tip.php?tip_id=821
.. _custom statusline: ../filez/prefs/vimrc

Archived Comments
~~~~~~~~~~~~~~~~~

Matt
    Seth, you are hard core! I know enough vi[m] to get around in a pinch, but
    you have crossed over to the devotee side of the line (not that there's
    anything wrong with that). I admire your tenacious spirit. :)

    Oh, and I'm jealous that you get to use vim. I'm going to be even more in
    the other camp at my new job, but it pays the bills--and I should run
    something else at home just for variety.
    
whiteinge
    Using different editors "just for variety" is the real hardcore, Matt! :-)

Peter
    You've shown several nice ways of jumping between buffers. I've mapped ^H
    in command mode to open the list of buffers and wait for me to select a
    number and hit enter:

    ::map ^H :ls:e #

    Works for me.
