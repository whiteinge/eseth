TITLE({"ReST for Markdown and Textile Users"})
CATEGORY({"computing"})
DATE({"2007-10-11"})

ReST for Markdown and Textile Users
===================================

ReStructuredText is freaking huge so users of lighter-weight markup
languages can be easily put off. This is an *absolute basics* quickref
to ReST for those kinds of users. Eye-ball the
[Closing](rest-for-markdown-and-textile-users.html#closing) at the
bottom for a bit more perspective.

Headers
-------

Just use non-alphanumeric characters to underline (or
under-and-overline) your heading. It doesn't matter what you use, just
be consistent with the character you use for each header level:

```
=========
Chapter 1
=========

Section 1.1
===========

Section 1.2
-----------

Section 1.3
+++++++++++

=========
Chapter 2
=========
```

Text Styles
-----------

*italics*: `*Italics*`

**bold**: `**bold**`

Block quotes are just:

```
> Indented paragraphs,
> >> and they may nest.
```

Use double backticks for inline code blocks like
```
`this example where otherwise *special characters* aren't processed`. Dig?
```

```
::

    A paragraph containing only two colons (or ending in two colons)
    followed by an indented text block starts a code block.  No
    ReST processing will happen in this block, so feel free to use
    funny characters. `!@#$%^&*()_+
```

Links
-----

ReST will automatically hyperlink any bare URLs.

Inline hyperlinks can be somewhat hard to read [like
this](http://the-meaning-of-life.info/) surrounded by text:

    Inline hyperlinks can be somewhat hard to read `like this <http
    ://the-meaning-of-life.info/>`_ surrounded by text.

Fortunately reference-style links
[look](http://the-universe-and-everything.info/) very legible in
text-format. And can even [span multiple
words](http://yourockthepartythatrocksthebody.com) (like you would
expect!):

    Fortunately reference-style links look_ very legible in text-format.
    And can even `span multiple words`_ (like you would expect!).

    .. _span multiple words: http://yourockthepartythatrocksthebody.com
    .. _look: http://the-universe-and-everything.info/

Lists
-----

Syntax:

```
#. Lists are a bit trickier in ReST
#. than in Markdown or Textile

#. Place a blank line
#. between sub-lists

   #.   And line the bullet up
   #.   exactly with the farthest left column of text of the parent
        list

* Unordered lists work in
  exactly the same way

* Just be careful to line the bullets
  up with the first text column of the parent list.

  Also, you can do multi-line bullet items if you're
  careful of the indentation.

 Definition Lists are easy
    Just indent the definition!
```

Images
------

You can easily include images, along with some useful attributes
(carefully line up subsequent lines with the parent!):

```
.. image:: http://path/to/image.png
   :alt: alternate text
   :class: class names
```

Tables
------

Banging out simple tables is also very quick:

```
=====  =====  ======
   Inputs     Output
------------  ------
  A      B    A or B
=====  =====  ======
False  False  False
True   False  True
False  True   True
True   True   True
=====  =====  ======
```

Closing
-------

If this quickref piqued your interest hit up the [ReST
specification](http://docutils.sourceforge.net/rst.html). It's not very
easy to read, but it's worth it. You can use alternate syntaxes for
marking-up lists, for example. There are many built-in mechanisms for
marking-up meta data such as for HTML `<meta>` tags. There's a robust
footnote and citation syntax. ReST generates references to key elements
in your document so you can link to them. Docutils' `rst2html.py` can
start numbering headings at any level so you can seamlessly fit ReST
docs into your site hierarchy.

The reason ReST is preferable to Markdown or Textile is that it *can* be
written as simply as the lighter-weight markup languages if you're
working on simple docs--but it doesn't have to be. You may
appreciate that down the road when you find you suddenly need one of
your docs in PDF or XML format.
