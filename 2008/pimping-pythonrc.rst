:pubdate: 2008

.. _pimping-pythonrc:

=============================
Pimping out your .pythonrc.py
=============================

.. index:: computing, python

I don't wanna be hatin' on `IPython`_, but I don't use it. I often favor fairly
extreme minimalism in computing. Why install something if you can accomplish
the same (or good enough) with what you have available? IPython has quite a lot
of features and syntactic-sugar, but it is overkill for my needs. Instead I've
been slowly crafting my :rc:`pythonrc.py <.pythonrc.py>` to give the built-in
Python shell color, tab completion, saving and searching a history, pretty
printing, and the ability to start an external editor.

It should be said that this code is not especially interesting, and a lot of
this is very straightforward readline configuration -- but it seems that a
lot of people are unfamiliar with the basics, so here is my set up.

There are two parts. The :rc:`inputrc <.inputrc>` sets up the key-bindings and
some completion options, and the :rc:`pythonrc.py <.pythonrc.py>` which does
the rest.

You will almost certainly want to strip things out of my :rc:`inputrc
<.inputrc>` that you don't use or enjoy, like vi-mode. Note the conditional for
Python in case you want any key-bindings specific to the Python shell.

The :rc:`inputrc <.inputrc>` should be somewhat self-explanatory. For the
options that aren't check out the `GNU Bash Reference Manual`_. Also Google is
your friend. For example if you want to use page-up and page-down to do
completion from your history use the following two commands::

    "\e[5~": history-search-backward
    "\e[6~": history-search-forward

Now you can type in the first few characters of a previous command, hit your
``history-search-backward`` key and, voila, you get the full command. You can
also search your history for a pattern using the normal keys for that -- for
vi-mode hit ``esc`` to get in Normal mode then press ``?`` followed by the
search term. (I don't know the search command for the regular Emacs shell
mode.)

A very cool thing about the :rc:`inputrc <.inputrc>` is it will also affect
other programs that utilize readline, such as bash and the shells for SQLite,
PostgreSQL, and MySQL.

In order for the Python shell to run your :rc:`pythonrc.py <.pythonrc.py>` file
on startup you need to set the ``PYTHONSTARTUP`` environment variable. Place
the following line in one of your shell startup files::

    export PYTHONSTARTUP=$HOME/.pythonrc.py

Now run the Python shell and you should see color and some startup messages!

If you are a Django developer and ``DJANGO_SETTINGS_MODULE`` exists in your
environment, it will import all the models in your project and set up the
Django test environment automatically. Try it!


Lastly a few Python shell tips
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-   A great way to introspect an unfamiliar object is to type the object
    name followed by a dot then hit ``tab``. You will see the methods and
    attributes for that object.
-   You can get the output from the last command run with the variable
    ``_`` (underscore). For example::

        >>> {1:2, 3:4}
        {1: 2, 3: 4}
        >>> t = _
        >>> t
        {1: 2, 3: 4}

-   Use the built-in ``help()`` method to get more info on a function or
    module. For example::

        >>> import os
        >>> help(os)
        Help on module os:
        ...

If you have any other tips or fixes, please let me know!

.. _IPython: http://ipython.scipy.org/moin/
.. _GNU Bash Reference Manual: http://www.network-
    theory.co.uk/docs/bashref/ReadlineInitFileSyntax.html
