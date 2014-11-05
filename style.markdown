% Style

> Any customer can have a car painted any colour that he wants so long as it
> is black. <small>Henry Ford</small>

An important feature of the code you write is its readability. Code is
meant for people to read and only secondarily for computers to
execute.

In this chapter, we go over the idiomatic Clojure style of writing
programs: indentation, whitespace, names, and other things that affect
the format of the program.

## Indentation

Clojure programs are indented with spaces (not tabs), and the level of
indentation depends on the form.

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

In this case, the parameters are aligned and indented with either one
or two spaces. Vim indents the parameters with two spaces and Emacs
with one. Either style is fine.

### Literal maps, vectors, sets and lists

The elements of a literal vector are aligned:

~~~ {.clojure}
["foo" "bar"
 42 :quux
 (+ 1 2)]
~~~

Note that the elements on successive lines are not aligned to the
opening `[`, but to the first element.

Maps, sets and lists are written in similarly:

~~~ {.clojure}
{:foo 42
 :bar "quux"}
 
'("foo" "bar"
  42 :quux)
~~~

In a map the key and value are usually on the same line, but if they
need to be on separate lines, they are aligned:

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

`let` is indented very much like a function definition. The defined
names are indented and aligned like a vector literal and the body is
indented with two spaces:

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

Names in Clojure follow traditional Lisp style, which allows much more
varied names than languages with infix syntax. No capital letters are
used.

If a name has many words, they are separated with a hyphen `-`:
`magical-ponies`, `book-authors`.

Add a `?` to the end of predicates (functions returning booleans):
`contains?`, `nil?`, `pony?`.

Function name should reflect the result value, not the computation
done: `radius` instead of `calculate-radius`, `dead-authors` instead
of `remove-living-authors`, `author-descriptions` instead of
`describe-authors`.

Functions that create objects of certain type have names of the form
`->object-type`: `->triangle`, `->employee`.

Functions that turn objects of one type to another type have names of
the form `from-type->to-type`: `authors->string`, `

## Whitespace and commas

Whitespace acts as a token separator in Clojure. That is, `(+12)` is
parsed as a call to a function named `+12`, `[123]` is a list
containing the number `123`, `{:a :b:c}` maps `:a` with `:b:c`
and `{:a :b:c 2}` is not a map literal, because it doesn't contain
an even number of forms (2 has no pair).

Commas are treated like whitespace, so `{:a :b,:c 2}`
is a correct literal, but for readability put one space between pairs
if they appear in one line: `{:a :b, :c 2}`.

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

## Example

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


## Idioms

If a function is only needed inside another function, define it with
`let` and `fn` inside the using function.

Use `let` liberally to give intermediate results a name. If an
expression appers in two places, give it a name with `let`. And even if it
doesn't, using let to name intermediate results makes code easier to read.

## That's All

Now it's time to apply these conventions in a bigger project.

[Move on to the world of poker →](p-p-p-pokerface.html)
