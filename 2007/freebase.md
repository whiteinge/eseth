---
category: 'computing, web'
date: '2007-09-06'
---

Freebase
========

I\'m working on a project that required a database of video games (name,
release date, box-art, etc.). Too much information to input manually, so
we began looking for commercial offerings. There are two players in the
field: [Muze](http://www.muze.com/) and
[AMG](http://www.allmediaguide.com/).

It\'s quite obvious they realize they have this market cornered, their
sales representatives are the most uncooperative people I\'ve every
tried to buy something from \-- AMG never even returned my two email
requests nor my voicemail. But, hey, I\'m just the code-monkey; once the
money-guy got involved they started talking?barely.

After nearly two-and-a-half weeks of trying, we finally were able to get
pricing information. Suffice it to say, our talk of \'Let\'s make
something cool.\' drastically shifted to \'How long can we possibly
endure this expense?\' Doubt crept into our minds as to the ultimate
feasibility of the project.

So we began to search for *any* possible alternatives. One interesting
idea \-- querying Wikipedia \-- quickly lead to a very interesting
possible solution: [Freebase](http://www.freebase.com/). A web service
that offers programmatic access to a huge variety of data which they
glean from Wikipedia, as well as other sources.

I have fallen head-over-heels in love with this service over the last
week. Information from their database is released under the GNU
Documentation License (same as Wikipedia). Their API is very well
documented, has many examples, features a [live query
editor](http://www.freebase.com/view/queryeditor/) (check out the
[QueryBuilder](http://dev.scissor.com/querybuilder/) for newbies), and
they have ready-to-use example libraries for use with Python, PHP, and
Perl. Queries to and from their system are formatted as
[JSON](http://en.wikipedia.org/wiki/JSON) and accessed via a
[RESTful](http://en.wikipedia.org/wiki/Representational_State_Transfer)
URL structure. Freebase, simply, could not be easier to use!

Freebase has listings for around 11,000 video games which doesn\'t
compare to the commercial vendor\'s claim of \~45,000. But they seem to
have most recent releases which is exactly what I need. And hey, it\'d
be cheaper to pay a high-school gamer to do data entry into Freebase\'s
slick web interface than to pay those dick-heads at Muze or AMG.

For the folks behind Freebase, my hat is off to you!
