TITLE({"Cool URIs don't change; so what's considered 'cool'?"})
CATEGORY({"computing, web"})
DATE({"2007-05-20"})

Cool URIs don\'t change; so what\'s considered \'cool\'?
========================================================

I\'ve given a lot of thought, lately, to the famous [Cool URIs don\'t
change](http://www.w3.org/Provider/Style/URI) W3C document. Should URLs
end in a slash or not? Should they end in a file-extension or not? (What
if you\'re serving multiple formats of the same document?)

I\'ve been using a trailing slash (for, admittedly, no defensible
reason: the Django guys do it, and they\'re cool). A trailing slash
implies a directory, which doesn\'t apply to serving a document\--unless
you think of it as a directory containing that document in a variety of
formats.

Which brings us to the file extension dilemma. It seems appropriate to
serve differing formats for differing extensions (e.g. HTML, PDF, XML,
JSON); but, perhaps it\'s best to keep the URL generic and rely on the
\"Accept\" field in the request header to decide on the best output
format.

Certainly not many tools support this kind of respect for HTTP headers,
but I\'m starting to believe that fully embracing HTTP is The Right
Thing (TM), and it\'s the direction the industry is (slowly) moving
toward.
([REST](http://tomayko.com/articles/2004/12/12/rest-to-my-wife)!)

Incidentally, screw the W3C for not including PUT and DELETE in HTML.
Oh, and HTTP authentication needs some serious work. /EORant
