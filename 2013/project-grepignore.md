---
category: 'computing, unix, zsh'
date: '2013-04-28'
summary: |
  Change GREP_OPTIONS dynamically using Zsh's precmd.
---

Setting project-level grep options
==================================

**Using Zsh\'s `precmd`**

The venerable grep has not aged terribly well giving rise to (the
admitedly cool) [Ack](http://beyondgrep.com/). One handy feature of Ack
is being able to set options specifically for a single project by
placing a dotfile in the project directory. This is easily mimicked for
grep using a handy Zsh feature. (This is also possible in Bash, of
course, with a bit more code.)

GREP\_OPTIONS
-------------

You can set default options for grep in an environment variable named
GREP\_OPTIONS. For example a nice default to put in your `.zshrc` file
is:

    GREP_OPTIONS="--color --exclude-dir=.svn --exclude-dir=.hg --exclude-dir=.git"
    export GREP_OPTIONS

Dynamically setting environment variables
-----------------------------------------

Zsh has a handy feature called
[precmd](http://zsh.sourceforge.net/Doc/Release/Functions.html) which is
a function that you define in your `~/.zshrc` file that is run before
each time your prompt is drawn to the screen. In fact you can have
several such functions if you put them in an array:

    local -a precmd_functions

    function grep_options() {
        GREP_OPTIONS="--color --exclude-dir=.svn --exclude-dir=.hg --exclude-dir=.git"
        export GREP_OPTIONS
    }

    precmd_functions=( grep_options )

See where this is going? :)

Reading files into Zsh arrays
-----------------------------

First-class support for arrays in one thing (of many) that really sets
Zsh apart from Bash. Zsh has many internal functions for working with
arrays and many internal functions that work with arrays as parameters.
(No need for Bash\'s `IFS` bullshit.) You can see many such functions by
referencing the following two Zsh manpages:

-   zshexpn(1) under \"PARAMETER EXPANSION\"
-   zshparam(1) under \"ARRAY PARAMETERS\"

The `(f)` parameter referenced in zshparam(1) reads newline-separated
records as values into an array. Another, `$(<)` reads the contents of a
file into a variable. Combined you have a one-liner that reads each line
of a file into an array:

    local -a opts
    opts=( ${(f)"$(< ${HOME}/.grepoptions)"} )

Neat. What if you want to add comments to that file too? Obviously, they
shouldn\'t be included in the array. You can see in zshexpn(1) that many
of the substitutions that work on strings also work on individual array
items if given an array. The `${name:#pattern}` substitution will remove
items from an array that match a pattern. A comment character followed
by anything looks like `[#]*`:

    local -a opts
    opts=( ${${(f)"$(< ${HOME}/.grepoptions)"}:#[#]*} )

Create a file in your home directory named `.grepoptions` to hold the
options you always want passed to grep and each line will be added to
the array:

    --color
    --exclude-dir=.svn
    --exclude-dir=.hg
    --exclude-dir=.git

Add new values to an array
--------------------------

Next modify your shell function to also look for a `.grepoptions` file
in the current directory so its contents can be added to the array (note
the `+=`):

    local proj_opts=${PWD}/.grepoptions

    if [[ -r ${proj_opts} ]] ; then
        opts+=( ${${(f)"$(< "${proj_opts}")"}:#[#]*} )
    fi

Great. You now have an array containing the aggregate of two
`.grepoptions` files. The last step is to assemble the array back to a
string so you can export the GREP\_OPTIONS environment variable. Zsh
arrays have a join parameter of the form `${(j: :)name}` where the
character between the colons is the character to join with.

Summary
-------

Putting everything together you should have something similar to the
following in your `~/.zshrc`:

    local -a precmd_functions

    function grep_options() {
        local -a opts
        local proj_opts=${PWD}/.grepoptions

        # Grab the global options
        opts=( ${(f)"$(< "${HOME}/.grepoptions")"} )

        # Grab any project-local options
        if [[ -r ${proj_opts} ]] ; then
            opts+=( ${${(f)"$(< "${proj_opts}")"}:#[#]*} )
        fi

        # Assemble and export
        GREP_OPTIONS="${(j: :)opts}"
        export GREP_OPTIONS
    }

    precmd_functions=( grep_options )

Since this function is executed as a Zsh `precmd` the value of the
GREP\_OPTIONS environment variable will change as you cd around the file
system. If you have any other `precmd` functions simply add them to the
`precmd_functions` array to run them all.

Here is a example shell session:

    ~  % cd $HOME
    ~  % echo $GREP_OPTIONS
    --color --exclude-dir=.svn --exclude-dir=.hg --exclude-dir=.git
    ~  % cd ~/path/to/myproject
    % cat .grepoptions
    # Don't grep any minified JavaScript files
    --exclude=\*min.js

    # Don't grep third-party libs
    --exclude-dir=lib
    % echo $GREP_OPTIONS
    --color --exclude-dir=.svn --exclude-dir=.hg --exclude-dir=.git --exclude=\*min.js --exclude-dir=lib
