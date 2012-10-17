% Training day
% 120 hour epic
% sax marathon

## Synopsis

A whirlwind tour of the basics of Clojure, including:

- Using the REPL
- Prefix syntax
- Defining functions

## Interactive Clojure

### Light Table

Did you choose Light Table as your editor? Actually, you should test
it in any case. It's pretty awsome. Follow the installation
instructions found [here][LightTable] if you haven't already. In
Linux, you run the `launcher.jar` as you would run any .jar file and
then navigate to `localhost:8833` in Chrome (or Chromium). Select
Instarepl when confronted with the choice.

On the left side you have a box. Click under the last line of text,
press `Enter` to get some breathing space and type `(+ 1 2)`. The
answer should appear as the last line on the right hand side like this

~~~clojure
(+ 1 2) => 3
~~~

If something went sideways, please let us know by raising your hand.

### Good ol' repl

If you don't want to use Light Table, there is always the `lein repl`.
Issue that command in the terminal and a interactive Clojure session
starts. It should look like this:

~~~
me@my-computer:~$ lein repl
nREPL server started on port 50443
Welcome to REPL-y!
Clojure 1.4.0
    Exit: Control+D or (exit) or (quit)
Commands: (user/help)
    Docs: (doc function-name-here)
          (find-doc "part-of-name-here")
  Source: (source function-name-here)
          (user/sourcery function-name-here)
 Javadoc: (javadoc java-object-or-class-here)
Examples from clojuredocs.org: [clojuredocs or cdoc]
          (user/clojuredocs name-here)
          (user/clojuredocs "ns-here" "name-here")
user=>
~~~

If you type `(+ 1 2)` and press the return key, you should see this:

~~~ {.clojure}
user=> (+ 1 2)
3
user=>
~~~

Clojure evaluated the expression `(+ 1 2)` and printed its value, `3`. If you
see something different, please let us know by raising your hand.

## Notation

In our example code, we often want to show the result of an expression
when it is evaluated. Instead of showing what evaluating the
expression in the interactive session looks like:

~~~{.clojure}
user=> (+ 3 4)
7
~~~

We're going to use the convention of writing the expression and the
result, separated with `;=>`. Quite like how Light Table does it. For
an example:

~~~{.clojure}
(+ 3 4) ;=> 7
~~~

Sometimes we will put the result on a new line:

~~~{.clojure}
(str 1337)
;=> "1337"
~~~

<info>
`str` is a function that turns its argument to a string. If given multiple
arguments, it concatenates the results:

~~~{.clojure}
(str "Over " 9000 "!") ;=> "Over 9000!"
~~~
</info>

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

<exercise>
Write the following expression in the Clojure prefix syntax: $(2 * 3) + 4$.
Try evaluating it in the interactive session. The result should be 10.
</exercise>

<exercise>
Write the expression $3 + 4 + 5 + 6$ in Clojure syntax. Evaluate it.
</exercise>

The arithmetic operations have some special properties. Everyone of
the operations works with only one operand.

~~~ {.clojure}
(+ 1) ;=> 1
(* 2) ;=> 2
(- 3) ;=> -3
(/ 4) ;=> 1/4
~~~

This behavior might seem odd, but here is the catch. The arithmetic
operations above are, in fact, function calls. That is, `+` is
actually a function (called `+`), as are `*` and `-`. Don't believe
use? Write just `+` in the REPL. In Instarepl you see

~~~clojure
+ => fn
~~~

and in `lein repl`

~~~clojure
user=> +
#<core$_PLUS_ clojure.core$_PLUS_@2d21471c>
~~~

They are both telling you that `+` is just a function.

All function calls in Clojure look the same: `(function-name
argument-1 argument-2 ...)`. As an example of a non-arithmetic
function, let's take a look at getting a single character from a
string in Clojure and Java. In Clojure, we can use the `get` function
for this:

~~~ {.clojure}
(get "Clojure" 2) ;=> \o
~~~

The result is the character `o`, printed in Clojure's literal character
syntax. (That is, `\o` in Clojure code means the single character `o`. In
Java, you would write a literal character as `'o'`.)

In Java, we reorder things a bit: the first parameter goes *before* the method
name, and the parentheses are moved *after* the method name:

~~~{.java}
"Java".charAt(2); //=> 'v'
~~~

In Clojure, the function name always goes first, and the parameters come after
it, including the object, if such is present. The Clojure syntax might take
some time to get used to, but becomes natural after you've written a few
Clojure programs.

<exercise>
Write a Clojure expression that, using `get`, gets the first character in
the string `"abrakadabra"`.
</exercise>

## Functions

So far we've worked with expressions and called some existing
functions. For structuring any kind of non-trivial programs, we will
want to group code into our own *functions*.

Lets start writing a function `(hello who)`, which returns an English
greeting for the user. Functions are created with `fn`. Write the
following in you REPL and evaluate it.

~~~clojure
(fn [who] (str "Hello, " who "!"))
~~~

The REPL should tell you that it was a function. Instarepl just says

~~~clojure
(fn [who] (str "Hello, " who "!")) => fn
~~~

As usual, `lein repl` is a bit more verbose and states

~~~clojure
user=> (fn [who] (str "Hello, " who "!"))
#<user$eval326$fn__327 user$eval326$fn__327@4a2d09aa>
~~~

So what kind of a function did we actually get? Inside the square
brackets are the parameters of the function. This one only has a one
and we gave that a name `who`. Right after that comes comes an
expression, a function call in this case. The value of this expression
will become the return value of this function. In general, the return
value of a function will be the value of the last expression in the
function.

So we got a function. Lets call it!

~~~clojure
((fn [who] (str "Hello, " who "!")) "Jani") ;=> "Hello, Jani!"
~~~

That worked just like with `+` and the others. First comes the
function, then the arguments. In this case the function does not have
a name so we need to write the whole definiton. We also have only one
argument, `Jani`.

<exercise>
Call the following function with your name.

~~~clojure
(fn [name] (str "Welcome to Rivendell mr " name))
~~~

</exercise>

Now we know how to make a function, but we only got a glimpse of it
and then it was gone. We have to write the definition of the function
every time we want to call it. But we want something more permanent,
something that we can write once and call multiple times. The
functions created with `fn` are called *anonymous functions*. They are
named such because they have no name. To give a name to a function we
can use `def`. Let's give the greeter function a name right away.

~~~clojure
(def hello (fn [who] (str "Hello, " who "!")))
~~~

Don't forget to evaluate that one. Now we can call this function.
Write `(hello "beautiful")` in your REPL to get a instant compliment.
In the name of sex-equality evaluate also `(hello "handsome")`.

So what just happened? Well, `def` gives a name to a value. In the
previous case the value is what we get when we evaluate `(fn [who]
(str "Hello, " who "!"))`. And what do we get when we evaluate that? A
function. So we gave the name `hello` to a function that gives out
greetings.

<exercise>
Give a name `answer` to the answer to life the universe and
everything.

~~~clojure
aswer ;=> 42
~~~

</exercise>

Anonymous functions have their uses in functional programming. So it
is nice to know that we can create them with `fn`. But most of the
time we want to give the function a name right away. To make that a
bit easier, we have `defn`. Here is how to create *and* name the
previous function with `defn`. There is a running commentary
alongside, to make sure we understand its parts.

~~~ {.clojure}
(defn                                 ; Start a function definition:
  hello                               ; name
  "Gives out personalized greetings." ; a optional docstring
  [who]                               ; parameters inside brackets
  (str "Hello, " who "!"))            ; body
~~~

Here `hello` is the name of the function, `[who]` is the parameter
list, and the expression on the second line is the body of the
function. The return value of the function is the value of the last
expression inside the function body. In this case, it is the value of
the `(str "Hello, " who "!")` expression. We have also provided an
docstring that briefly tells what this function does. This is
optional, but like washing your hands after visiting the toilet,
highly recommended.

For comparison, our function looks like this in Java:

~~~ {.java}
/**
 * Gives out personalized greetings.
 */
String hello(String who) {
    return "Hello, " + who + "!";
}
~~~

Note that in Clojure, there is no `return` keyword. The return value
of a function is always the value of the last expression in the
function body.

<info>
Want to take a look at the docstring of some function? You can use the
`doc` function to do so. Unfortunately you need to do some tricks to
get your hands at this function. But don't worry, it's not difficult.

~~~ {.clojure}
user=> (use 'clojure.repl)
user=> (doc +)
-------------------------
clojure.core/+
([] [x] [x y] [x y & more])
  Returns the sum of nums. (+) returns 0. Does not auto-promote
  longs, will throw on overflow. See also: +'
nil
~~~

You can also see the docstring of our `hello` function. Evaluate the
following in your REPL.

~~~clojure
(use 'clojure.repl)
(doc hello)
~~~

The next section will tell you more about the function `use`.

</info>

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
me@my-computer:~$ mkdir foobar
me@my-computer:~$ cd foobar
me@my-computer:~/foobar$ mkdir example
me@my-computer:~/foobar$ cd example/
me@my-computer:~/foobar/example$ touch hello.clj
~~~

This will result in the following directory structure:

~~~
. foobar
+-. example/
  +- hello.clj
~~~

Here `hello.clj` is under the directory `example`, which means it
should contain the namespace `example.hello`:

~~~{.clojure}
(ns example.hello)

(println "O HAI!")
~~~

Namespaces are declared with `ns`. Write this in EVim and save the file.

We can now go back to the `foobar` directory and start an interactive Clojure
session in the project:

~~~
me@my-computer:~/foobar/example$ cd ..
me@my-computer:~/foobar$ lein repl
nREPL server started on port 39455
Welcome to REPL-y!
Clojure 1.4.0
    Exit: Control+D or (exit) or (quit)
Commands: (user/help)
    Docs: (doc function-name-here)
          (find-doc "part-of-name-here")
  Source: (source function-name-here)
          (user/sourcery function-name-here)
 Javadoc: (javadoc java-object-or-class-here)
Examples from clojuredocs.org: [clojuredocs or cdoc]
          (user/clojuredocs name-here)
          (user/clojuredocs "ns-here" "name-here")
nil
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

<alert>
The `'` before the namespace name in a `use` is important. If you forget it,
you will get an error like this:

~~~ {.clojure}
user=> (use example.hello)
java.lang.ClassNotFoundException: example.hello (NO_SOURCE_FILE:1)
~~~

`'` is an alias for the  `quote` special form, which we will talk more about
later.
</alert>

## We come gifting bears

> When in doubt, do exactly the opposite of CVS. <small>Linus Torvalds</small>

We will now move to a Leiningen-based project structure instead of the one we
manually created above. It contains unit tests for the exercises that will
follow. No worries, though: you can use [Git] to get a ready-made structure we
have lovingly hand-crafted just for you:

~~~
me@my-computer:~$ git clone https://github.com/iloveponies/training-day.git
Cloning into 'training-day'...
remote: Counting objects: 18, done.
remote: Compressing objects: 100% (10/10), done.
remote: Total 18 (delta 5), reused 17 (delta 4)
Unpacking objects: 100% (18/18), done.
~~~

You now have your own copy of the project that we will use for writing the
exercises in this chapter.

Let's run the unit tests first. This will output a *lot* of somewhat
superfluous information while Leiningen downloads the project dependencies, so
you will see more output printed than what is shown below. This output is
printed only once, so subsequent runs will not be so chatty.

~~~
me@my-computer:~$ cd training-day/
me@my-computer:~/training-day$ lein midje
~~~

Leiningen tells us it's downloading the whole internet:

~~~
Could not find metadata lein-midje:lein-midje:2.0.0-SNAPSHOT/maven-metadata.xml in central (http://repo1.maven.org/maven2)
Retrieving lein-midje/lein-midje/2.0.0-SNAPSHOT/maven-metadata.xml (1k)
    from http://clojars.org/repo/
Could not find metadata lein-midje:lein-midje:2.0.0-SNAPSHOT/maven-metadata.xml in stuart (http://stuartsierra.com/maven2)
Could not find artifact midje:midje:pom:1.4.0 in central (http://repo1.maven.org/maven2)
Retrieving midje/midje/1.4.0/midje-1.4.0.pom (5k)from http://clojars.org/repo/

…Skip…
~~~

And finally, the output we are interested in:

~~~
FAIL "square" at (training_day_test.clj:6)
    Expected: 4
      Actual: ":("

FAIL "square" at (training_day_test.clj:7)
    Expected: 9
      Actual: ":("

FAIL "average" at (training_day_test.clj:19)
    Expected: 3
      Actual: ":("

FAIL "average" at (training_day_test.clj:20)
    Expected: 3/2
      Actual: ":("
FAILURE: 9 facts were not confirmed.
me@my-computer:~/training-day$
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

The `facts` form declares some facts of the `square` function. A fact, in
Midje, is an expression `expr => expected-value`, saying "Evaluating `expr`
should return `expected-value`". Our two tests (or facts) say that `(square
2)` should return `4` and `(square 3)` should return 9.

If you take a look at the file `src/training-day.clj`, you will see that we've
provided a stub for the `square` function:

~~~ {.clojure}
(defn square [n]
  ":(")
~~~

Our stub simply returns the string `":("` for all values of `n`. This does not
pass the tests, which we saw above. The relevant output was:

~~~
FAIL "square" at (training_day_test.clj:6)
    Expected: 4
      Actual: ":("

FAIL "square" at (training_day_test.clj:7)
    Expected: 9
      Actual: ":("
~~~

The `FAIL` lines indicate that our stub function fails the tests as expected,
because the string `":("` is not `4` or `9`.

The first exercise, then, is to implement `square`.

After writing the implementation of `square` in `src/training_day.clj`, run
`lein midje` again to see if your implementation agrees with the facts
declared in our test file.

<exercise>
Write the function `(square x)` that takes a number as a parameter and
multiplies it with itself.

~~~ {.clojure}
(square 2) ;=> 4
(square 3) ;=> 9
~~~
</exercise>

<exercise>
Write the function `(average a b)`, which returns the average of its two
parameters:

~~~ {.clojure}
(average 2 4) ;=> 3
(average 1 2) ;=> 3/2
~~~
</exercise>


<info>
You can use `(doc function)` to see some documentation for `function`:

~~~{.clojure}
user=> (doc max)
-------------------------
clojure.core/max
([x] [x y] [x y & more])
  Returns the greatest of the nums.
nil
~~~

You can also use `(user/clojuredocs function)` to see some examples for
`function`

~~~{.clojure}
user=> (user/clojuredocs min)
========== vvv Examples ================
  user=> (min 1 2 3 4 5)  
  1
  user=> (min 5 4 3 2 1)
  1
  user=> (min 100)
  100
========== ^^^ Examples ================
1 example found for clojure.core/min
nil
~~~

</info>

[Proceed to the horse feast! →](I-am-a-horse-in-the-land-of-booleans.html)

[Midje]: https://github.com/marick/Midje
[Git]: http://git-scm.com
[LightTable]: http://app.kodowa.com/playground
