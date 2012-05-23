% blorg blorg blorg
% 120 hour epic
% sax marathon

## Synopsis

In which we follow along an implementation of a blog engine.

- State.
- Using libraries.
- Organizing code.
- The principle of "simple".

## Get the project

~~~
git clone https://github.com/iloveponies/blorg.git
~~~

The project for this chapter contains multiple *tags* that identify different
phases of the project as it was written. The chapter text will instruct you to
check out a certain tag to see the code as it was at a specific point in time.

To begin with, check out the tag `initial` to see the first version of the
code:

~~~
git checkout initial
~~~

## The idea

We want to write a blog engine, and not just any engine, but one written with
Clojure. We also want to use ready-made libraries for writing web applications
instead of inventing our own wheel (as satisfying it would be). Additionally,
we want to keep the implementation as simple as possible.

### Exploratory coding, or why we don't have tests yet

We don't really know what we're doing yet; we're mostly gluing together
existing libraries and defining a very simple model for blog posts. We decide
to not write unit tests, and instead implement a *prototype* instead. We are
prepared to throw away this code and reimplement a new version with tests.
Alternatively, we might use the prototype itself as the production version and
write tests for it after the fact.

## Initial implementation

Using the `initial` tag we can see our first initial implementation. First,
we should take a look at the project definition, which tells us what libraries
we are using:

~~~ {.clojure}
(defproject blorg "0.1.0-SNAPSHOT"
  :dependencies [[org.clojure/clojure "1.4.0"]
                 [noir "1.3.0-beta7"]])
~~~

This definition tells us that blorg requires Clojure version 1.4.0 and the
[noir] library version 1.3.0-beta7. TODO: why beta

### The first page

Our initial implementation resides in one file, `src/blorg/core.clj`. It
contains very little code, which we will now go over.

First, we start with a regular namespace declaration, which contains our `use`
and `require` declarations:

~~~ {.clojure}
(ns blorg.core
  (:use noir.core)
  (:require [noir.server :as server]
            [hiccup.page :as page]))
~~~

We use `noir.core`, which imports the function names defined in that namespace
into our own namespace. This means we can refer to functions in `noir.core`
with just their names, like `defpage`.

`require` loads just the namespace, which allows us to refer to functions
defined in `noir.server` with `server/function`.

~~~ {.clojure}

[noir]: http://webnoir.org
[hiccup]: https://github.com/weavejester/hiccup
