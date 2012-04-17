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

TODO: Esimerkki ja tehtävä
