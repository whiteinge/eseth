.. _post-ob-randr:

=======================
Openbox xrandr Pipemenu
=======================

.. index:: computing, unix

:pubdate: 2009-12-15

Openbox is damn-near perfect. I was recently musing on what I would most miss
if I switched back to OS X [1]_ and the answer is Openbox. I’ve grown very fond
of “incredibly lightweight” and “highly configurable” as traits of a user
interface. My only feature request is some kind of compositing support; I like
the OS X/Compiz ability to quickly zoom-in/out, for example.

.. [1] I’m not the least bit interested in doing so, mind you.

`x.org`_ is kicking ass nowadays (I can only speculate on whether they’re
taking names). Anyone who is still bad-mouthing X about on-the-fly
multi-monitor support, adding/removing displays, and changing resolutions
either isn’t paying attention or is running the god-awful Nvidia binary
drivers [2]_. The RANDR extension and the :command:`xrandr` command-line
utility are *spectcaular*.

.. [2] It may have been great in the pre-RANDR days but Nvidia hasn’t kept
    pace with xorg enhancements and can now suck a nut.

I created a pipemenu for Openbox that captures the output of :command:`xrandr`
and puts it into nice menus. It’s called `ob-randr`_ and it’s on Google Code.
You can also make a configuration file with commonly-used configurations and
the pipemenu will pull those in for quick-access. For example, here are two
that I commonly use:

* On my netbook’s 800x480 screen I frequently toggle between “zooming out” to a
  1280x720 display to get a quick (albeit tiny) overview, and “zooming in” to a
  pan–able 1280x720 display. 
* On my work laptop I freqently toggle between a secondary display rotated 90°
  to the left, positioned to the right of my laptop LCD, and the regular
  single-screen configuration.

.. _`x.org`: http://www.x.org/
.. _`ob-randr`: http://code.google.com/p/ob-randr/

.. image::
    ./ob-randr.png
