% Training day
% 120 hour epic
% sax marathon

## Synopsis

A whirlwind tour of the basics of Clojure, including:

- Using the REPL
- Prefix syntax
- Defining functions

## Fork this

[https://github.com/iloveponies/training-day](https://github.com/iloveponies/training-day)

If you followed through the instructions in the last section of the
previous chapter, you already have this repository forked, cloned and
ready to go. If you missed the instructions,
[here](basic-tools.html#how-to-submit-answers-to-exercises) is a link.

## We come gifting bears

> When in doubt, do exactly the opposite of CVS. <small>Linus
> Torvalds</small>

You should now have a directory called `training-day`. This directory
contains a Leiningen project we have lovingly hand-crafted just for
you. It has unit tests for the exercises that will follow under the
directory `test`. More about these in a minute. Lets first focus on
the stuff inside `src`.

If you are using Light Table, now is a good time to Connect. If you
already are in Instarepl, open the menu from the lower right corner
and select Menu. This should get you to the starting choice.

Select Table and click Connect. Find the directory `training-day` and
hit `Enter`. After the loading, you should see `training-day` towards
the top right corner. Double click on the name, and the contents of
the file will be shown on the left.

If you are using some other editor, just open the file
`src/training_day.clj`.

Inside the file `src/training-day.clj` are stubs for all the exercises
that require coding. For example this stub:

~~~ {.clojure}
(defn square [n]
  ":(")
~~~

When you are solving the exercises, you are to modify these stubs and
run the tests to see if you got it right.

## Testing, testing, 1 2 3

Speaking of testing, let's run the unit tests now. This will output a
*lot* of somewhat superfluous information while Leiningen downloads
the project dependencies, so you will see more output printed than
what is shown below. This output is printed only once, so subsequent
runs will not be so chatty.

~~~
me@my-computer:~$ cd training-day/
me@my-computer:~/training-day$ lein midje
~~~

Leiningen tells us it's downloading the whole internet:

~~~
Could not find metadata lein-midje:lein-midje:2.0.0-SNAPSHOT/maven-metadata.xml in central (http://repo1.maven.org/maven2)
Retrieving lein-midje/lein-midje/2.0.0-SNAPSHOT/maven-metadata.xml (1k)
    from http://clojars.org/repo/
…Skip…
~~~

And finally, the output we are interested in:

~~~
FAIL "answer" at (training_day_test.clj:6)
    Expected: 42
      Actual: ":("

FAIL "square" at (training_day_test.clj:9)
    Expected: 4
      Actual: ":("

FAIL "square" at (training_day_test.clj:10)
    Expected: 9
      Actual: ":("

FAIL "average" at (training_day_test.clj:13)
    Expected: 3
      Actual: ":("

FAIL "average" at (training_day_test.clj:14)
    Expected: 3/2
      Actual: ":("
FAILURE: 5 facts were not confirmed.
~~~

This tells us that all the test failed. Which was expected, as you
haven't done any of the exercises yet.

Our project uses the [Midje] testing library. Let's take a look at
what kind of tests the project contains. In Light Table you can open
the tests by double clicking on the name `training-day-test`. Or you
can open the file `test/training_day_test.clj` in any editor. In the
file are blocks of code that look like this:

~~~ {.clojure}
(facts "square"
  (square 2) => 4
  (square 3) => 9)
~~~

The `facts` form declares some facts of the `square` function. A fact,
in Midje, is an expression `expr => expected-value`, saying
"Evaluating `expr` should return `expected-value`". Our two tests (or
facts) say that `(square 2)` should return `4` and `(square 3)` should
return 9.

Our stub for `square` simply returns the string `":("` for all values
of `n`. This does not pass the tests, which we saw above. The relevant
output was:

~~~
FAIL "square" at (training_day_test.clj:9)
    Expected: 4
      Actual: ":("

FAIL "square" at (training_day_test.clj:10)
    Expected: 9
      Actual: ":("
~~~

The `FAIL` lines indicate that our stub function fails the tests as
expected, because the string `":("` is not `4` or `9`.

Run `lein midje` often to see if your code is working or not. You can
also run `lein midje --lazytest` to start a loop that runs the tests
every time you make changes to the code.

## Interactive Clojure

One of the nice features of Clojure is the REPL. It is an interactive
session in which you can write code and see it executed immediately.
Here you have two choices. Light Table has a really nice REPL called
Instarepl, and Leiningen provides the classical REPL. We encourage you
to test out Instarepl even once. It's pretty awsome.

### Light Table

Follow the installation instructions found in the previous chapter if
you haven't already. In Linux, you run the file `LightTable` as you
would run any binary.

On the left side you have a menu. Select `command` and write `open
instarepl` into the box. Click on the presented choice to open the
Instarepl tab. Type `(+ 1 2)` into the text are. Small blue boxes near
the bottom of the window should indicate that something is happening.
Soon the answer to your question should appear right next to the code
you wrote.

If something went sideways, please let us know by raising your hand.

### Good ol' repl

If you don't want to use Light Table, there is always the `lein repl`.
Issue that command in the terminal and an interactive Clojure session
starts. It should look like this:

~~~
me@my-computer:~$ lein repl
nREPL server started on port 50443
Welcome to REPL-y!
Clojure 1.5.0
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

Clojure evaluated the expression `(+ 1 2)` and printed its value, `3`.
If you see something different, please let us know by raising your
hand.

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

`;` starts a comment that lasts until the end of that line, like `//`
in Java. The `=>` inside the comment is an illustration of an arrow,
meaning "evaluates to". You can copy the examples above to the REPL
and they will work without modification:

~~~{.clojure}
user=> (+ 3 4)
7
user=> (+ 3 4) ;=> 7
7
user=> (+ 3 4) ; I am a comment
7
~~~

## Prefix Syntax

As you can see above, instead of writing `1 + 2` to calculate the sum
of one and two, we write `(+ 1 2)`. This syntax applies everywhere in
Clojure. In fact, Clojure has no operators at all. In languages such
as Java or C, arithmetic operations are usually written in the
mathematical notation called *infix form*. Clojure, on the other hand,
uses *prefix form* for its syntax. The next table shows what
mathematical expressions look like in these two syntaxes.

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
Try evaluating it in the REPL. The result should be 10. You don't need to
return this one.
</exercise>

<exercise>
Write the expression $3 + 4 + 5 + 6$ in Clojure syntax. Evaluate it in
the REPL. You don't need to return this one.
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
Write a Clojure expression in the REPL that, using `get`, gets the first
character in the string `"abrakadabra"`. You don't need to return this one.
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
(fn [who] (str "Hello, " who "!")) fn
~~~

As usual, `lein repl` is a bit more verbose and states

~~~clojure
user=> (fn [who] (str "Hello, " who "!"))
#<user$eval326$fn__327 user$eval326$fn__327@4a2d09aa>
~~~

So what kind of a function did we actually get? Inside the square
brackets are the parameters of the function. This one only has a one
and we gave that a name `who`. Right after that comes comes an
expression, a call to a function `str` in this case. The value of this
expression will become the return value of this function. In general,
the return value of a function will be the value of the last
expression in the function.

So we got a function. Lets call it!

~~~clojure
((fn [who] (str "Hello, " who "!")) "Jani") ;=> "Hello, Jani!"
~~~

That worked just like with `+` and the others. First comes the
function, then the arguments. In this case the function does not have
a name so we need to write the whole definiton. We also have only one
argument, `"Jani"`.

<exercise>
Call the following function in the REPL with your name.

~~~clojure
(fn [name] (str "Welcome to Rivendell mr " name))
~~~

</exercise>

Now we know how to make a function, but we only got a glimpse of it
and then it was gone. We have to write the definition of the function
every time we want to call it. But we want something more permanent,
something that we can write once and call multiple times! The
functions created with `fn` are called *anonymous functions*. They are
called that because they have no name. To give a name to a function we
can use `def`. Let's give the greeter function a name right away.

~~~clojure
(def hello (fn [who] (str "Hello, " who "!")))
~~~

That definition is also an expression, so don't forget to evaluate it.
Now we can call this function. Write `(hello "beautiful")` in your
REPL to get a instant compliment. In the name of sex-equality evaluate
also `(hello "handsome")`.

So what just happened? Well, `def` gives a name to a value. In the
previous case the value is what we get when we evaluate `(fn [who]
(str "Hello, " who "!"))`. And what do we get when we evaluate that? A
function. So we gave the name `hello` to a function that gives out
greetings.

<exercise>
Give a name `answer` to the answer to life the universe and
everything. This is the first exercise in which you need to modify the
file `src/training_day.clj`. Remember to run the tests with `lein
midje`.

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

You can also use `(user/clojuredocs function)` to see some examples
for `function`. This should work for most of the built-in functions.

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

The next section will tell you more about the function `use`.

</info>

## Files and Namespaces

Code in Clojure projects is structured into namespaces defined in
files. Usually each file corresponds to a one namespace identified by
the file's path. For an example, the file `foo/bar/baz.clj` could
contain the namespace `foo.bar.baz`. This is slightly different from
Java, where directories correspond to namespaces (packages) and files
under a directory usually contain a single class in the given package.

The repository that you cloned at the end of the last chapter contains
an Leiningen project. Inside the `src` directory are all the code
files of the project. The file `training_day.clj` should begin with
the following.

~~~clojure
(ns training-day)
~~~

This is a namespace definition. It tells us that the code in this file
is in the namespace `training-day`. There are no dots in the namespace
name as there is no directories under `src`, just the lonely file
`training_day.clj`.

<alert>

See how the namespace is called `training-day`, but the file is
`training_day.clj`? This is intentional. If a namespace name has an
hyphen, the corresponding file name should have an underscore.

</alert>

We are at cross roads. Choose to right set of instructions based on
your REPL.

<info>

#### Light Table
 
From the menu, select `workspace` and the `Add folder`. Find the
directory `training-day` and open it. The project is now added to
Light Table. Open the Instarepl again.

#### lein repl

Navigate to the directory `training-day`, and run `lein repl`.

</section> <!-- BUG in pandoc. This is required to forcefully close
                the info section -->
</info>

Now as you have your REPLs open, write the following in it. Light
Table might ask you which client you want to use. Select training-day.

~~~clojure
(use 'training-day)
hai
~~~

Were you greeted in all CAPS? If not, please raise your hand.

What `use` did was that it looked inside the namespace `training-day`
and brought with it all the names defined in that namespace. The name
`hai` was one of them.

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

## Time to submit

Here are two exercises more to keep your fingers warm.

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

Now would be the time to submit your solutions to be graded. Run `lein
midje` to see if all the tests pass. If the do, you should see the
following:

~~~sh
me@my-computer:~/training-day$ lein midje
All claimed facts (5) have been confirmed.
~~~

Don't worry if you haven't figured out all the exercises. You can
still submit those that you have successfully made. Here is how to do
it.

1. Create a commit of your changes by running

    ~~~sh
    git commit -a -m "message here"
    ~~~

2. Update your fork in Github by pushing the changes. This will ask
   for your Github login.
    
    ~~~sh
    git push
    ~~~
       
3. Go to the Github pages of your fork of the repository
   `training-day`. Click on the `Pull request` button. You can ask
   question on the comment field, and we try to answer them **if**
   time permits. When you are ready, click `Send pull request`.
   
4. A comment containing the points that you got will be posted on the pull
   request. Then the pull request is closed.
   
If you didn't submit the solutions all at once, or some of the
submited ones were incorrect, you can re-submit as many times as you
need to. Just fix the code and follow the steps again. Be sure to
create a **new** pull request.

[Proceed to the horse feast! →](I-am-a-horse-in-the-land-of-booleans.html)

[Midje]: https://github.com/marick/Midje
[Git]: http://git-scm.com
