:Date: 2016-03-20

.. _post-flux-with-rxjs:

========================================
Flux with RxJS using the Reducer Pattern
========================================

.. index:: computing, react, javascript, rxjs, reactive extensions

.. rubric:: Or, How to Implement Flux using vanilla RxJS

The JavaScript port of Microsoft's Reactive Extensions (RxJS) has caught the
JavaScript public's eye in a big way over the last year or two. And for good
reason: It presents a unified API on top of asynchronous operations -- and
there are plenty of those in day-to-day JavaScript.

Much of its strength is because it is a general-purpose library. A JavaScript
implementation of a `mature API specification`__. Reactive Extensions has been
around since 2009 and `open sourced in 2012`__.

.. __: http://reactivex.io/languages.html
.. __: https://blogs.msdn.microsoft.com/interoperability/2012/11/06/ms-open-tech-open-sources-rx-reactive-extensions-a-cure-for-asynchronous-data-streams-in-cloud-programming/

It can solve many problems often tackled by more specific libraries, and it can
often solve them with a terse, readable syntax. The large API surface area of
Rx can look intimidating at first glance. But the base concepts of Rx are
simple and easy to grasp. Once you're over that hurdle the large API becomes an
asset.

Besides, `"It is better to have 100 functions operate on one data structure
than 10 functions on 10 data structures."`__

.. __: http://www.cs.yale.edu/homes/perlis-alan/quotes.html

This post explores using RxJS and React to implement Facebook's Flux
recommendation. The first section is a high-level overview of the pattern, and
the Appendex below that contains low-level implementation details and
lessons-learned building a large application with this pattern.

.. contents:: Contents
    :local:
    :depth: 2

Introduction
============

(Jump straight to the "Dispatcher" section if you're already topically familiar
with React, Redux, and Rx.)

The state of the Flux ecosystem
-------------------------------

Facebook's Flux is a recommendation for how data should flow through an app.
There are many `unidirectional architectures`_ but Flux largely reintroduced
the idea to a new generation of developers. Facebook implemented an example
dispatcher (an event emitter) but otherwise left the implementation details to
the community. At the time of this writing there are well over twenty libraries
that implement Flux in various ways. The current front-runner, by a wide
margin, is `Redux`_.

.. _`unidirectional architectures`: http://staltz.com/unidirectional-user-interface-architectures.html
.. _`Redux`: http://redux.js.org/

Redux is popular for a reason. It is a tiny-tiny and crazy-simple Flux
implementation that has a strong functional bent. It makes use of the "reducer
pattern" for managing application state. The reducer pattern, like the name
suggests, can be thought of as a reduce function over time -- a function that
maintains state and modifies that state in a predicable, testable way on each
invocation.

Flux is not yet a solved problem. It is still being widely explored and
experimented with, often in conjunction with virtual-DOM libraries like React.
Adopting Flux and React (or similar) for a project will mean that you must
think about basic parts of your app architecture. It is not an opinionated
out-of-box solution like, say, `Ember`_. But Flux is a good pattern for
user-interfaces and it is good enough to get you productive building real apps
*now*.

.. _`Ember`: http://emberjs.com/

RxJS and React
--------------

RxJS can implement Flux and the reducer pattern in just a few lines. React and
RxJS work fairly well together. React's rendering API is already reactive (even
though `the remaining API is not`__).

.. __: http://staltz.com/dont-react

There are many, many projects and posts online exploring how to pair Rx and
React. Some are even from people on the team at Facebook. Frequent ideas are to
embed Observables inside React components or to use React lifecycle methods to
attach/reattach Rx event listeners as the virtual DOM changes. And to use many
Rx ``Subject`` instances often as actions. My initial attempts to pair the two
were along those same lines but the reactive/imperative dichotomous nature of
React makes it challenging to intertwine them cleanly.

In my experience Rx best lives at the Flux level as a wrapper around otherwise
idiomatic React.

The rest of this post describes an implementation born from the question, "What
is the most simple and most literal way to implement Flux using Rx?"

The base pattern can be described very simply (pseudo-code):

.. code:: javascript

    var Actions = new Rx.Subject();
    var Dispatcher = Actions.asObservable();

    var Store = Dispatcher
        .filter(x.tag === ACTION)
        .scan(accumulateState, initialValues());

    var View = Store
        .map(buildVDOMMLMarkup);

    var page = View
        .subscribe(vdom => ReactDOM.render(vdom, domElement);

`See this Gist for a minimal but full POC.`__

__: https://gist.github.com/whiteinge/e8edb98ca8e94d769b8b827de6082427

This pattern is almost laughably simple. Like composing functions in vanilla
JavaScript, composing Observables in Rx is easy and it can easily grow as your
app grows.

We use this for a large, complex app at my work. It grew to encompass
order-dependent async calls, interdependent stores, dynamic content placement,
code reuse, real-time notifications, user preferences, ajax response caching,
routing, and splitting an app into separate modules -- all within the Flux data
stream provided by Rx.

And of course like all Flux variants it's good for team projects since each bit
of the app lives in a predictable place. It uses canoncial RxJS wrapping
canonical React meaning there is no additional API to learn.

The following section describes each part of the base "Flux in Rx" pattern from
a high-level. The Appendix follows that with low-level implementation details
from a real-world app as well as suggestions and lessons-learned.

RxJS, Flux, the Reducer Pattern, and React
==========================================

As a reminder, data flow in Flux flows in one direction and flows in a circle.

.. code:: text

    ^ --> Actions --> Dispatcher --> Stores --> Views -->
    |                                                   |
    <---------------------------------------------------v

Actions
-------

`The dispatcher exposes a method that allows us to trigger a dispatch to the
stores, and to include a payload of data, which we call an action.`__

.. __: https://facebook.github.io/flux/docs/overview.html#actions

The first thing we need is a bridge into React's imperative API. Subjects in Rx
are sometimes frowned on as easy to misuse and overuse but `the intended
use-case for Subjects is to provide an interface to an external imperative
system`__. In this example we're replacing the ``onCompleted`` method with a
no-op -- this is a little Rx "inside baseball" but it prevents things that
interact with the Subject from accidentally stopping it.

.. __: http://davesexton.com/blog/post/To-Use-Subject-Or-Not-To-Use-Subject.aspx

.. code:: javascript

    var Actions = new Rx.Subject();
    Actions.onCompleted = () => {}; // never complete

This provides a central place to push actions from React and other places into
Rx. Actions should have a consistent structure. In this post we will enforce
that an action payload is an object with ``tag`` and ``data`` attributes.

.. code:: javascript

    var act = (tag, data = {}) => ({tag, data});

The ``onNext`` method on a Subject pushes an action into the Subject but this
is called frequently so a terse wrapper is nice. Facebook advises the same,
"`The action's creation may be wrapped into a semantic helper method which
sends the action to the dispatcher.`__"

.. __: https://facebook.github.io/flux/docs/overview.html#actions

.. code:: javascript

    var send = tag => data => Actions.onNext(act(tag, data));

.. _dispatcher:

Dispatcher
----------

`The dispatcher is the central hub that manages all data flow in a Flux
application. [...] [I]t can be used to manage dependencies between the stores
by invoking the registered callbacks in a specific order.`__

.. __: https://facebook.github.io/flux/docs/overview.html#a-single-dispatcher

The Dispatcher typically provides two main benefits: to provide a single
entrance for all incoming data, and to orchestrate dependent stores. Many Flux
variants remove the dispatcher as unnecessary complexity and we don't need one
here because Rx can just naturally combine stores. However the data
centralization is useful for debugging and predictability and there are `good
reasons to keep it`__. Besides, it's a one-liner:

.. __: https://speakerdeck.com/jmorrell/jsconf-uy-flux-those-who-forget-the-past-dot-dot-dot-1

.. code:: javascript

    var Dispatcher = Actions.asObservable();

Subjects in Rx already broadcast incoming items to subscribers so this just
enforces that the Dispatcher is a read-only.

.. _stores:

Stores
------

`Stores contain the application state and logic.`__

.. __: https://facebook.github.io/flux/docs/overview.html#stores

Stores receive events (actions) from the Dispatcher. Rather than passively wait
to be called by the Dispatcher, they watch all actions emitted and filter what
they care about. This allows stores to be decoupled from the greater app and to
be `in full control over [themselves]`__.

.. __: http://staltz.com/dont-react

.. code:: javascript

    var MyStore$ = Dispatcher
        .filter(x.tag === USER_ACTION);

Keeping track of user actions, or view state, is where the reducer pattern
really shines. It becomes almost trivial. The Rx ``scan()`` method is a reduce
operation *over time*.

.. code:: javascript

    var CounterStore$ = Rx.Observable.merge([
            Dispatcher.filter(x.tag === INCREMENT_COUNTER).map(1),
            Dispatcher.filter(x.tag === DECREMENT_COUNTER).map(-1),
        ])
        .scan(function(total, change) {
            return total + change;
        }, 0);

A perennial problem in most all Flux variants is the "async problem". Do async
operations go in the store, or in the action creator, or outside Flux entirely?
Should the store or the action creator be heavy or light? Well async is the
bread-and-butter of Rx so that issue simply *vanishes*.

.. code:: javascript

    var UserListStore$ = Dispatcher
        .filter(USER_LIST)
        .flatMap(() => Rx.DOM.getJSON('https://api.github.com/users'));

Of course, it's better to not to hard-code an xhr call directly in your store.
The example above is illustrative because it demonstrates the idea succinctly.
Follow best-practices; you probably have a custom library or utility functions
for communicating with your backend. The takeaway is stores can *ignore* the
difference between calling sync or async functions. Collecting user interaction
with the DOM, collecting xhr responses, reading from LocalStorage, listening to
an SSE or websockets stream -- the pattern is the *same* for each one.

There are typically many stores. Each one is the source of truth for a given
bit of data, or sometimes a collection of tightly related data. For example, an
ajax response, a *processed* ajax response, user clicks, or view state like
which table columns are shown and which are hidden.

Views
-----

Views are just another data transformation step in the pipeline. They transform
data structures of state, data, ajax responses, and more into virtual DOM
markup.

.. code:: javascript

    var UserListView$ = UserListStore$
        .map(function(userList) {
            return (
                <ul>
                    {userList.map(login => <li>{login}</li>)}
                </ul>
            );
        });

Views tend to be quite simple. Plain JavaScript functions and stateless
functional components (introduced in React 0.14) work extremely well in this
pattern. When a store changes, the view will automatically update. Full
components using ``createClass`` are more rare and ``setState()`` isn't often
used in favor of the more functional: passing props.

`Close to the top of the nested view hierarchy, a special kind of view listens
for events that are broadcast by the stores that it depends on. We call this a
controller-view.`__

.. __: https://facebook.github.io/flux/docs/overview.html#views-and-controller-views

Controller views or controller components are common in React and they role
they serve here is to combine multiple stores together and prep the data for
easy use within other components. In this pattern, once again they are just
regular functions within the Observable stream, usually combining multiple
streams together.

.. code:: javascript

    var MyControllerView$ = UserListStore$
        .combineLatest(CounterStore$, function(userList, counter) {
            return {
                userList: userList.sort(),
                counter,
            };
        });

    var MyView$ = MyControllerView$
        .map(function({userList, counter}) {
            return (
                <p>Total: {counter}</p>

                <ul>
                    {userList.map(login => <li>{login}</li>)}
                </ul>
            );
        });

Actions
-------

Actions bring us back, full-circle, to React's largely imperative API. It is
certainly possible to make a fully reactive wrapper around React but doing so
is tricky and requires a good bit of code -- usually involving multiple
Subjects, React component wrappers to make use of lifecycle methods in order to
expose the DOM, and frequently attaching and reattaching event listeners to the
changing DOM. It feels too much like fighting React.

In the name of pragmatism we instead stick with idiomatic React and use inline
JavaScript callbacks to imperatively push data into the Dispatcher using the
familiar Rx ``onNext`` API.

.. code:: javascript

    <li onClick={() =>
            Dispatcher.onNext({tag: USER_DETAIL, data: {login}})}>
        {login}
    </li>)}

Of course, that is far too verbose so we'll take Facebook's advice, `The
action's creation may be wrapped into a semantic helper method which sends the
action to the dispatcher.`__

.. __: https://facebook.github.io/flux/docs/overview.html#actions

.. code:: javascript

    var UserListView$ = UserListStore$
        .map(function(userList) {
            return (
                <ul>
                    {userList.map(login =>
                        <li onClick={send(USER_DETAIL, {login})}>
                            {login}
                        </li>)}
                </ul>
            );
        });

And even better without JSX (more on this in the Appendix):

.. code:: javascript

    var UserListView$ = UserListStore$
        .map(function(userList) {
            return h('ul', userList.map(login =>
                h('li', {onClick: send(USER_DETAIL, {login})})
            ));
        });

The ``send`` function is an action creator -- a simple wrapper around
``Dispatcher.onNext`` to present a terse interface for formatting an action and
the associated data. The goal of these functions is to reduce clutter from the
view via a friendly interface. More examples are in the Appendix.

The payload that makes up an action is two things: an identifier that describes
the action type or category, and an optional data object containing additional
action details such as the button clicked of the form data being submitted.

Side Effects
------------

There is one important thing remaining which is to tell React to render the
result of the view to the page. But this is not related to the data flow within
the app. This can instead be thought of as a side-effect. Rendering is a
fire-and-forget operation; we don't need anything back from the rendering
process. The beauty of React is that we can just throw vdom at it and it will
render in the most efficient way possible.

.. code:: javascript

    MyView$
        .subscribe(function(content) {
            ReactDOM.render(content, document.querySelector('#content'));
        });

This also brings us to the very first explicit call to ``subscribe()`` in the
app. The entire application up to this point has been encapsulated inside an
observable stream. The functions that operate on the stream are pure functions
making them easy to predict and to test. There is a single place in the app
that performs side-effects which makes the app more predictable.

Due to the multicast nature of how we're using Rx we can "tap in" to any part
of the Flux loop and still keep side-effects localized. For example, since
everything flows through the Dispatcher it is a fantastic debugging tool:

.. code:: javascript

    Dispatcher
        .subscribe(x => console.log('Dispatching:', x.tag, x.data));

Because calls to ``subscribe()`` can and do affect things outside the data flow
stream it is best to keep these few in number and in predictable places only.
See the Appendix for "Tasks" to see one method for centralizing these.

A note about ``ReactDOM.render()``
``````````````````````````````````

It may look unusual to repeatedly call ``ReactDOM.render()`` but React handles
it just fine. Calling ``setState`` within stateful components still works the
same way.

Treat the observable step that produces the view exactly the same way as the
``render()`` method within a component. Don't trigger the view observable until
you actually want to update the DOM -- exactly the same as calling ``setState``
or changing props on a child would trigger the component's ``render()`` method.

Use operators like ``withLatestFrom`` and ``distinctUntilChanged`` and have a
clear path in the stream to explicitly trigger the view observable. That will
avoid any unnecessary React work but with more granularity since Rx combines
observables so easily.

For most apps "rendering from the top" like this is fast enough. Benchmark your
app *before* deciding if you fall into the category of "truly performance
concious" because you may be surprised!

`Stateless functional components are not yet optimized`__ in React and
immutable data structures are not commonplace in JavaScript so occassionally
you do need an escape hatch. One such hatch is to wrap a particular
performance-sensitive component in a "guard" component that uses
``shouldComponentUpdate`` to prevent render updates "from the top" from
checking that section of the vdom. (This is also the approach used with
libraries that manage their own DOM like d3 to prevent React and d3 from
stepping on each other.) An excellent library that provides a "guard" component
and allows using Observables directly in the view is `react-combinators`_.

.. __: https://github.com/facebook/react/issues/5677
.. _`react-combinators`: https://github.com/milankinen/react-combinators

Conclusion
----------

It is all idiomatic React -- only wrapped inside an Observable stream. And the
basic concept can be demonstrated in roughly eight lines of Rx code.

It also provides full access to the entirety of Rx -- combining streams,
ordering async operations, caching results, buffering, throttling,
backpressure, pausing, subscribing, disposing, and others.

The biggest struggle we have had with this pattern so far is one that React
itself also struggles with: walking the line between stateless components and
stateful components.

React is clearly trying to move to a more functional style evidenced by their
render method, the introduction of stateless functional components, and by
their recommendation of smart controller-components encapsulating "dumb"
stateless-components (same as the controller-view described above). But the
JavaScript community is traditionally object-oriented and it's a large ship to
try and steer. It will take time.

Tracking state within a store, specifically within a scan operation as in the
examples above is much, much simpler than tracking state within a component but
it also presents reuse challenges. Our approach to that is below in the
Appendix.

We chose Rx for our project because it is a heavily asyncronous project with
lots of user interaction. Using Rx to implement Flux just naturally fell out of
it because it can solve general-purpose problems. I highly recommend learning
Rx, even for small projects. The API is large and can feel daunting to
newcomers but the primitives are simple. Once you get over the hurdle of those
basics, the library is widely applicable to so many problems and the consistent
API makes light work of complex workflows. It's well worth the time investment.

Appendix
========

The section above explains the "why". This section delves deeper into the
"how". A lot of this is specific to a particular use-case and may not be
broadly useable. It is not a reusable framework but rather an explanation of
patterns. It is detailed here with the optimism that it may offer inspiration
or may help steer readers clear of pitfalls.

Additional example code can be found in the following Gists:

* `Dispatcher util functions and xhr util functions
  <https://gist.github.com/whiteinge/50304c8d985a730d98e9>`_
* `A POC for separating an xhr response from progress events
  <https://gist.github.com/whiteinge/90ba12057c3a54d578cb>`_

Actions
-------

The form that actions and action creators take is one of the main variations of
the Flux variants.

.. _appx-actions-namespace:

Namespace actions
`````````````````

Actions are often flat strings in Flux variants -- usually something that can
be fed into a switch statement. We've found that hierarchical, namespaced
actions are helpful in cutting down on the number of actions as well as a
non-verbose way for multiple stores to trigger off the same action.

I work at `SaltStack`_ which makes a real-time, event-based infrastructure
management tool called Salt. We make use of `namespaced event tags`__ which are
just strings that follow `UNIX shell globbing semantics`__ -- it's lightweight
and simple and works well for us. That turns out to also be a good pattern for
making hierarchical, namespaced Flux actions too. But if you're interested in
something more robust and formal, take a look at `rxmq.js`_ channels which are
awesome.

.. __: https://docs.saltstack.com/en/latest/topics/event/master_events.html
.. __: https://docs.python.org/2/library/fnmatch.html
.. _`SaltStack`: http://saltstack.com/
.. _`rxmq.js`: https://github.com/rxmqjs/rxmq.js

We use a wrapper method around Rx's standard filter method that parses
these namespaced tags called `byTag()`__. It makes short work of creating
stores. Below is a hypothetical store that takes searches from a user and fires
off an ajax request for each to try and autocomplete what the user is searching
for:

.. __: https://gist.github.com/whiteinge/50304c8d985a730d98e9#file-rxjs-flux-utils-js-L86-L110

.. code:: javascript

    var AutocompleteGuesses = Dispatcher
        .byTag('app/search/autocomplete')
        .debounce(500)
        .pluck('data', 'text')
        .flatMapLatest(text => Rx.DOM.getJSON(`/search?q=${text}`));

Listening for multiple actions in the same "category" or "channel" is done via
globbing on a namespace:

.. code:: javascript

    var AllNotifications = Dispatcher
        .byTag('app/*/notification/new');

.. /* vim syntax fix

Constants
`````````

In the examples above strings are easy to fat-finger. Using constants prevents
typos, allows editor completion, and provides a place for documentation:

.. code:: javascript

    // User search actions for the autocomplete widget.
    const SEARCH_AUTOCOMPLETE = 'app/search/autocomplete';

    // All notifications from all modules in the app.
    const ALL_NOTIFICATIONS = 'app/*/notification/new';

.. /* vim syntax fix

As the examples above hint, the tag or type is often best written
as a constant that (usually) refers to a string. This allows development tools
to autocomplete and more easily detect typos and errors.

Action creators
---------------

Action creators in this pattern are generic helpers for pushing events into the
Dispatcher. Many Flux variants have heavy action creators, sometimes even one
unique action creator per action but that spreads logic between action creators
and stores with no clear distinction between them. Rx-based stores are so
open-ended that verbosity isn't needed and so action creators are simply
syntactic sugar for formatting common actions as tag/data pairs.

If you wish to enforce that these action creators are the only interface for
sending actions through the Dispatcher you should use the `asObservable`__
method when exporting it.

.. __: https://gist.github.com/whiteinge/50304c8d985a730d98e9#file-rxjs-flux-utils-js-L11-L14

We make use of only three simple action creators:

`send`__

.. __: https://gist.github.com/whiteinge/50304c8d985a730d98e9#file-rxjs-flux-utils-js-L30-L61

The most often used. It partially-applies itself to make short work of inline
React event handlers.

.. code:: javascript

    <button onClick={
        send(C.BUTTON_CLICKED)
    }>Click me</button>

    // or

    h('button', {
        onClick: send(C.BUTTON_CLICKED),
    }, 'Click me');

Or including event data in the action.

.. code:: javascript

    h('input', {onChange: send(C.AUTOCOMPLETE, {
        value: (ev) => ev.target.value}),
    });

`sendTag`__

.. __: https://gist.github.com/whiteinge/50304c8d985a730d98e9#file-rxjs-flux-utils-js-L16-L28

The direct, non-partially-applied function that ``send()`` wraps.

`sendForm`__

.. __: https://gist.github.com/whiteinge/50304c8d985a730d98e9#file-rxjs-flux-utils-js-L63-L84

A wrapper around `form-serialize`_ for quickly grabbing all form field values
in an `onSubmit` event callback:

.. _`form-serialize`: https://github.com/defunctzombie/form-serialize

.. code:: javascript

    h('form', {onSubmit: sendForm('some/tag')}, [
        h('input', {name: 'foo'}),
        h('input', {name: 'bar', type: 'checkbox'}),
        h('button', 'Submit'),
    ]);

Dispatcher
----------

As mentioned above, logging actions to the console that come through the
Dispatcher is a fantastic debugging tool. In production builds you don't always
have access to viewing the JavaScript console. But it's trivial to maintain a
rolling recording of the most recent events to come through the Dispatcher:

.. code:: javascript

    // Keep the 200 most recent events.
    var DispatcherBuffer = new Rx.ReplaySubject(200);

    Dispatcher.subscribe(DispatcherBuffer);

    // Include uncaught errors in the recording.
    var DispatcherRecording = DispatcherBuffer
        .catch(function(err) {
            return Rx.Observable.just({
                tag: 'app/core/error/uncaught',
                data: err,
            });
        });

This recording can be downloaded by the user and attached to a support ticket,
or submitted automatically to the server when there is an error. It can even be
*played back* by sending each event in the recording through the Dispatcher at
an interval. The result allows you to watch the user's basic actions as he or
she clicks through the app.

.. code:: javascript

    Rx.Observable.from(arrayOfEvents)
        .zip(Rx.Observable.interval(1000), evt => evt)
        .subscribe(evt => Dispatcher.onNext({evt.tag, evt.data}));

Stores
------

Stores are pretty open-ended. They store the business logic and data. Below are
some lessons-learned from our app that may or may not be helpful for other
apps.

Guard stores
````````````

With few exceptions, stores should be guarded by an Rx ``filter()`` call. We
make use of a custom ``byTag()`` wrapper as described in the :ref:`Namespace
actions <appx-actions-namespace>` section. You're going to have a lot of stores
so this guards them from having to do unnecessary work until they're explicitly
called.

.. code:: javascript

    var Store = Dispatcher.filter(x => x.tag === C.SOME_TAG);
    // or
    var Store = Dispatcher.byTag(C.SOME_TAG);

Default values
``````````````

Stores should usually have a default value, even if it's an empty default. This
is just a nice thing to be able to rely on for times when you subscribe to a
store and you don't yet know it's current state.

.. code:: javascript

    var Store = Dispatcher.byTag(C.SOME_TAG)
        .scan(function(acc, cur) {
            acc.foo = cur;
            return acc;
        }, init());

    function init() {
        return {
            foo: null,
        };
    }

Stores as Ajax responses
````````````````````````

Because Rx does async so well it doesn't matter if stores themselves are sync
or async. You work with them in the same way. If a Flux action triggers an
async operation, such as an ajax request, it doesn't matter when that store is
eventually populated, you can rest assured that when it is populated any
listeners (other stores or views) will react and update appropriately.

A store that represents an ajax response will either have the data or it won't
(yet) have the data. The store representing the response is not concerned with
whether the data is in-flight or whether there was an error. That is someone
else's job -- specifically the job of a `Progress Observer, already built into
Rx.DOM.ajax()`__.

.. __: https://github.com/Reactive-Extensions/RxJS-DOM/blob/master/doc/operators/ajax.md

The basic idea is each ajax request is tagged with an identifier, the same kind
of identifier that actions from the Dispatcher are tagged with. We use a thin
wrapper around ``Rx.DOM.ajax()``. The result looks like this:

.. code:: javascript

    var UserDetailStore = Dispatcher
        .filter(USER_DETAIL)
        .pluck('data', 'login')
        .flatMap((login) => xhrNext(
            'GET',
            `https://api.github.com/users/${login}`,
            {progress: USER_DETAIL}));

    var UserDetailProgress = Progress
        .byTag(USER_DETAIL);

``Progress`` is a global emitter, not unlike the Dispatcher. It allows us to
track whether there is an ajax request in-flight anywhere across the whole app
-- useful for a global "activity indicator" in the UI -- as well as the current
state of individual ajax requests. The store observable and the progress
observable can be used individually or combined together, for example, to show
a progress spinner in the view:

.. code:: javascript

    var UserDetailView = UserDetailStore
        .startWith(false)
        .combineLatest(UserDetailProgress, function(user, progress) {
            if (user && progress.type === 'load') {
                // Output user info.
            } else {
                // Output spinner graphic.
            }
        });

`You can view the full implementation of the Rx.DOM.ajax() wrapper in this Gist.`__

.. __: https://gist.github.com/whiteinge/50304c8d985a730d98e9#file-rxjs-xhr-utils-js-L10-L43

Centralize caching
``````````````````

It is tempting to use Rx ``shareReplay()`` method to cache xhr responses for
re-use between multiple stores without triggering addtional requests --
especially because it's a one-line addition to the store. However there are a
few drawbacks. One is each store is now responsible not only for the data but
also the cache. The other is that ``ReplaySubjects`` (which ``shareReplay``
uses internally) cannot *release* the stored data, even when there are no
subscribers.

Baking caching into the xhr layer directly keeps the two concerns separated and
still allows for some pretty neat Rx tricks. We implemented a decorator around
the ``xhrNext`` wrapper detailed in the previous section that does two things:

* It *automatically* caches the xhr response, and hangs on to that cache for as
  long as there are *active* Rx subscribers to that stream. Once there are no
  more subscribers (and after a small window) it purges the cache.
* It retains the ETag from xhr responses and automatically makes
  conditional-GET requests to the server. (Of course, this requires a server
  that supports these requests.) This allows very lightweight HTTP requests to
  look for updated data on the server. If the local cache is already the most
  up-to-date, then the local cache is replayed instead.

Once the decorator is in place the caching is transparent to the caller.

`The full implementation of the conditional-GET decorator is in this Gist.`__

.. __: https://gist.github.com/whiteinge/50304c8d985a730d98e9#file-rxjs-xhr-utils-js-L148-L161

Stores with many listeners
``````````````````````````

A short parting note about stores: subscriptions to the underlying observable
are not shared by default. Any store that expects to be reused between multiple
other stores or views should probably end with ``.share()``.

.. code:: javascript

    var Store1 = Dispatcher.byTag(SOME_TAG).scan(collectData);

    // These two stores will trigger the above .scan() twice.
    var Store2 = Store1.map(formatData);
    var Store3 = Store1.map(extractData);

    // vs.

    var Store1 = Dispatcher.byTag(SOME_TAG).scan(collectData).share();

    // These two stores will share the result of a single invocation of the
    // .scan() above.
    var Store2 = Store1.map(formatData);
    var Store3 = Store1.map(extractData);

Views
-----

Views, like stores, are just functions in the processing chain that transform
data in a particular way. In this case, view functions return vdom in the form
of JSX or React components.

Hyperscript
```````````

Plain JavaScript works so well in this pattern we even avoid JSX in favor of
the `hyperscript`_ wrapper around ``React.createElement``. The examples in this
post are using JSX because they're intended for a broad audience, but I
encourage you to try ``h()``. The syntax melts away after a few minutes of
usage and direct access to JavaScript is just *nice*.

.. _`hyperscript`: https://github.com/mlmorg/react-hyperscript

Controller Views
````````````````

We sometimes differentiate general-purpose stores that fetch or maintain data,
from stores that are tightly-coupled to a specific view and only format data
from other stores for easy consumption by that view. We call these "controller
views" or "view-stores" (to borrow from MVVM).

Stateful React Components
`````````````````````````

This Flux implementation is *pragmatic* and not pure. Sometimes React makes it
difficult to avoid using internal component state. If you must use stateful
components: use them sparingly, keep them shallow, have a good reason to hold
any state internally rather than in an external store, and only keep what you
must as internal state and still pass in the rest as props.

Whether to use a stateful component or a stateless component is the most
uncomfortable aspect of this pattern (as well as vanilla Flux and many of the
Flux variants as well). Anecdotally, it feels like Facebook used many nested
stateful components in the early days of React but has been easing off that
over the last year in favor of top-level controller-components and stateless
functional components. We try to avoid them as much as possible.

I am optimistic that this Flux implementation could be made to be `"fractal"`__
-- meaning smaller parts of the app have the same pieces and flow as the
greater app. It would require context-specific Dispatchers that read-from and
send-to *subsets* of the events coming from the main Dispatcher which would
allow them to have their own internal stores. The event tags we use at my work
are already hierarchical and namespaced (described in the next section), and
it's trivial to pass events to and from multiple Subjects. If I make any
headway toward this idea I will update this post.

.. __: https://twitter.com/andrestaltz/status/636178992316321792

Centralize side-effects
-----------------------

Everything within the data stream is just processing data. It's a
self-contained flow of data and actions. But there are inevitably side effects
in any app. We've already discussed two in the Dispatcher section above:
rendering to the DOM and logging.

It it useful to keep ``subscribe()`` calls to a minimum and keep those that you
must have in predictable places. This allows you to see all the side effects --
things that happen outside the data stream -- in one place.

We use a few `CompositeDisposable`_ instances in the app in order to deal with
these subscriptions as a single entity. One for global, app-wide side effects,
and one for each module (discussed below) that is aggressively subscribed-to
and then disposed at the right times.

.. _`CompositeDisposable`: https://github.com/Reactive-Extensions/RxJS/blob/master/doc/api/disposables/compositedisposable.md

There isn't much to it. We call these "tasks" because often times they
represent some "background" task. Really it's just an array of observables.
What they do when subscribed to is pretty open-ended.

.. code:: javascript

    var tasks = [
        Observable1,
        Observable2,
    ];

    var taskSubscriptions = new Rx.CompositeDisposable(...tasks);

Some of the things we use tasks for is running the cache maintenance routine on
a regular interval (described above in the xhr section), updating the browser
URL bar in response to route changes, switching CSS themes, starting the
auto-logout inactivity monitor, etc.

...And occasionally pushing actions from stores into the Dispatcher bypassing
views. This is still unidirectional data flow and compatible with Flux, but
this is usually a bad pattern that has all the hallmarks of programming with
gotos and bypasses all the benefit you get from Rx. Don't do this unless you
have to.

Modules
-------

Split your app into pieces, each with its own stores and views.

Routing
-------

Keeping with the heavy Flux theme, the Dispatcher is actually our source of
routing -- not the usual browser popstate/hashchange events. This allows the
app to function completely independently of the browser's URL bar. Instead
actions going through the Dispatcher are used to update the URL in the browser
as a side-effect. We use the excellent `route-parser`_ to reverse paths from
action data as it goes through the Dispatcher.

.. _`route-parser`: https://github.com/rcs/route-parser

It looks something like this:

.. code:: javascript

    var allRoutes = {...}; // An object of all registered routes.
    var currentView = new Rx.SerialDisposable();

    function dispatcherRouter({tag, data}) {
        var {obs$} = allRoutes[tag] || {};

        if (obs$) {
            currentView.setDisposable(obs$.subscribe());

    [...snip...]

This allows us to subscribe to one view at a time, as well as any tasks
(detailed above) associated with that view, and to aggressivly unsubscribe to
the previous view and tasks. This frees up unused resources, makes unused
stores effectively a noop, and triggers clearning the xhr cache (detailed
above).
