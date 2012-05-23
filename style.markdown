% Style
% 120 hour epic
% sax marathon

> Any customer can have a car painted any colour that he wants so long as it
> is black. <small>Henry Ford</small>

An important feature of the code you write is its readability. Code is meant
for people to read and only secondarily for computers to execute.

In this chapter, we go over the idiomatic Clojure style of writing programs:
indentation, whitespace, names, and other things that affect the format of the
program.

## Indentation

Clojure programs are indented with spaces (not tabs), and one level of
indentation is two spaces.

There are three different syntax forms that have different indentation styles.

### Function calls

Most forms in Clojure programs are function calls. The parameters of function
calls can be indented in two ways.

If you have multiple parameters, and they are too long or too many to put on
the same line, you can align them:

~~~ {.clojure}
(and (flush? hand)
     (straight? hand))

(defn grandmother? [person grandmother]
  (or (= grandmother (mother (mother person)))
      (= grandmother (mother (father person)))))
~~~

In some cases, you want to put the first parameter on its own line:

~~~ {.clojure}
(and
  (flush? hand)
  (straight? hand))
~~~

In this case, the parameters are aligned and indented with either one or two
spaces. Vim indents the parameters with two spaces and Emacs with one. Either
style is fine.

### Literal maps and vectors

The elements of a literal vector are aligned:

~~~ {.clojure}
["foo" "bar"
 42 :quux
 (+ 1 2)]
~~~

Note that the elements on successive lines are not aligned to the opening `[`,
but to the first element.

Maps are written in similarly:

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

### Definitions

The body of a definition is indented with two spaces:

~~~ {.clojure}
(defn double [x]
  (+ x x))
~~~

If the parameters of a function definition are on separate lines, they are
aligned, like literal vectors:

~~~ {.clojure}
(defn foo [a-really-long-parameter-name
           another-long-parameter-name]
  (body))
~~~

If a definition has a *documentation string*, it is written on the next line
after the definition name, indented with two spaces:

~~~ {.clojure}
(defn foo
  "This is the documentation string for foo.
  It can span multiple lines."
  [parameters]
  (body))
~~~

In this case, the parameter vector is written on its own line and indented
with two spaces, like the body.

<info>
The documentation string goes *before* the parameter list because a Clojure
definition can have multiple alternative implementations with their own
parameter lists. TODO: do we need to say this?
</info>

`let` is indented very much like a function definition; the defined names are
indented and aligned like a vector literal and the body is indented with two
spaces:

~~~ {.clojure}
(let [name "Lila Black"            ; ← name definitions here
      occupation "Magical Cyborg"] ; ← and here
  (str "I am " name ". "                   ; ← body here, indented two
       "Prepare to be " occupation "ed.")) ;   spaces more than the let
~~~

Here the aim is to make it visually clear where the name definitions are and
where the body is, so the body is not aligned with the definitions.

As a somewhat special case, `if` is indented like definitions:

~~~ {.clojure}
(if (= 3 4)
  "maths is broked"
  "all is fine")
~~~

The conditional is usually on the same line as the `if`, and the clause bodies
are indented with two spaces.

## Names

Names in Clojure follow traditional Lisp style, which allows much more varied
names than languages with infix syntax.

If a name has many words, they are separated with a hyphen `-`:
`magical-ponies`, `book-authors`.

Add a `?` to the end of predicates (functions returning booleans):
`contains?`, `nil?`, `pony?`.

## Whitespace

Parentheses, brackets and curlies hug their contents:

~~~ {.clojure}
{:a 42, :b "foo"}
[1 2 3 4]
(foo bar)
~~~

## Those pesky parentheses

When closing an expression, put all the closing parentheses (and
brackets/curlies) next to each other:

~~~ {.clojure}
(fofoaos
  (falidsjasd
    (falksjdlasd
      (fjldiasjd)))) ; ← All hugging each other!
~~~

# Example

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


## Code style

Use `let` liberally to give intermediate results a name and create helper
functions.
