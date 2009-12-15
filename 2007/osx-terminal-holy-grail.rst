=======================================
The Mac OS X Terminal Holy Grail: mrxvt
=======================================

.. index:: computing, os x

:pubdate: 2007-05-15

I've been a bit unhappy with terminal offerings on OS X since I switched.
I've spent a bit of time working with each iTerm, GLTerm, xterm, aterm,
eterm, but always end up back with Terminal.app because it's fast and pretty.
My wish list has always been speed and anti-aliased fonts. I use Gnu screen
for tabs and don't mind using X11 coming from a Unix background. Recently I
added 256-color support to my wish list which Terminal.app and xterm don't
support (neither X11.app's version or the MacPorts version have it compiled
in).

I finally stumbled across `mrxvt`_. It supports anti-aliased fonts,
256-colors and it's unbelievably fast! Eyeball the screenshot below--a
256-color terminal is *so* worth the effort--this is mrxvt running Gnu Screen
running Vim.

.. image:: ./mrxvt-term.png
    :alt: Vim running in Gnu Screen running inside mrxvt


Although I had to compile it myself, I had no issues with the following:
``./configure --enable-everything --disable-debug --disable-greek``. (Install
the ``no*debug*x`` patch if you're compiling mrxvt-0.5.2 or it'll be very
slow.)

I also added the following to my ``.Xresources``:

::
    ! --- mrxvt settings
    mrxvt*background: black
    mrxvt*foreground: white
    mrxvt*scrollBar: false
    mrxvt*loginShell: true
    mrxvt*autohideTabbar: true
    mrxvt*syncTabTitle: true
    mrxvt*hideButtons: true
    mrxvt*cursorBlink: true
    mrxvt*font: Monaco
    mrxvt*faceSize: 11
    mrxvt*cursorColor: red
    mrxvt*xft:True
    mrxvt*xftFont: Monaco
    mrxvt*xftSize:12
    mrxvt*xftAntialias:True
    mrxvt*termName: xterm-256color
    ! blue is usually too dark to see. this fixes that
    mrxvt*color4: RoyalBlue
    mrxvt*color12: RoyalBlue


The Gnu Screen from MacPorts is already compiled with 256-color support so
putting the following in my .screenrc was the last step:

::

    ###############
    # 256 colours #
    ###############
    #
    #.. __: http://frexx.de/xterm-256-notes/
    #

    # terminfo and termcap for nice 256 color terminal
    # allow bold colors - necessary for some reason
    attrcolor b ".I"
    # tell screen how to set colors. AB=background, AF=foreground
    termcapinfo xterm 'Co#256:AB=\E[48;5;%dm:AF=\E[38;5;%dm'
    # erase background with current bg color
    defbce "on"


.. _mrxvt: http://materm.sourceforge.net/wiki/Main/Download

Archived Comments
=================

Ardekantur
    Does something special have to be done to allow mrxvt to see Mac OS X
    fonts? I just got my first Apple, and compiling mrxvt and using the
    .Xresources you’ve provided leaves me with the error messages:

    mrxvt: can’t load font “Monaco” mrxvt: Could not open file default.menu

    If this works, I’ll be very grateful. iTerm is noticeably slow.

    Thanks!

whiteinge
    Not sure about that one, Ardekantur. I have fontconfig via MacPorts
    installed, so maybe that’s it—but if so, I never manually ran or configured
    it. Have you tried re-creating your font-cache fc-cache?

    One other thing to check is, I seem to recall some path problem with fonts
    being in a few different places on OS X. I’ve seen suggestions that you
    create a /etc/X11/XftConfig file with the following::

        dir "/System/Library/Fonts"
        dir "/Library/Fonts"
        dir "~/Library/Fonts"

    Then restart X. But I didn’t have that file on my system…

    Drop another comment if any of these suggestion do or don’t pan out.

Ardekantur
    No luck, I’m afraid. It’s strange, though - mrxvt for me is in
    /usr/local/bin, and even if that path is set in both my .profile and
    .bash_login, X11 refuses to start a terminal that has that path. Maybe
    there’s some overreaching path problem with X11 and it not being able to
    find things.

Ardekantur
    Got it! I think I had to install fontconfig first, and then rebuild mrxvt.
    Thanks for your help!

whiteinge
    Awesome! Thanks for the update. I’ll have to research fontconfig now a bit…

P.Gr.
    This has been the most helpful guide to mrxvt on Mac OS X I have found.
    Great work! I just have one question. I have installed mrxvt, macports, and
    fontconfig and all of that works. Now I would like to add one more feature
    - how do I get window transparency working in mrxvt? If I type ‘mrxvt -o
    25’ it creates a plain opaque window. I’m kind of a Unix noob, do I need
    Xcompmgr or something (and if so, how do I install it)?

whiteinge Says:
    To the best of my knowledge there is no way to get actual transparency in
    Apple’s X11.app because it requires XFree86 6.8 with transparency support
    built-in. Apple appears to be running XFree86 4.4 still and I’ve only heard
    rumors about X11 updates for Leopard. [#1]_

    Apparently you can get pseudo-transparency working, but I couldn’t get it
    to work very reliably. Pseudo-transparency, just in case you’re not
    familiar with it, is setting an X11 background image (you can see it if you
    enter X11.app’s full-screen mode), then the terminal program (usually
    Eterm, aterm, or mrxvt) fakes transparency by displaying the part of the
    background image that it’s covering in it’s own window. It’s an interesting
    hack, and it helps to see it in action to understand what it’s doing.

    If you want to try pseudo-transparency, use MacPorts to install Eterm, then
    try ``Esetroot -f /path/to/your/background/image.jpg`` then start up
    ``Eterm``. I stopped trying to get it to work with mrxvt though since I
    couldn’t get the background image to stop changing by itself. :-(

    .. [#1] Side note, I just stumbled across Terminal 2 on Apple’s site. That
        should be interesting to see in November.
        http://www.apple.com/macosx/leopard/technology/unix.html

P.Gr. Says:
    Cool, I got pseudo-transparency working. I like the effect. I added
    Esetroot to my .xinitrc file, it seems to load the background image
    correctly and consistently display the right one with mrxvt. Wish I knew
    how to fix your background image problem.

    Terminal 2 looks nice. Here’s hoping they add 256-colors…

duckpond Says:
    One of my office machine has the xterm-256color entry in
    /usr/share/terminfo/78/, but in my newly build osx86, I don’t see ther
    terminfo xterm-256color anywhere, so I am guessing maybe I should install
    or upgrade some package to have that particular terminfo? what package
    should I reinstall?

whiteinge Says:
    You can try copying the xterm-256color file from one computer to the other.
    That worked for me for a while with screen-256color until MacPorts updated
    their GNU screen package.

    In direct answer to your question: it appears that the xterm-256color file
    belongs to the ncurses package in MacPorts (ncursesw). (I’m not sure about
    Fink.)

duckpond Says:
    mrxvt install was a success, vim and emacs can all work on 256 colors mode.
    for emacs, the xterm-256color.el was not there by default, you’ll need to
    drop a copy to the $EMACS_HOME/lisp/term/ directory.

    also installed ncursesw via MacPorts (now called DarwinPorts?), and
    terminfo for xterm-256color were installed by the package. I tried:

    TERM=xterm-256color vim

    just in the regular Terminal.app, vim then gave me a blinking screen, is
    the terminfo can only be recognized by X11 applications?

    thanks,

axolx
    NO UTF8 SUPPORT? Thats is unacceptable for me in 21st century computing.
    You should note that somewhere in your article, as I took it for granted
    and spent a bunch of time setting mrxvt in my system only to find out it
    lacks UTF8 support.

whiteinge Says:
    It’s a fair complaint; I am also looking forward to unicode support in
    mrxvt. Although I think it is a mistake to take unicode support for granted
    in a terminal environment. There is so much legacy code out there, it will
    be a long while still before command-line unicode becomes commonplace. For
    example, I see command-line encoding problems almost daily as I work (as a
    web developer) — even when using Terminal.app or other UTF-aware terminals.
