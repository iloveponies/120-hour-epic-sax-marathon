# Training day

## First lesson

TODO: Powershell, lein? blaa

### Synopsis

- Using the REPL
- Prefix syntax (+, -, /, \*)
- Editor
- Declaring functions
- `if` and truthiness
- Everything is an expression / has a value

### Interactive Clojure

To start an interactive Clojure session, type
```
lein repl
```
in the terminal.

It should look something like this:
TODO: tarkista et varmasti näyttää windozella samalta
```
REPL started; server listening on localhost port 3099
user=>
```

If you type
```{.clojure}
(+ 1 2)
```
and press the return key, you should see this:

```
user=> (+ 1 2)
3
user=>
```

Clojure evaluated the expression `(+ 1 2)` and printed its value, `3`. If you
see something different, please let us know by raising your hand.

### Prefix Syntax

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

```
user=> (def x (+  2 3))
#'user/x
user=> (def y (* 42 7))
#'user/y
user=> (def z (-  x y))
#'user/z
```

We can now use the names `x`, `y` and `z` in our session:

```
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

<section class="exercise">
Write the following expression in the Clojure prefix syntax:
<div class="math">
(2 * 3) + 4
</div>
Try evaluating it in the interactive session. The result should be 10.
</section>

### Notation

In our example code, we often want to show the result of an expression
when it is evaluated. Instead of showing what evaluating the expression in the
interactive session looks like:

```
user=> (+ 3 4)
7
```

we're going to use the convention of writing the expression and the result,
separated with `;=>`. For an example:

```
(+ 3 4) ;=> 7
```

Sometimes we will put the result on a new line:

```
(str 1337)
  ;=> "1337"
```

We use this idiom because it's short, and because `;` starts a comment line in
Clojure. The `=>` is an illustration of an arrow, meaning "this expression
evaluates *to* this result". You can copy these examples to the REPL and they
will work without modification:

```
user=> (+ 3 4)
7
user=> (+ 3 4) ;=> 7
7
user=> (+ 3 4) ; I am a comment
7
```

TODO: funktion määrittäminen
TODO: koodin kirjoittaminen tiedostoon
TODO: koodin lataaminen tiedostosta REPLiin
TODO: nimiavaruudet
TODO: lein-shit ja testien ajaminen

TODO?: lein projektit
