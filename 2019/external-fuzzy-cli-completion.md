---
category: 'computing, unix'
date: '2019-10-30'
summary: |
  Use an external fuzzy-finder as a replacement for writing burdensome and slow
  shell completion functions.
---

# Use an External Fuzzy-finder for CLI Completion

## Fuzzy-Finders

CLI fuzzy-finders are really great. You feed them options via stdin, fuzzy-find
the match you want, then get the result via stdout (ready to be processed by
additional shell tools). Simple, fast, immediately useful, and if you can
already write a shell script there's nothing new to learn.

```sh
printf '%s\n' foo bar baz quux | fzy | xargs echo 'The result is'
```

<video src="./ff-demo.webm" controls loop preload="none" width="100%"></video>

There's a bunch. [fzf](https://github.com/junegunn/fzf) is the most popular and
featureful, but it's huuuuge at 10k LOC.
[fzy](https://github.com/jhawthorn/fzy) is an excellent and fast alternative
with great matching at just 1200 lines of C. One of the great things about the
simple stdin/stdout contract is you can easily swap out one with another as
you're testing behahvior, UI, matching, etc.

## Shell Completion

Shell completion usually isn't as convient or fast as a fuzzy-finder. Even
super fancy, menu-centric completion like in Zsh isn't as nice. Not even close.
Plus shell completion is difficult and time-consuming to write. It's _very_
shell-specific code and often archaic. A very stark contrast to the
stdin/stdout contract.

It would be nice if we could invoke a fuzzy-finder instead of the built-in
shell completion.

Turns out that's pretty simple with Zsh:

```sh
fzy-completion() {
    setopt localoptions localtraps noshwordsplit noksh_arrays noposixbuiltins

    # Get what the user has typed in so far.
    local tokens=(${(z)LBUFFER})

    # Pluck out the first argument which is probably the command.
    local cmd=${tokens[1]}

    # Invoke a function or script and grab the result.
    local result=$($run_something "${tokens[@]}")

    # Put the result back on the CLI where the user left off.
    if [ -n "$result" ]; then
        LBUFFER="$result"
    fi

    zle reset-prompt
}

# Invoke completion when the user presses ctrl-f.
zle -N fzy-completion
bindkey '^F' fzy-completion
```

You can see a full, working implementation here:

[https://github.com/whiteinge/dotfiles/blob/eed357dc/.zshrc#L276-L335](https://github.com/whiteinge/dotfiles/blob/eed357dc/.zshrc#L276-L335)

It works by searching for a shell function or a shell script on `$PATH` that
matches the pattern `_fzy_<cmd>` where `cmd` is the command the user typed.
This pattern makes it dead-simple to write arbitrary completion functions in
just a few lines of whatever script language you care to write.

## Examples

You can see several full examples in this directory:

[https://github.com/whiteinge/dotfiles/tree/master/bin](https://github.com/whiteinge/dotfiles/tree/master/bin)

## Example Demos

[`cd` to a child directory](https://github.com/whiteinge/dotfiles/blob/eed357dc7696f6c8d608e06172e0e43da4ab79fb/bin/_fzy_cd):

<video src="./ff-cd.webm" controls loop preload="none" width="100%"></video>

[Complete an arbitrary file path](https://github.com/whiteinge/dotfiles/blob/eed357dc7696f6c8d608e06172e0e43da4ab79fb/.zshrc#L283-L287):

<video src="./ff-files.webm" controls loop preload="none" width="100%"></video>

[Complete Git branches or tags](https://github.com/whiteinge/dotfiles/blob/eed357dc7696f6c8d608e06172e0e43da4ab79fb/bin/_fzy_git):

<video src="./ff-git.webm" controls loop preload="none" width="100%"></video>

[Complete from your shell history](https://github.com/whiteinge/dotfiles/blob/eed357dc7696f6c8d608e06172e0e43da4ab79fb/.zshrc#L276-L281) (if you haven't yet typed a command):

<video src="./ff-history.webm" controls loop preload="none" width="100%"></video>

[Complete process IDs for `kill`](https://github.com/whiteinge/dotfiles/blob/eed357dc7696f6c8d608e06172e0e43da4ab79fb/bin/_fzy_kill):

<video src="./ff-kill.webm" controls loop preload="none" width="100%"></video>

[Search and complete from all available manpages](https://github.com/whiteinge/dotfiles/blob/eed357dc7696f6c8d608e06172e0e43da4ab79fb/bin/_fzy_man):

<video src="./ff-man.webm" controls loop preload="none" width="100%"></video>

[Complete known `ssh` hosts](https://github.com/whiteinge/dotfiles/blob/eed357dc7696f6c8d608e06172e0e43da4ab79fb/bin/_fzy_ssh):

<video src="./ff-ssh.webm" controls loop preload="none" width="100%"></video>

[Complete npm run scripts](https://github.com/whiteinge/dotfiles/blob/eed357dc7696f6c8d608e06172e0e43da4ab79fb/bin/_fzy_npm) from a `package.json` file. (And it won't try to complete other npm sub-commands.)

<video src="./ff-npm-scripts.webm" controls loop preload="none" width="100%"></video>
