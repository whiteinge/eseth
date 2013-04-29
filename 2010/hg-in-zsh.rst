:Date: 2010-05-24

.. _post-hg-in-zsh:

=================================
Mercurial Info in Your Zsh Prompt
=================================

.. index:: computing, unix, zsh, mercurial

.. highlight:: bash

.. contents:: Contents
    :local:
    :depth: 2

.. seealso:: :ref:`post-git-in-zsh`

What is ``VCS_Info``?
=====================

If you aren’t already familiar with ``VCS_Info`` in Zsh, fire up your favorite
manpage viewer and read through the section in :manpage:`zshcontrib(1)`. It
allows you to pull information out of a version-controlled repository and
display that in your shell prompt.

The big win for ``VCS_Info`` over other, similar solutions is that it is built
right into Zsh and supports Bazaar, Codeville, CVS, Darcs, Git, GNU arch, GNU
quilt, Mercurial, Monotone, Perforce, Subversion, and SVK all using the same
configuration. You put it into your prompt once then as you :command:`cd`
between your favorite git, hg, bzr, or svn local clones it Just Works®:

Mercurial (using `hg-git`_):

.. image::
    ./vcs-hggit.png

Git:

.. image::
    ./vcs-git.png

It is also highly customizable.

``VCS_Info`` quickstart
-----------------------

1.  Put the following in your ``~/.zshrc``::

        autoload -Uz vcs_info
        zstyle ':vcs_info:*' enable hg git bzr svn

2.  Put :envvar:`${vcs_info_msg_0_}` somewhere in your :envvar:`$PS1`.

3.  Test it by going into a local repository directory. Your prompt should look
    something like this::

        you@host ~/src/yourcode  (hg)-[default]-
        %

4.  Be amazed and suddenly feel compelled to send `Frank Terbeck`_ a valentine
    to say thanks for writing ``VCS_Info``.

.. _`Frank Terbeck`: http://bewatermyfriend.org

.. ............................................................................

``VCS_Info`` Mercurial Support
==============================

The first iteration of the Mercurial ``VCS_Info`` backend would display the
changeset ID, local revision number, current branch, and the topmost applied
`mq`_ patch. Here are the new features:

.. warning::

    Many features in ``VCS_Info`` are disabled by default for performance
    reasons. Most of the below styles require customizing your ``formats`` and
    ``actionformats`` zstyles at least. Look at my customizations below and
    give :manpage:`zshcontrib(1)` a read before you give up or complain.

Support for the Bookmarks extension
-----------------------------------

Enable Mercurial `bookmarks`_ by adding the style::

    zstyle ':vcs_info:hg*:*' get-bookmarks true

.. image::
    ./vcs-bookmarks.png

Show marker for changes in the working directory
------------------------------------------------

Knowing if there are changes in your working directory at a glance can be a
huge time saver::

    zstyle ':vcs_info:hg*:*' check-for-changes true

.. image::
    ./vcs-changes.png

Avoid the overhead of starting the Python interpreter
-----------------------------------------------------

In very large repositories or on very slow computers, invoking Mercurial every
time the prompt is drawn can simply be too slow. You can optionally use the
:command:`hexdump` program to fetch the changeset ID instead which is lightning
fast.

For example, the NetBeans repository is 3 GB in size so to enable fast lookup
for just that directory::

    zstyle ':vcs_info:hg*:netbeans' use-simple true

Here are three time tests in the NetBeans repo to give you an idea of the speed
difference. Note that by specifying the current revision with ``-r .`` causes
Mercurial to ignore the state of the working directory which goes a little
faster but doesn’t look for changes.

.. image::
    ./vcs-hexdump.png

.. note::

    You cannot retrieve the local revision number with hexdump.

Display the current action
--------------------------

Show when rebasing or merging. Define ``actionformats``::

    zstyle ':vcs_info:hg*' actionformats "(%s|%a)[%i%u %b %m]"

.. image::
    ./vcs-merging.png

Display both parents during a merge
-----------------------------------

Mercurial separates multiple parents with a ``+`` by default:

.. image::
    ./vcs-merging.png

This doesn’t (currently) work with the ``use-simple`` setting, although I think
the second parent hash is available with :command:`hexdump` so this may be
added in the future.

Detection for `hg-git`_, `hgsubversion`_, and `hgsvn`_
------------------------------------------------------

It can be useful to see when you are in a repo created from another VCS since
your workflow is often altered.

.. image::
    ./vcs-hggit.png

Improved `mq`_ display
----------------------

Show the names and count of both applied and unapplied patches. ``VCS_Info``
supports this same configuration for `stgit`_ and `Quilt`_ as well.

.. image::
    ./vcs-mq.png

Support for `mq`_ guards
------------------------

The unapplied count now takes `guards`_ into account.

.. image::
    ./vcs-guards.png

.. _`mq`: http://mercurial.selenic.com/wiki/MqExtension
.. _`guards`: http://hgbook.red-bean.com/read/advanced-uses-of-mercurial-queues.html
.. _`stgit`: http://www.procode.org/stgit/
.. _`Quilt`: http://savannah.nongnu.org/projects/quilt
.. _`Bookmarks`: http://mercurial.selenic.com/wiki/BookmarksExtension
.. _`hg-git`: http://hg-git.github.com/
.. _`hgsubversion`: http://www.bitbucket.org/durin42/hgsubversion/
.. _`hgsvn`: http://pypi.python.org/pypi/hgsvn/

.. ............................................................................

``VCS_Info`` Hooks
==================

Hooks are a great and open-ended way to customize the output. The hooks
documentation is really good and worth a read.

For example, I wanted to add a marker to the display when I’m not currently on
a branch head:

.. image::
    ./vcs-notonbranchhead.png

The hook looks like this::

    zstyle ':vcs_info:hg*+set-message:*' hooks hg-storerev hg-branchhead

    ### Store the localrev and global hash for use in other hooks
    function +vi-hg-storerev() {
        user_data[localrev]=${hook_com[localrev]}
        user_data[hash]=${hook_com[hash]}
    }

    ### Show marker when the working directory is not on a branch head
    # This may indicate that running `hg up` will do something
    function +vi-hg-branchhead() {
        local branchheadsfile i_tiphash i_branchname
        local -a branchheads

        local branchheadsfile=${hook_com[base]}/.hg/branchheads.cache

        # Bail out if any mq patches are applied
        [[ -s ${hook_com[base]}/.hg/patches/status ]] && return 0

        if [[ -r ${branchheadsfile} ]] ; then
            while read -r i_tiphash i_branchname ; do
                branchheads+=( $i_tiphash )
            done < ${branchheadsfile}

            if [[ ! ${branchheads[(i)${user_data[hash]}]} -le ${#branchheads} ]] ; then
                hook_com[revision]="${c4}^${c2}${hook_com[revision]}"
            fi
        fi
    }

.. note::

    The reason this functionality isn’t in the core backend is because the
    :file:`branchheads.cache` isn’t updated with every :command:`hg` operation
    so on occasion it will give a false positive. Most of the time it is Good
    Enough®.

.. ............................................................................

Putting it All Together
=======================

You can pack quite a lot of information into your prompt (if you want to):

.. image::
    ./vcs-complete.png

If you are interested, the entirely of my ``VCS_Info`` configuration is
available on GitHub or BitBucket in my :rc:`Zsh prompt file
<.zsh_shouse_prompt>`.

Here are the important lines (omitting hooks and colors). ``hg*`` ensures the
same style is applied to ``hg`` as well as variants like ``hg-git``,
``hg-hgsubversion``, etc.::

    zstyle ':vcs_info:*' enable hg git bzr svn
    zstyle ':vcs_info:(hg*|git*):*' get-revision true
    zstyle ':vcs_info:(hg*|git*):*' check-for-changes true

    # rev+changes branch misc
    zstyle ':vcs_info:hg*' formats "(%s)[%i%u %b %m]"
    zstyle ':vcs_info:hg*' actionformats "(%s|%a)[%i%u %b %m]"

    # hash changes branch misc
    zstyle ':vcs_info:git*' formats "(%s)[%12.12i %u %b %m]"
    zstyle ':vcs_info:git*' actionformats "(%s|%a)[%12.12i %u %b %m]"

    zstyle ':vcs_info:hg*:netbeans' use-simple true

    zstyle ':vcs_info:hg*:*' get-bookmarks true

    zstyle ':vcs_info:hg*:*' get-mq true
    zstyle ':vcs_info:hg*:*' get-unapplied true
    zstyle ':vcs_info:hg*:*' patch-format "mq(%g):%n/%c %p"
    zstyle ':vcs_info:hg*:*' nopatch-format "mq(%g):%n/%c %p"

    zstyle ':vcs_info:hg*:*' unstagedstr "+"
    zstyle ':vcs_info:hg*:*' hgrevformat "%r" # only show local rev.
    zstyle ':vcs_info:hg*:*' branchformat "%b" # only show branch

.. ............................................................................

.. _dont-wait:

Try the New Features Now!
=========================

These new features are still unreleased (as of Zsh 4.3.10). You don’t have to
wait for the next release of Zsh to try them. Full instructions to keep a local
checkout from CVS are located in the `vcs_info-examples file`_.

*tl;dr*:

#.  Download the `latest snapshot`_ tarball from the Git mirror and untar it.
#.  Put the ``Functions/VCS_Info`` directory from the archive somewhere.
    ``~/.zfuncs`` is a good place.
#.  Point your Zsh at that directory (requires :envvar:`extended_glob` to be set)::

        fpath=( ~/.zfuncs ~/.zfuncs/VCS_Info/**/*~*/(CVS)#(/) $fpath )

#.  Restart Zsh::

        % exec zsh

.. _`vcs_info-examples file`: http://zsh.git.sourceforge.net/git/gitweb.cgi?p=zsh/zsh;a=blob;f=Misc/vcs_info-examples
.. _`latest snapshot`: http://zsh.git.sourceforge.net/git/gitweb.cgi?p=zsh/zsh;a=snapshot;sf=tgz
