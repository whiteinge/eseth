m4TITLE({"Fast, parallel grep using find and xargs"})
m4CATEGORY({"computing, unix"})
m4DATE({"2021-04-13"})
m4SUMMARY({"grep doesn't have to be slow; use the UNIX philosophy of combining utilities."})

# Fast, parallel grep using find and xargs

In recent years there's been a bit of a movement away from using
[grep](https://en.wikipedia.org/wiki/Grep). The usually cited reasons are to
only search a specific file type, automatically ignore VCS directories, and
easily ignore other noise directories with per-project configuration, and
speed. More recently there's been a push to replace older utils written in
C with utils written in Golang or Rust.

Both of those are fine reasons to adopt a replacement tool and I'm not here to
sell anything. ripgrep in particular seems to contain some impressive
engineering.

My own preference is to adopt newer tools very slowly as there's often a lot of
ecosystem and tooling momentum around older tools. I appreciate being able to
build a 20+ year career around relying on a small set of very stable tools
rather than chasing fads and constantly swapping out parts of my tool belt.
I also tend to enjoy the [Plan 9](http://cat-v.org/) or
[Suckless](https://suckless.org/) philosophy of composing small, single-purpose
tools.

This post details an approach used by two wrapper shell scripts that live in my
dotfiles. You are welcome to use them directly or to use them as inspiration
for your own wrapper.

- <https://github.com/whiteinge/dotfiles/blob/bd29e4b/bin/ffind>
- <https://github.com/whiteinge/dotfiles/blob/bd29e4b/bin/ggrep>

**Table of Contents**:

{{TOC:2-3}}

## Composing small, single-purpose tools

It's fairly straightforward to compose a pipeline of find, xargs, and grep that
meet most/all the selling points of the popular grep replacements:

### `find`

The first step in searching the contents of files is to get the list of files
to search. It obviously takes much, much less time to search the contents of
a small number of files rather than searching every file so the more specific
you can be in this step the faster the search will be.

Some `grep` variants (GNU grep) have a recursive mode that has some file system
traversal capabilities, however that job is better handled by a tool focused on
only that.

It's common to not want certain files or directories to show up in search
results. For example, VCS directories, directories with build artifacts, or
compiled or minified files.

If you only wish to search a subset of files, such as only Python files, this
is the best time to remove non-Python files from the list of files to be
searched.

The `find` command can do all this with a bit of syntactical ceremony. The
example below prunes (removes) any matching path under a `.git` directory or
any compiled Python file, and then prints out any regular files that weren't
pruned.

```sh
find ./path '(' -path '*.git' -o -name '*.pyc' ')' -prune \
    -o -type f -print
```

We can additionally only match files with a `.py` extension. This addition is
redundant with pruning `.pyc` files but there's no harm in leaving it, and in
the case of pruning directories it can drastically speed up file system
traversal because `find` won't even enter the directory.

```sh
find ./path '(' -path '*.git' -o -name '*.pyc' ')' -prune \
    -o -type f -name '*.py' -print
```

Obviously this is a lot to type in each time but it's straightforward to wrap
`find` with a shell function, or wrapper shell script that bakes-in the repeat
options. We can store the patterns to prune in one or more files on the file
system and read them on-demand.

```sh
# Silence stderr by redirecting it. Save a reference to stderr in file
# descriptor 4 so we can restore it below. If any of these files don't exist,
# or if we're not inside a Git repository, no errors will be printed.
exec 4>&2 2>/dev/null
local prune="$(cat \
    "${HOME}/.ffind" \
    "${PWD}/.ffind" \
    "$(git rev-parse --absolute-git-dir)/../.ffind" |
    awk '/^-/ { printf("%s%s", sep, $0); sep=" -o " }')"
# Restore stderr.
exec 2>&4 4>&-

if [ -n "$prune" ]; then
    prune="( ${prune} ) -prune"
fi
```

It may seem expensive to check the file system for several files that may or
may not exist on each invocation but modern file systems are very, very fast
and this is one of the cheapest operations this wrapper script will perform. In
addition, Git is also extremely fast so we can invoke it without worry -- this
approach may not be desirable for slower programs (such as Mercurial that needs
to start a Python interpreter).

Next invoke `find` with the list of patterns to prune. We mustn't quote the
`$prune` variable so that each word in the string is interpreted as a separate
argument to `find`. The
[-f](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#set)
flag causes the shell to not expand any pathname patterns (like `*`).

```sh
set -f
find "$spath" $prune -o "$@" -print
set +f
```

The end result is a wrapper that allows us to invoke `find` passing only the
non-routine arguments:

```sh
ffind ./path -type f
```

Much easier. You can see a full example of this kind of wrapper in my dotfiles:

<https://github.com/whiteinge/dotfiles/blob/bd29e4b/bin/ffind>

### `xargs`

Now that we can easily generate a list of only the files we want to search, we
need to pass that list to `grep`.

We could use a subprocess to put that list into the argument position of the
`grep` command (e.g., `grep searchterm $(ffind . -type f)`) but that is exactly
what `xargs` does except using a shell pipe (e.g., `ffind . -type f | xargs
grep searchterm`).

It reads a little better (left-to-right), it can stream the list of files to
`grep` as they are supplied by `find` rather than all at once, and if there are
more files in the list than the OS allows as the maximum number of CLI
arguments xargs will split it up accordingly and invoke `grep` multiple times
as needed.

Plus `xargs` will give us free parallelization:

```js
ffind . -type f -print0 | xargs -0 -P4 grep searchterm
```

The `-print0` / `-0` pair uses a null character to separate file names which is
helpful if any file names contain spaces or weird characters. The `-P4` flag
tells `xargs` to spin up four `grep` processes and distribute the list of
arguments across them all. Since there's a little overhead in creating a new
process you should experiment with the right number of processes to maximize
performance on the machine you're using. A good starting point is to use the
number of CPU cores you have.

Now we have an easy way to generate the minimal number of files to search and
a way to search them across multiple, parallel processes. But that's still
a bit more typing than we'd like to do each time. We need one more wrapper.

### `grep`

`grep` takes a list of files to search as the last arguments which allows it to
easily compose with other shell tools. Anything that can produce a list of
files can call `grep` with that list. Our wrapper must have that same contract
if we want it to also compose well.

We sometimes want `find` to produce the list of files to search and other times
we want other tools to produce that list, but it would be nice to reuse the
same wrapper for consistency and for muscle memory -- one wrapper for all
situations.

If we call the wrapper with two arguments then use those for the starting path
and the main search term (plus a hook to add any other wanted file name
patterns). But if we call the wrapper with more arguments pass those directly
to `grep`:

```sh
local search="${1:?'Missing "searchterm".'}"; shift

if [[ "$#" -lt 2 ]]; then
    set -f

    ffind "${1:-.}" \
        -type f \
        $ext \
        -print0 \
    | xargs -0 -P8 grep --color -nH -E -e "${search}"

    set +f
else
    grep --color -nH -E -e "${search}" "$@"
fi
```

Now we can use our wrapper as `grep`, or to search the file system for files
and then `grep`:

```sh
ggrep searchterm file1
ggrep searchterm file1 file2

ggrep searchterm ./path
ggrep -X '*.py' searchterm ./path
```

You can see a full example of this kind of wrapper in my dotfiles:

<https://github.com/whiteinge/dotfiles/blob/bd29e4b/bin/ggrep>

## Speed

One of the often-touted goals for the `grep`-alternatives is speed. The big
three, [ack](https://beyondgrep.com/),
[ripgrep](https://github.com/BurntSushi/ripgrep), and [The Silver
Searcher](https://geoff.greer.fm/ag/) all talk about speed as a primary
feature.

The thing is, [grep is very
fast](https://lists.freebsd.org/pipermail/freebsd-current/2010-August/019310.html).

By far, the biggest factor in improving speed is to reduce the number of files
that we plan to search which we've already discussed in this post with `find`.
Parallelizing the search with `xargs` helps too.

How does `find`, `xargs`, and `grep` compare with the big three? Fairly well.

Please note the numbers below are _not benchmarks_ and are decidedly not
definitive. This is just a "back of the envelope" comparison to get a broad
sense of how close they are to each other when run on the same OS & system. All
three are ignoring slightly different files/directories based on default
settings and the presence of `.gitignore` files which is why they have varying
numbers of search matches and probably accounts, at least in part, for some of
the time differences.

(Note the "real" result; time is in seconds; smaller is better.)

```sh
% find . -type f '(' -name '*.js' -o -name '*.es6' -o -name '*.jsx' -o -name '*.vue' ')' -print | wc -l
231894

% /usr/bin/time -p ggrep -X '*.js' -X '*.es6' -X '*.jsx' -X '*.vue' import | wc -l
real 6.48
user 6.12
sys 0.47
4597

% /usr/bin/time -p ack -t js import | wc -l
real 11.64
user 9.23
sys 2.35
4652

% /usr/bin/time -p ag --js import | wc -l
real 0.82
user 0.73
sys 0.33
3655

% /usr/bin/time -p rg -t js import | wc -l
real 0.31
user 1.04
sys 0.63
2640
```

My goal with these numbers is to show how close each result is with the others
and _not_ to say, "X is better because it's N milliseconds faster than Y!"

If you're routinely searching through hundreds of thousands of files you might
care to base your tool of choice on granular speed metrics. Most of the time
you'll `cd` into the project, subproject, subdirectory, etc to constrain the
search to just the context that you're currently working on where the
difference between the tools completely evaporates. To adapt an apocryphal
quote: "Sub-second wait times for searching 80,000 files ought to be enough for
anybody." ;-)

```sh
% find . -type f '(' -name '*.js' -o -name '*.es6' -o -name '*.jsx' -o -name '*.vue' ')' -print | wc -l
80530

% /usr/bin/time -p ggrep -X '*.js' -X '*.es6' -X '*.jsx' -X '*.vue' import | wc -l
real 0.06
user 0.04
sys 0.02
2136

% /usr/bin/time -p ack -t js import | wc -l
real 0.23
user 0.19
sys 0.03
2064

% /usr/bin/time -p ag --js import | wc -l
real 0.09
user 0.10
sys 0.02
2189

% /usr/bin/time -p rg -t js import | wc -l
real 0.01
user 0.02
sys 0.03
2159
```

Here's an example of running under Busybox:

```sh
$ find . -type f '(' -name '*.vue' -o -name '*.jsx' -o -name '*.es6' -o -name '*.js' ')' -print | wc -l
80530

$ time -p ggrep -X '*.js' -X '*.es6' -X '*.jsx' -X '*.vue' import | wc -l
real 0.20
user 0.22
sys 0.02
2136
```

---

## Addendum: POSIX compatibility

It's worth noting that the `-print0` flag to `find` and `-0` and `-P` flags to
`xargs` are _not_ POSIX compliant
([find](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/find.html),
[xargs](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/xargs.html)).
Those flags are supported on the versions of those utils that ship with Linux
(of course), OS X, and Busybox but they are not broadly portable.

If you're on a system that does not support those flags and still want to
compose small, single-purpose utilities together there are a few good
alternatives to `find` ([lr](https://github.com/leahneukirchen/lr),
[walk](https://github.com/google/walk) (Plan 9 style utils),
[fd](https://github.com/sharkdp/fd)) and `xargs`
([xe](https://github.com/leahneukirchen/xe)).
