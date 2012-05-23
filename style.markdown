% Style
% 120 hour epic
% sax marathon

> Any customer can have a car painted any colour that he wants so long as it
> is black. <small>Henry Ford</small>

## Style is important

An important feature of the code you write is its readability. Code is meant
for computers to execute and people to read.

In this chapter, we go over the idiomatic Clojure style of writing programs:
indentation, whitespace, names, and other things that affect the format of the
program.

## Indentation

Clojure programs are indented with spaces (not tabs), and one indent is two
spaces.

### Function calls

Most forms in Clojure programs are function calls. The indentation of
parameters after the function name is as follows.

If you have multiple parameters, and they are too long or too many to put on
the same line, you can align them:

~~~ {.clojure}
(and (flush? hand)
     (straight? hand))
~~~

In some cases, you want to put the first parameter on its own line:

~~~ {.clojure}
(and
  (flush? hand)
  (straight? hand))
~~~

In this case the parameters are aligned, as well, and indented with either one
or two spaces. Vim indents the parameters with two spaces and Emacs with one.
Either style is fine.

### Literal maps and vectors

A literal vector's elements are aligned:

~~~ {.clojure}
["foo" "bar"
 42 :quux
 (+ 1 2)]
~~~

Same with maps:

~~~ {.clojure}
{:foo 42
 :bar "quux"}
~~~

Usually the key and value are on the same line, but if they need to be on
separate lines, they are aligned:

~~~ {.clojure}
{:foo
 42
 :bar
 "quux"}
~~~

As an example of these rules, here is a Leiningen project definition:

~~~ {.clojure}
(defproject blorg "0.1.0-SNAPSHOT"
  :dependencies [[org.clojure/clojure "1.4.0"]
                 [noir "1.3.0-beta7"]
                 [cssgen "0.3.0-alpha1"]
                 [cheshire "4.0.0"]]
  :profiles {:test
             {:dependencies [[clj-webdriver "0.6.0-alpha8"]
                             [midje "1.4.0"]]}
             :dev
             {:plugins [[lein-midje "2.0.0-SNAPSHOT"]]}}
  :main blorg.core)
~~~

`defproject` is not a builtin definition form, but it starts with `def`, so
its parameters are indented with two spaces.

### Definitions

Definitions are indented.

~~~ {.clojure}
(defn double [x]
  (+ x x))
~~~

If the parameters are on separate lines, they are aligned, like in `let`:

~~~ {.clojure}
(defn foo [a-really-long-parameter-name
           another-long-parameter-name]
  (body))
~~~

Definitions can have associated *documentation strings*:

~~~ {.clojure}
(defn foo
  "This is the documentation string for foo.
  It can span multiple lines."
  [parameters]
  (body))
~~~

The public functions of your API should have documentation strings.

<info>
The documentation string goes *before* the parameter list because a Clojure
definition can have multiple alternative implementations with their own
parameter lists. TODO: do we need to say this?
</info>

~~~ {.clojure}
(defn grandmother? [person grandmother]
  (or (= grandmother (mother (mother person)))
      (= grandmother (mother (father person)))))
~~~

`let` is indented like this

~~~ {.clojure}
(let [name "Lila Black"            ; ← name definitions here
      occupation "Magical Cyborg"] ; ← and here
  (str "I am " name ". "                   ; ← body here, indented two
       "Prepare to be " occupation "ed.")) ;   spaces more than the let
~~~

Here the aim is to make it visually clear where the name definitions are and
where the body is.

literal maps and vectors

~~~ {.clojure}
(if (= 3 4)
  "maths is broked"
  "all is fine")
~~~

## Names

Separate words in names with a hyphen `-`: `magical-ponies`, `book-authors`.

Add a `?` to the end of predicates (functions returning booleans):
`contains?`, `nil?`, `pony?`.

You can shadow a function with a variable:

~~~ {.clojure}
(defn do-something-to-a-seq [seq]
  (... seq))
~~~

Inside the function you can not call the `seq` function because you have a
parameter of the same name.

(But you can name the parameter `a-seq` instead, or something.)

## Those pesky parentheses

~~~ {.clojure}
(fofoaos
  (falidsjasd
    (falksjdlasd
      (fjldiasjd)))) ; ← look ma all on the same line
~~~

## Code style

Use `let` liberally to give intermediate results a name and create helper
functions.
