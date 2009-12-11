===================================
OS X vs. Linux and Linux on Laptops
===================================

.. index:: computing, os x, unix

:pubdate: 2004

Apple recently introduced a sub $1k `iBook`_ so I've (almost) promptly put my
`Vaio on eBay`_. Now this doesn't bode well for my emotional state as this
will be the fifth laptop I've purchased in the last two years.

Initially I purchased a 12" Powerbook to replace a tiny 300 MHz, 12"
ThinkPad. In all honesty I should've stopped there. Instead I got kind of
nuts when I saw the Powerbook could *almost* play Warcraft III, so quickly
returned it for a more powerfull 15" Powerbook.

I loved that 15". But ultimately I stopped carrying it around often enough to
justify owning a laptop because it was so heavy. Around then I discovered the
`Sharp Zaurus C860`_, and believed it to be capable of replacing a notebook.
It wasn't; it did have the battery-life of a laptop (doh!), but the Arm
processor made it difficult to find / compile software for it. In retrospect
I wish I had tried `distcc`_ before I sold it. It is possible that had I been
more knowlegable about Linux I could've made it work, but I doubt it -- there
were a lot of issues with the various distributions (`1`_, `2`_, `3`_)
available mostly relating to yet-unsupported hardware and software
unavailability.

Next I purchased a `Sony Vaio Picturebook`_. Now I had always wanted one of
these -- I'm a *huge* fan of ultra-small laptops; the screen runs at
1024x480, for example. And generally speaking I was very pleased with it. In
my sheltered Mac days I had assumed that Linux, since it is virtually ready
for prime-time on the desktop, could also be almost as effective on a mobile
device.

Linux on laptops sucks. Although, to be fair, I'm dying to see how it
performs on very supported hardware (as opposed to average hardware --
there's a company that sells laptops and desktop as well as offering their
own Linux distro in an attempt to bring the Mac experience to Linux, but I
couldn't find a link). And, again to be fair, my Picturebook's hardware is
all fully supported except for some ACPI closed-bios issues (that are Sony
and Microsoft's fault). Because Sony implemented Microsoft's implementation
of ACPI instead of the standard, Linux is having some trouble with power-
management, specifically suspend. Although Linux's power-management in
general needs a lot of work, I was able to get suspend-to-disk working with
the 2.6.7 kernel which made things a lot nicer.

To sum up: Desktop Linux works very well because your computer never goes
anywhere, so you've got the time to get working whatever you need it to do,
and it stays working. But when you're mobile and run into unexpected
situations such as needing TV-or-VGA-out, `strict wireless LAN requirements`_
you've *really* got a know your stuff, and it will still take a while to set
up.

So I'll be getting a 12" iBook. It's not a desktop replacement or for gaming,
my Linux desktop works very well for that. I'm sure it will be fast-enough
for my mobile needs, and it's a Mac so it will just work, even in unexpected
situations.

.. _iBook: http://www.apple.com/ibook/
.. _Vaio on eBay:
    http://cgi.ebay.com/ws/eBayISAPI.dll?ViewItem&item=6717542838
.. _Sharp Zaurus C860:
    http://www.pdabuyersguide.com/sharp_zaurus_C860.htm
.. _distcc:
    http://freshmeat.net/projects/distcc/?branch_id=29642&release_id=175494
.. _1: http://www.pdaxrom.org/
.. _2: http://openzaurus.org/www/
.. _3: http://my-zaurus.narod.ru/cacko.html
.. _Sony Vaio Picturebook: http://eseth.com/filez/vaio/
.. _strict wireless LAN requirements:
    http://wireless.utah.edu/global/dot1x/index.html
