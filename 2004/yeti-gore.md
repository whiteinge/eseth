TITLE({"Yeti Gore Flash game"})
CATEGORY({"computing"})
DATE({"2004-12-16"})

Yeti Gore Flash game
====================

Here\'s a little [penguin batting
practice](http://www.yonkis.com/mediaflash/yeti_gore.htm) game. This
site is *not* safe for work (NSFW)! However, the game itself is clean
because:

> Remember what the MPAA says: Horrific, deplorable violence is okay, as
> long as people don\'t say any naughty woids!

Quick tangent: Macromedia really needs to overhaul their Linux and Mac
Flash players. They both have *huge* lack-of-performance issues, but the
Mac player is almost unusable. Often times sites with Flash ads will
bring my 1.33 GHz Powerbook to it\'s knees and I struggle to scroll the
window down with 100% CPU utilization.

The Linux player specifically has massive sound latency issues. Maybe
the Linux community wouldn\'t bad-mouth Flash so much if we weren\'t
continually embarrassed in front of our Windows friends every time we
try to show them the latest [JibJab](http://www.jibjab.com/) cartoon and
the audio can\'t stay synced for the 90-second duration. This Flash game
in particular is very difficult to play because if your sound is enabled
it will cause the player to skip as you\'re trying to bat. It played
very smoothly on my friends\' 1 GHz Windows laptop.

Macromedia, if you\'re thinking about [pledging solid Linux
support](http://news.zdnet.com/2100-3513_22-5170061.html), then please,
please start with the Flash player!

Archived Comments
-----------------

John Dowdell

:   If you\'ve been around, then you\'ll remember that each recent
    generation of the Macromedia Flash Player has had extra Mac-specific
    engineering done for performance optimization. One of the big gates,
    though, is the way that processor cycles are distributed among guest
    processes in browsers? you can often see big differences between
    standalone playback and in-browser playback. It\'s still an ongoing
    goal, but there are major roadblocks in the way.

    If you\'re seeing 100% CPU utilization with ad-heavy pages, then
    from what I\'ve seen this is most frequently caused by designers who
    choose excessively high framerates. Disney worked well with 12fps?
    requesting more frames-per-second than the hardware can deliver is a
    sure way to choke off the machine\'s overall interactivity.

    For Linux it\'s different \-- here the top request seems to be
    \"create engines which run on more Linux flavors, in more browser
    configurations\". Of course, there are many requests for authoring
    tools too, but I haven\'t seen recent analysis on how much money
    this might actually return? Codeweavers is the best bet here now.

    Regards, John Dowdell Macromedia Support
