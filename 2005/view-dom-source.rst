Viewing the DOM Source with Firefox
===================================

:pub_date: 2005-12-15

I'll be the first to admit that blogging about not-so-obvious features in
software isn't always cool, unless that happens to be `your thing`_. However,
I somehow missed this (almost) amazing functionality in Firefox until just
now.

When modifying the Document Object Model (DOM) with Javascript or ECMAScript
it can be frustrating trying to visualize the difference in page structure
between what the browser ultimately sees and renders, and what the unmodified
'View Source' function shows you. There have been `Bookmarklets`_ that do the
job, however Firefox has the ability to do this natively.

When you highlight something in a page, right-click that selection and click
'View Selection Source'. Voila, you have the ability to view the modified DOM
source!

Ideally Firefox should have another button for the DOM source without you
having to highlight everything, but this does give you the ability to
highlight only the portion of the page you're interested in. Also, I don't
know why this isn't an option in the otherwise amazing `Web Developer
toolbar`_.

Thanks to Jeremy Fujimoto-Johnson for pointing this out in a comment on the
above-linked NCZOnline site.

*Update* 2006-01-05: Hooray! The just-updated version of the Web Developer
toolbar greatly improved all menus including a new "View Generated Source"
function.


.. _your thing: http://www.macosxhints.com/
.. _Bookmarklets: http://www.nczonline.net/archive/2005/3/140
.. _Web Developer toolbar: https://addons.mozilla.org/extensions/moreinfo
    .php?application=firefox&id=60

Archived Comments
-----------------

Justin
    I never knew that. Now it will be 100 times easier to write my AJAX apps. Thanks!
Jeremy Fujimoto-Johnson
    You may be interested in the fairly new extension FireBug. It has nice DOM
    browsing functionality and shows a decent view of the DOM source.
