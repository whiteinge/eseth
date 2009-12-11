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
the ``no*debug*x `` patch if you're compiling mrxvt-0.5.2 or it'll be very
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
