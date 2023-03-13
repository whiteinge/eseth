m4TITLE({"Visualize changes to the Git DAG in real-time"})
m4CATEGORY({"computing, git"})
m4DATE({"2023-05-12"})
m4SUMMARY({"Real-time visualization of Git operations that change the DAG using a simple hook and an image viewer."})

# Visualize changes to the Git DAG in real-time

Teaching users how to perform more than just the basic Git operations
eventually requires some discussion about the Git DAG. It's the the inevitable
[just think of branches as...](https://xkcd.com/1597/) discussion and while
that has become something of an overused joke, it really is a useful and
effective mental model.

Git users that only use the `push`, `pull`, `merge`, and `commit` commands are
often worried about "messing up" a repository by using the "destructive"
commands and never venture deeper. Doing so is well worth the effort though!
Git is something all developers use day-in and day-out, investing a handful of
hours in a Git training will pay time dividends in the years to come, and
increases a developer's confidence when crafting a PR. I often highly recommend
spending a weekend with the [Pro Git book, by Scott
Chacon](https://git-scm.com/book/en/v2) and going through the examples.

When I [run Git training
sessions](https://github.com/whiteinge/presentations#readme), I lean heavily on
a shell script that uses Graphviz to draw a graphical representation of the
actual Git DAG (originally adapted from [an
example](https://git.wiki.kernel.org/index.php/ExampleScripts) in the (now
deprecated) Git Wiki). With a tiny bit of helper machinery it can even display
changes in (near) real-time:

<video src="./git-graph-dag.webm" controls loop preload="none" width="100%"></video>

(The `git stub` command can be a [simple
alias](https://github.com/whiteinge/dotfiles/blob/733f59924516245ba11010932318faa7bcee8247/.gitconfig#L71-L72)
around `touch A; git add A; git commit -m "Add-A"` to quickly stub out new Git
commits when running training workshops.)

The "magic" of the script is using the `reference-transaction` Git hook to
regenerate the graph whenever a reference changes, plus any image viewer that
will update the display when the underlying file changes. The excellent
ImageMagick ships with one that works beautifully on Linux, Windows with WSL2
(since X11 works out-of-box nowadays with WSL2!), and OS X with XQuartz -- also
untested, but I think Preview.app may work as well.

If you're interested in using it when running your own Git trainings, or just
playing around on your own, you can pull the script out of my dotfiles
repository. Just put it somewhere on your `$PATH`. I may extract it into
a separate repo if there's interest.

<https://github.com/whiteinge/dotfiles/blob/34548d5cd265b78b4f20f250dcfb8a7644066b28/bin/git-graph-dag>
