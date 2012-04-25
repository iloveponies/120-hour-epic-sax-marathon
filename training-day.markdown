% Training day
% 120 hour epic
% sax marathon

## Synopsis

- Using the REPL
- Prefix syntax (+, -, /, \*)
- Editor
- Declaring functions
- `if` and truthiness
- Everything is an expression / has a value

TODO: Powershell, lein? blaa

## Interactive Clojure

To start an interactive Clojure session, type `lein repl` in the terminal.

It should look something like this:

```
REPL started; server listening on localhost port 3099
user=>
```

TODO: tarkista et varmasti näyttää windozella samalta

If you type `(+ 1 2)` and press the return key, you should see this:

```{.clojure}
user=> (+ 1 2)
3
user=>
```

Clojure evaluated the expression `(+ 1 2)` and printed its value, `3`. If you
see something different, please let us know by raising your hand.

## Prefix Syntax

As you can see above, instead of writing `1 + 2` to calculate the sum of one
and two, we write `(+ 1 2)`. This syntax applies everywhere in Clojure. In
fact, Clojure has no operators at all. For an example, in languages such as
Java or C, arithmetic operations are usually written in the mathematical
notation called *infix form*:

```{.java}
int x =  2 + 3;
int y = 42 * 7;
int z =  x - y;
```

These operations are regular functions in Clojure instead:

```{.clojure}
(def x (+  2 3))
(def y (* 42 7))
(def z (-  x y))
```

This syntax is called *prefix form*. All Clojure syntax is of this basic form.

Let's input these definitions in our Clojure session to see how they work:

```{.clojure}
user=> (def x (+  2 3))
#'user/x
user=> (def y (* 42 7))
#'user/y
user=> (def z (-  x y))
#'user/z
```

We can now use the names `x`, `y` and `z` in our session:

```{.clojure}
user=> x
5
user=> z
-289
user=> (+ x z)
-284
```

```{.java}
int w = 5 + 6 * 3;
```

```{.clojure}
(def w (+ 5 (* 6 3)))
```

<section class="exercise alert alert-success">
*Exercise:* Write the following expression in the Clojure prefix syntax: $(2 *
3) + 4$. Try evaluating it in the interactive session. The result should be
10.
</section>

TODO: Talk about "REPL" (meaning of the term)

## Notation

In our example code, we often want to show the result of an expression
when it is evaluated. Instead of showing what evaluating the expression in the
interactive session looks like:

```{.clojure}
user=> (+ 3 4)
7
```

we're going to use the convention of writing the expression and the result,
separated with `;=>`. For an example:

```{.clojure}
(+ 3 4) ;=> 7
```

Sometimes we will put the result on a new line:

```{.clojure}
(str 1337)
;=> "1337"
```

<aside class="alert alert-info">
`str` is a function that turns its argument to a string. If given multiple
arguments, it concatenates the results:

```{.clojure}
(str "Over " 9000 "!") ;=> "Over 9000!"
```

</aside>

`;` starts a comment that lasts until the end of that line, like `//` in Java.
The `=>` inside the comment is an illustration of an arrow, meaning "evaluates
to". You can copy these examples to the REPL and they will work without
modification:

```{.clojure}
user=> (+ 3 4)
7
user=> (+ 3 4) ;=> 7
7
user=> (+ 3 4) ; I am a comment
7
```

## Files and Namespaces

Code in Clojure projects is structured into separate files. Usually each file
corresponds to a namespace identified by the file's path, so that the file
`foo/bar/baz.clj` contains the namespace `foo.bar.baz`. This is a bit
different from Java, where directories correspond to namespaces (packages) and
files under a directory usually contain a single class in the given package.
This difference makes sense given the FUNCTIONAL AWESOMENESS of Clojure.

Suppose we start a project called `foobar`. First, we create the basic
directory structure with an example file:

```
. foobar
+-. example/
  +- hello.clj
```

Here `hello.clj` is under the directory `example`, which means it contains the
namespace `example.hello`:

```{.clojure}
(ns example.hello)

(println "O HAI!")
```

Namespaces are declared with the `ns` form.

Now, we go to the directory `foobar` in a terminal and start an interactive
session there:

```
$ cd foobar
$ lein repl
REPL started; server listening on localhost port 63206
user=>
```

<aside class="alert alert-info">
*Note:* We use Leiningen to launch the interactive session for convenience
only. We could just as well have run `java -cp ".:/path/to/clojure.jar"
clojure.main` for the same effect. (On Windows, replace the `:` with `;`.)
Typing `lein repl` is just a bit nicer.  Additionally, Leiningen provides
commandline editing functions that running Clojure directly wouldn't. Try
typing <i class="icon-arrow-up"></i> in the interactive session launched by
Leiningen, then try it in the session launched with `java` directly.
</aside>

We can now load the `hello.clj` file into the session:

```{.clojure}
user=> (use 'example.hello)
O HAI!
nil
```

This loaded the file `hello.clj` into the interactive session. Doing this, it
evaluated everything in the file, which is why we see the printed line. The
result of `use` itself is `nil`, a special value like Java's `null`.

<aside class="alert alert-error">
The `'` before the namespace name is important. If you forget it, you will get
an error like this:

```{.clojure}
user=> (use example.hello)
java.lang.ClassNotFoundException: example.hello (NO_SOURCE_FILE:1)
```

`'` is an alias for the  `quote` special form, which we will talk more about
later.
</aside>

`use` is similar to Java's `import`. It takes a namespace and loads the file
corresponding to the namespace.

## Functions

So far we've worked with expressions and simple names defined with `def`.

Functions are defined with `defn`:

```{.clojure}
(defn hello [who]
  (str "Hello, " who "!"))
```

Here `hello` is the name of the function, `[who]` is the parameter list, and
the expression on the second line is the body of the function.

Let's try calling our function:

```{.clojure}
(hello "Metropolia") ;=> "Hello, Metropolia!"
```

Calling the function evaluated its body with `who` bound to "Metropolia".
We can imagine the evaluator doing something like this:

```{.clojure}
(hello "Metropolia")
;=> (str "Hello, " "Metropolia" "!")
;=> "Hello, Metropolia!"
```

TODO: tiedostoon kirjotetut funktiot tulee näkyviin usella

TODO: ohjeita vähän tähän: Jotain parempaa ohjastusta, et niinq mihin
tiedostoon tätä pitäs kirjottaa ja sillai

TODO: jatkossa tehtäväpohjat ja testit or wat?

<section class="exercise alert alert-success">

*Exercise:*
Write a function `square` that takes a number as a parameter and multiplies it with itself.

```{.clojure}
(square 2) ;=> 4
(square 3) ;=> 9
```

</section>

TODO: markdown-esikääntäjä tehtävänannoille

TODO: joku muukin tehtävä funktioista tähän tai kohta, esim useampi parametri

TODO: doc
TODO: lein-shit ja testien ajaminen

TODO: if?

TODO: tiedostopohjat ja testit about tästä eteenpäin?
TODO: git

TODO: literate clojure
TODO?: lein projektit

