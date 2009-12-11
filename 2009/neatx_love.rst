=====================
Introduction to neatx
=====================

.. index:: computing, unix

I spend a lot of time working out of a coffee shop on a netbook. Which means I
often work with limited computing resources over an insecure, unreliable, and
slow network. Normally that would make working difficult; with ``ssh`` and
``neatx`` it’s a walk in the park.

All the tutorials I found for neatx assumed you were already familiar with
other NX implementations and weren't for beginners. Here's how I set it up,
hopefully this will be useful to someone.


Slow Computer
-------------

Netbooks have a deserved reputation for being a little under powered for large
tasks. Chances are you have some giant supercomputer in the basement of your
home (or at least something bigger than a netbook).


Insecure Public Networks
------------------------

Don’t trust your webmail provider to always use SSL and not to abuse cookies?
Well, that’s probably less of a concern from your home internet connection than
from a public hotspot.


Unreliable & Slow Networks
--------------------------

When your connection drops out unexpectedly you don’t want lose any work. Sure,
you’re using GNU screen and your terminal session is reliably running just
waiting for you to reattach the session, but what about running GUI programs?

Even for quick tasks you can’t use X11 forwarding because the latency is so
ridiculously high.
