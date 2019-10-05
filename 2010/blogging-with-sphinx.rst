:date: 2010-03-17
:category: computing, python

====================
Blogging with Sphinx
====================

Excruciatingly Boring Navel-Gazing
==================================

It’s been a long time since I’ve done anything with this blog. It went from
being on WordPress to being a static-HTML `wget` dump of a WordPress
blog and stayed that way for a couple years.

Since I don’t take my blog too seriously, and since I’ve already been writing
blog posts in reStructuredText for a few years now (using a WordPress plugin), and since
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

I will bolt on commenting, maybe Disqus, in the near future.

Tags
----

Tags are kinda similar to an index in concept, so I’m just using Sphinx’s
builtin indexing for now. I’d like to be able to more easily work with tagged
items so I’m working on a tagging `directive`_.

Feeds
-----

Sphinx doesn’t generate RSS so I rolled my own as a Sphinx extension
(`source`_).

.. versionchanged:: 2011-01-03
    It now sorts by most recent entries and takes a few configuration options
    such as not outputting entries older than a certain date or only outputting
    a maximum number of entries.

Other Crap
----------

I like to entertain my inner-OCD by crafting `dotfiles
<https://github.com/whiteinge/dotfiles>`_ and as such,
`I talk about them a lot on my blog <../2005/dotfiles.html>`_. I wanted a quick way to
link to one of my dotfiles, wherever it may be hosted, so I wrote a reStructuredText role
to do so. Something like the following will generate the right link to a
specific file, of a specific revision, and a specific line in my BitBucket
repo::

    See `line 42 of my ~/barrc
    <https://github.com/whiteinge/dotfiles/blob/b1e8bfc81b0a/.barrc#L42>`_.

If I switch to some other provider or self-host, I simply update the URL in my
configuration file.


The Source
==========

This is a work in progress as I’ve only just launched the site. If you’re
interested, you can see the actual reStructuredText source for any of these posts by
clicking the ‘View Source’ link in the sidebar and you can see the `entire
source for this blog`_ at BitBucket.

.. _`Sphinx`: http://sphinx.pocoo.org/
.. _`reStructuredText`: http://docutils.sf.net/rst.html
.. _`Blogofile`: http://www.blogofile.com/
.. _`directive`: http://sphinx.pocoo.org/rest.html#directives
.. _`source`: https://github.com/whiteinge/eseth/blob/master/ext/feed.py
.. _`entire source for this blog`: https://github.com/whiteinge/eseth
