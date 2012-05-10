% Training day
% 120 hour epic
% sax marathon

## Synopsis

A whirlwind tour of the basics of Clojure, including:

- Using the REPL
- Prefix syntax
- Defining functions

## Interactive Clojure

To start an interactive Clojure session, type `lein2 repl` in the terminal.

It should look something like this:

```
nREPL server started on port 41612
Welcome to REPL-y!
Clojure 1.3.0
    Exit: Control+D or (exit) or (quit)
Commands: (help)
    Docs: (doc function-name-here)
          (find-doc "part-of-name-here")
  Source: (source function-name-here)
          (sourcery function-name-here)
 Javadoc: (javadoc java-object-or-class-here)
Examples from clojuredocs.org:
          (clojuredocs name-here)
          (clojuredocs "ns-here" "name-here")
nil
user=>
```

If you type `(+ 1 2)` and press the return key, you should see this:

~~~ {.clojure}
user=> (+ 1 2)
3
user=>
~~~

Clojure evaluated the expression `(+ 1 2)` and printed its value, `3`. If you
see something different, please let us know by raising your hand.

## Prefix Syntax

As you can see above, instead of writing `1 + 2` to calculate the sum of one
and two, we write `(+ 1 2)`. This syntax applies everywhere in Clojure. In
fact, Clojure has no operators at all. In languages such as Java or C,
arithmetic operations are usually written in the mathematical notation called
*infix form*. Clojure, on the other hand, uses *prefix form* for its syntax.
The next table shows what mathematical expressions look like in these two
syntaxes.

Java            Clojure
-------         -------
`2 + 3`         `(+ 2 3)`
`42 * 7`        `(* 42 7)`
`2 - 78 * 35`   `(- 2 (* 78 35))`
`1 + 2 + 3 + 4` `(+ 1 2 3 4)`

Let's input these definitions in our Clojure session to see how they work:

~~~ {.clojure}
user=> (+ 2 3)
5
user=> (* 42 7)
294
user=> (- 2 (* 78 35))
-2728
user=> (+ 1 2 3 4)
10
~~~

*Exercise:* Write the following expression in the Clojure prefix syntax: $(2 *
3) + 4$. Try evaluating it in the interactive session. The result should be
10.

The arithmetic operations above are, in fact, function calls. That is, `+` is
actually a function (called `+`), as are `*` and `-`. All function calls in
Clojure look the same: `(function-name argument-1 argument-2 ...)`. As an
example of a non-arithmetic function, let's take a look at getting a single
character from a string in Clojure and Java. In Clojure, we can use the `get`
function for this:

~~~ {.clojure}
(get "Clojure" 2) ;=> \o
~~~

The result is the character `o`, printed in Clojure's literal character
syntax. (That is, `\o` in Clojure code means the single character `o`. In
Java, you would write a literal character as `'o'`.)

In Java, we reorder things a bit: the first parameter goes *before* the method
name, and the parentheses are moved *after* the method name:

~~~{.java}
"Java".charAt(2); //=> v
~~~

In Clojure, the function name always goes first, and the parameters come after
it, including the object, if such is present. The Clojure syntax might take
some time to get used to, but becomes natural after you've written a few
Clojure programs.

## Notation

In our example code, we often want to show the result of an expression
when it is evaluated. Instead of showing what evaluating the expression in the
interactive session looks like:

~~~{.clojure}
user=> (+ 3 4)
7
~~~

We're going to use the convention of writing the expression and the result,
separated with `;=>`. For an example:

~~~{.clojure}
(+ 3 4) ;=> 7
~~~

Sometimes we will put the result on a new line:

~~~{.clojure}
(str 1337)
;=> "1337"
~~~

*Aside:* `str` is a function that turns its argument to a string. If given multiple
arguments, it concatenates the results:

~~~{.clojure}
(str "Over " 9000 "!") ;=> "Over 9000!"
~~~

When the resulting value is too long to display on one line, we will mark the
continuation lines with a leading `;` like this:

~~~ {.clojure}
(take 20 (cycle ["foo" "bar"]))
;=> ("foo" "bar" "foo" "bar" "foo" "bar" "foo" "bar" "foo" "bar"
;    "foo" "bar" "foo" "bar" "foo" "bar" "foo" "bar" "foo" "bar")
~~~

`;` starts a comment that lasts until the end of that line, like `//` in Java.
The `=>` inside the comment is an illustration of an arrow, meaning "evaluates
to". You can copy the examples above to the REPL and they will work without
modification:

~~~{.clojure}
user=> (+ 3 4)
7
user=> (+ 3 4) ;=> 7
7
user=> (+ 3 4) ; I am a comment
7
~~~

## Files and Namespaces

Code in Clojure projects is structured into separate files. Usually each file
corresponds to a namespace identified by the file's path. For an example, the
file `foo/bar/baz.clj` contains the namespace `foo.bar.baz`. This is slightly
different from Java, where directories correspond to namespaces (packages) and
files under a directory usually contain a single class in the given package.

Let's create the basic structure for a project to get a feeling for how
this works. As you read the description below, execute the same steps on your
own computer.

Suppose we start a project called `foobar`. First, we create the basic
directory structure with an example file:

~~~
. foobar
+-. example/
  +- hello.clj
~~~

Here `hello.clj` is under the directory `example`, which means it contains the
namespace `example.hello`:

~~~{.clojure}
(ns example.hello)

(println "O HAI!")
~~~

Namespaces are declared with `ns`.

Now, we go to the directory `foobar` in a terminal and start an interactive
session there:

~~~
$ cd foobar
$ lein2 repl
…
user=>
~~~

We can now load the `hello.clj` file into the session:

~~~ {.clojure}
user=> (use 'example.hello)
O HAI!    ; ← (println "O HAI!")
nil       ; ← result of use
~~~

This loaded the file `hello.clj` into the interactive session. Doing this, it
evaluated everything in the file, which is why we see the printed line. The
result of `use` itself is `nil`, a special value like Java's `null`.

<aside class="alert alert-error">

The `'` before the namespace name in a `use` is important. If you forget it,
you will get an error like this:

~~~ {.clojure}
user=> (use example.hello)
java.lang.ClassNotFoundException: example.hello (NO_SOURCE_FILE:1)
~~~

`'` is an alias for the  `quote` special form, which we will talk more about
later.

</aside>

## Functions

So far we've worked with expressions and simple names defined with `def`. For
structuring any kind of non-trivial programs, we will want to group code into
*functions*.

Functions are written in source files, and we have one ready, `hello.clj`, so
let's write the following function definition in that file. We'll write the
function `(hello who)`, which returns an English greeting for the user.

Functions are defined with `defn`:

~~~ {.clojure}
(defn hello [who]
  (str "Hello, " who "!"))
~~~

Write this function to the `hello.clj` file found in the `src` directory that
we created previously.

Let's take another look at that function, now with running commentary
alongside, to make sure we understand its parts.

~~~ {.clojure}
(defn                       ; Start a function definition:
  hello                     ; name
  [who]                     ; parameters inside brackets
  (str "Hello, " who "!"))  ; body
~~~

Here `hello` is the name of the function, `[who]` is the parameter list, and
the expression on the second line is the body of the function. The return
value of the function is the value of the last expression inside the function
body. In this case, it is the value of the `(str "Hello, " who "!")`
expression.

For comparison, our function looks like this in Java:

~~~ {.java}
String hello(String who) {
    return "Hello, " + who + "!";
}
~~~

Note that in Clojure, there is no `return` keyword; the return value of a
function is always the value of the last expression in the function body.

Now, let's try calling our function (assuming you have now added it to the
`hello.clj` file and saved the file):

~~~ {.clojure}
user=> (use 'example.hello :reload)
user=> (hello "Metropolia")
"Hello, Metropolia!"
~~~

First we import the `example.hello` namespace, and tell Clojure to *reimport*
it if it is already imported, so we actually see the new function definition.
We then call the function with the parameter `"Metropolia"`. Calling the
function evaluated its body with `who` bound to `"Metropolia"`. We can
imagine the evaluator doing something like the following:

~~~ {.clojure}
(hello "Metropolia")
;=> (str "Hello, " "Metropolia" "!")
;=> "Hello, Metropolia!"
~~~

We now know all the basics of structuring Clojure programs.

## We come gifting bears

We will now move to a Leiningen-based project structure instead of the one we
manually created above. It contains unit tests for the exercises that will
follow. No worries, though: you can use [Git] to get a ready-made structure we
have lovingly hand-crafted just for you:

~~~
$ git clone https://github.com/iloveponies/training-day.git
Cloning into 'training-day'…
…more output…
$ cd training-day
$ lein2 midje
TODO: failing test output
~~~

Our project uses the [Midje] testing library. Let's take a look at what kind
of tests the project contains. Open the file `test/training_day_test.clj`. The
first ten lines or so of the file look like this:

~~~ {.clojure}
(ns training-day-test
  (:use training-day
        midje.sweet))

(facts "square"
  (square 2) => 4
  (square 3) => 9)
~~~

You can ignore the namespace declaration (`(ns …)`) for now. Look at the
`facts` expression. It declares some facts of the `square` function. A
fact, in Midje, is an expression `expr => expected-value`, saying:
"Evaluating `expr` should return `expected-value`". Our two tests (or
facts) say, then, that `(square 2)` should return `4` and `(square 3)`
should return 9.

If you take a look at the file `src/training-day.clj`, you will see that we've
provided a stub for the `square` function:

~~~ {.clojure}
(defn square [n]
  ":(")
~~~

Our stub simply returns the string `":("` for all values of `n`. This will
obviously not pass the tests, which we should now verify.

## Running tests

Midje tests are run from the command line, from the root directory of the
project. In that directory, the command `lein2 midje` will run all the tests
(or, in other words, verify all the properties) in the project. (Tests are
usually put under the `test/` directory under the project root.)

Try running the tests now to see that our dummy stub of `square` indeed does
fail its tests:

~~~
$ lein2 midje
...Lots of information about fetched dependencies...
...
...and eventually:

FAIL "square" at (training_day_test.clj:6)
    Expected: 4
      Actual: ":("

FAIL "square" at (training_day_test.clj:7)
    Expected: 9
      Actual: ":("

...and lots more...
~~~

There are various other functions with properties, whose failures you also see
here, but the important output, for our purposes, are the failures with the
text `"square"` in them. They indicate that our stub function fails the tests
as expected, because the string `":("` is not `4` or `9`.

The first exercise, then, is to implement `square`.

After writing the implementation of `square` in `src/training_day.clj`, run
`lein2 midje` again to see if your implementation agrees with the facts
declared in our test file.

<section class="exercise alert alert-success">

*Exercise:* Write the function `square` that takes a number as a parameter and
multiplies it with itself.

~~~ {.clojure}
(square 2) ;=> 4
(square 3) ;=> 9
~~~

</section>

<section class="alert alert-error">
TODO: markdown-esikääntäjä tehtävänannoille
</section>

<section class="alert alert-error">
TODO: joku muukin tehtävä funktioista tähän tai kohta, esim useampi parametri
</section>

<section class="alert alert-error">
TODO: doc
</section>

<section class="alert alert-error">
TODO: lein-shit ja testien ajaminen
</section>
