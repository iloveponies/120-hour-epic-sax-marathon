% Training day
% 120 hour epic
% sax marathon

## Synopsis

> In which we learn to butt.

- Using the REPL
- Prefix syntax (+, -, /, \*)
- Editor
- Declaring functions
- `if` and truthiness
- Everything is an expression / has a value

## Interactive Clojure

To start an interactive Clojure session, type `lein repl` in the terminal.

It should look something like this:

```
REPL started; server listening on localhost port 3099
user=>
```

<section class="alert alert-error">
TODO: tarkista et varmasti näyttää windozella samalta
</section>

If you type `(+ 1 2)` and press the return key, you should see this:

~~~ {.clojure}
user=> (+ 1 2)
3
user=>
~~~

Clojure evaluated the expression `(+ 1 2)` and printed its value, `3`. If you
see something different, please let us know by raising your hand.

## Prefix Syntax

> I used to be an adventurer like you, but then I took an arrow in the knee.

As you can see above, instead of writing `1 + 2` to calculate the sum of one
and two, we write `(+ 1 2)`. This syntax applies everywhere in Clojure. In
fact, Clojure has no operators at all. For an example, in languages such as
Java or C, arithmetic operations are usually written in the mathematical
notation called *infix form*:

Java           Clojure
-------        -------
`2 + 3`        `(+ 2 3)`
`42 * 7`       `(* 42 7)`
`2 - 78 * 35`  `(- 2 (* 78 35))`

<!-- `* -->

This syntax is called *prefix form*. All Clojure syntax is of this basic form.

Let's input these definitions in our Clojure session to see how they work:

~~~ {.clojure}
user=> (+ 2 3)
5
user=> (* 42 7)
294
user=> (- 2 (* 78 35))
-2728
~~~


<section class="exercise alert alert-success">
*Exercise:* Write the following expression in the Clojure prefix syntax: $(2 *
3) + 4$. Try evaluating it in the interactive session. The result should be
10.
</section>

As an example, let's take a look at getting a single character from a string
in Clojure and Java. In Clojure, we can use the `get` function for this:

~~~ {.clojure}
(get "Clojure" 2) ;=> \o
~~~

The result is the character `o`, printed in Clojure's literal character
syntax.

In Java, we reorder things a bit: the first parameter goes *before* the method
name, and the parentheses are moved *after* the method name:

~~~{.java}
"Java".charAt(2); //=> v
~~~

The Clojure prefix syntax might take some time to get used to, but becomes
natural after you've written a few programs in it.

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

<aside class="alert alert-info">
`str` is a function that turns its argument to a string. If given multiple
arguments, it concatenates the results:

~~~{.clojure}
(str "Over " 9000 "!") ;=> "Over 9000!"
~~~

</aside>

`;` starts a comment that lasts until the end of that line, like `//` in Java.
The `=>` inside the comment is an illustration of an arrow, meaning "evaluates
to". You can copy these examples to the REPL and they will work without
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

> In space no one can hear you quark.

Code in Clojure projects is structured into separate files. Usually each file
corresponds to a namespace identified by the file's path, so that the file
`foo/bar/baz.clj` contains the namespace `foo.bar.baz`. This is a bit
different from Java, where directories correspond to namespaces (packages) and
files under a directory usually contain a single class in the given package.
This difference makes sense given the FUNCTIONAL AWESOMENESS of Clojure.

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

Namespaces are declared with the `ns` form.

Now, we go to the directory `foobar` in a terminal and start an interactive
session there:

~~~
$ cd foobar
$ lein repl
REPL started; server listening on localhost port 63206
user=>
~~~

We can now load the `hello.clj` file into the session:

~~~{.clojure}
user=> (use 'example.hello)
O HAI!    ; ← (println "O HAI!")
nil       ; ← result of use
~~~

This loaded the file `hello.clj` into the interactive session. Doing this, it
evaluated everything in the file, which is why we see the printed line. The
result of `use` itself is `nil`, a special value like Java's `null`.

<aside class="alert alert-error">
The `'` before the namespace name is important. If you forget it, you will get
an error like this:

~~~{.clojure}
user=> (use example.hello)
java.lang.ClassNotFoundException: example.hello (NO_SOURCE_FILE:1)
~~~

`'` is an alias for the  `quote` special form, which we will talk more about
later.
</aside>

## Functions

So far we've worked with expressions and simple names defined with `def`.

Functions are defined with `defn`:

~~~{.clojure}
(defn hello [who]
  (str "Hello, " who "!"))
~~~

Let's look at that again, now with running commentary alongside:

~~~{.clojure}
(defn                       ; Start a function definition:
  hello                     ; name
  [who]                     ; parameters inside brackets
  (str "Hello, " who "!"))  ; body
~~~

Here `hello` is the name of the function, `[who]` is the parameter list, and
the expression on the second line is the body of the function.

Let's try calling our function:

~~~{.clojure}
(hello "Metropolia") ;=> "Hello, Metropolia!"
~~~

Calling the function evaluated its body with `who` bound to `"Metropolia"`.
We can imagine the evaluator doing something like this:

~~~{.clojure}
(hello "Metropolia")
;=> (str "Hello, " "Metropolia" "!")
;=> "Hello, Metropolia!"
~~~

<section class="alert alert-error">
TODO: tiedostoon kirjotetut funktiot tulee näkyviin usella
</section>

<section class="alert alert-error">
TODO: ohjeita vähän tähän: Jotain parempaa ohjastusta, et niinq mihin
tiedostoon tätä pitäs kirjottaa ja sillai
</section>

## We come gifting bears

We will now move to a Leiningen-based project structure instead of the one we
manually created above. No worries, though; you can use [Git] to get a
ready-made structure we have lovingly crafted by hand just for you:

~~~
$ git clone https://github.com/iloveponies/training-day.git
Cloning into 'training-day'…
…more output…
$ cd training-day
$ lein2 midje
~~~

<section class="exercise alert alert-success">

*Exercise:*
Write a function `square` that takes a number as a parameter and multiplies it with itself.

~~~{.clojure}
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

## If then else

> Any program is only as good as it is useful. <small>Linus Torvalds</small>

~~~{.clojure}
(if (my-father? darth-vader)
  (lose-hand me)
  (gain-hat me))
~~~

~~~{.clojure}
(defn sign [x]
  (if (< 0 x)
    "-"
    "+"))
~~~

~~~{.clojure}
user=> (use 'if-then-else :reload)
nil
user=> (sign -42)
"-"
user=> (sign 0)
"+"
~~~

<section class="exercise alert alert-success">

Write the function `(abs n)`, which returns the absolute value of `n`, i.e. if
$n < 0$, the value of `(abs n)` is $- n$, and otherwise $n$.

</section>

<section class="alert alert-error">
TODO: `mod`
</section>

<section class="exercise alert alert-success">

Write the function `(fizzbuzz n)` that returns

- `"fizz"` when `n` is divisible by 3,
- `"buzz"` when `n` is divisible by 5,
- but *only* `"gotcha!"` when `n` is divisible by 15.

~~~{.clojure}
(fizzbuzz 45) ;=> "gotcha!"
(fizzbuzz 48) ;=> "fizz"
(fizzbuzz 70) ;=> "buzz"
~~~

</section>

<section class="alert alert-error">
TODO: literate clojure
</section>

<section class="alert alert-error">
TODO?: lein projektit
</section>

[Git]: http://git-scm.com
