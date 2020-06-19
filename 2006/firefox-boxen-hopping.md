TITLE({"Firefox and boxen-hopping"})
CATEGORY({"computing, web"})
DATE({"2006-03-30"})

Firefox and boxen-hopping
=========================

_Update 2006-12-20_

_Firefox *is* very easy to personalize via configuration files. I've
found the `userChrome.css` and `userPref.js` files to be surprisingly
capable, I've added them as well as my bookmarks file to my
[dotsync](https://github.com/whiteinge/dotfiles/blob/6a2377c/.zshrc#L228)
for a (very) minimal Firefox UI footprint (pictured)._

_The original post follows._

![A minimal Firefox window layout](./firefox-layout.jpg)

The web is my platform of choice. It really boils down to simplicity in
boxen hopping. I routinely jump between my laptop, home desktop, home
server, work desktop, work server, and whatever other computers I happen
to be building or working on at the moment. Having consistent
configurations in all those locations is critical to getting any serious
work done. If I need a calculator I don't want to worry about starting
Windows calc or using a Dashboard widget or Calculator.app or hoping
that bc is installed on whatever UNIX I'm using; my preference is to
hit ctrl-k and use Google Calculator because it's the same for any
Firefox installation. [Google](http://www.google.com/help/features.html)
and Firefox Quick Searches play a large role in making the web a viable
platform.

My productivity is based on two environments, Firefox and a terminal.
The terminal environment is easy to keep up-to-date and synced between
disparate computers due to the wonders of scripting and so-called
[dotfiles](https://github.com/whiteinge/dotfiles). Firefox, on the other
hand, isn't as simple to keep consistent. I tend to be a purist when it
comes to extending most software, I dislike installing extensions or
plug-ins especially when each new release of the base program requires
updates to the add-on. Although Firefox is fairly decent at
automatically updating extensions, and with the up-and-coming 1.5
release decent at updating itself, sometimes it corrupts preferences or
an extension author is late to release an update. When I install a fresh
copy of Firefox on a new computer my bookmarks is the only file that is
easily put in place since the prefs.js file is littered with
extension-specific lines.

Unfortunately there are a few Firefox extensions I simply cannot live
without and I feel strongly that all of these unless otherwise noted
should be the default behavior for Firefox.

[SessionSaver](http://forums.mozillazine.org/viewtopic.php?t=47184)

:   Opera does this, and has for some time. All browsers need to allow
    complete and instant recovery from crashes. This extension will save
    your window positions, tabs, and even what you were typing. It is
    imperative that this be built into vanilla Firefox.

[Tab X](http://extensionroom.mozdev.org/clav/#tabx)

:   Firefox both introduced and hooked me to tabs, yet of all the tabbed
    browsers Firefox is strangely the least configurable and the least
    usable without resorting to extensions. The default behavior of
    having one close tab button on the far right that only works for
    your current tab is a minor usability issue, this little extension
    gives a close button on each tab. Safari got this right from the
    beginning and pulled off near-perfect tabs with only three
    checkboxes in the preferences.

[linkToolbar](http://cdn.mozdev.org/linkToolbar/)

:   I really appreciate being able to quickly traverse up a web
    directory tree. Safari's solution is especially elegant; if you
    Command-click the window title it will bring up a quick menu. This
    extension also allows you to navigate using the increasingly used
    rel header tags. Why let people with disabilities have all the fun?

[ViewSourceWith](https://addons.mozilla.org/firefox/394/)

:   Web applications are starting to come of age, yet the input methods
    browsers employ are two decades in the past. ViewSourceWith allows
    you to use an external editor for textareas which will continue to
    be useful until browsers modernize, a native spell check may be a
    good start. I use Vim. (Note: this extension seems to have replaced
    the seldom-updated MozEx.)

[Web Developer Toolbar](https://addons.mozilla.org/extensions/moreinfo.php?application=firefox&id=60)

:   The Web Developer Toolbar is critical to my professional work.
    However, since I'm not always at work it doesn't need to be
    installed on every computer I use. Therefore I will make an
    exception to this extension since I don't mind installing it
    occasionally.

[Flashblock](https://addons.mozilla.org/extensions/moreinfo.php?application=firefox&id=433)

:   Unfortunately this extension is a must on the Macintosh otherwise
    Flash-heavy sites can make your computer completely unusable. This
    extension lets you start Flash animations selectively. Again, this
    extension deserves exception since it is hardly Mozilla's fault
    that [the OS X Flash player sucks](../2004/yeti-gore.html).
