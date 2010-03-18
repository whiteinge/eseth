.. _post-blogging-with-sphinx:

====================
Blogging with Sphinx
====================

.. index:: computing, python

.. |rst| replace:: `reStructuredText`_

:pubdate: 2010-03-17

Excruciatingly Boring Navel-Gazing
==================================

It’s been a long time since I’ve done anything with this blog. It went from
being on WordPress to being a static-HTML :command:`wget` dump of a WordPress
blog and stayed that way for a couple years.

Since I don’t take my blog too seriously, and since I’ve already been writing
blog posts in |rst| for a few years now (using a WordPress plugin), and since
I’ve already been documenting my Python code using the hair-raisingly cool
`Sphinx`_ it seemed natural to also want to use Sphinx for my blog; sort of a
less special-purpose `Blogofile`_.

If you’re thinking “WTF?” you may want to `move on
<http://www.flickr.com/search/?q=shiny+things>`_ as I’m not trying to sell
anything here.


Helpful Blog Machinery
======================

Blogs need three things: commenting, tags, and feeds.

Commenting
----------

I will bolt on commenting through a third-party, like Disqus, in the near
future.

Tags
----

Tags are kinda similar to an index in concept, so I’m just using Sphinx’s
builtin indexing for now. It’s got a few warts and if I can’t iron them out
I’ll just roll my own tags `directive`_.

Feeds
-----

Sphinx doesn’t generate RSS so I rolled my own as a Sphinx extension
(`source`_).

Other Crap
----------

I like to express my inner-OCD by crafting :rc:`dotfiles <*>` and as such,
:ref:`I talk about them a lot on my blog <dotfiles>`. I wanted a quick way to
link to one of my dotfiles, wherever it may be hosted, so I wrote a |rst| role
to do so. Something like the following will generate the right link to a
specific file, of a specific revision, and a specific line in my BitBucket
repo::

    I have written a function that does FOO, see :rc:`line 42 of my ~/`barrc
    <.barrc@b1e8bfc81b0a#42>` for the implementation.

If I switch to some other provider or self-host, I simply update the URL in my
configuration file.


The Source
==========

If you’re interested, you can see the actual |rst| source for any of these
posts by clicking the ‘View Source’ link in the sidebar and you can see the
`entire source for this blog`_ at my BitBucket repo.

.. _`Sphinx`: http://sphinx.pocoo.org/
.. _`reStructuredText`: http://docutils.sf.net/rst.html
.. _`Blogofile`: http://www.blogofile.com/
.. _`directive`: http://sphinx.pocoo.org/rest.html#directives
.. _`source`: http://bitbucket.org/whiteinge/eseth/src/tip/ext/feed.py
.. _`entire source for this blog`: http://bitbucket.org/whiteinge/eseth/src/
