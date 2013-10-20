% I am a horse in the land of booleans
% 120 hour epic
% sax marathon

> Any program is only as good as it is useful. <small>Linus Torvalds</small>

## Synopsis

- `if` and truthiness
- everything is an expression / has a value

## Fork this

[https://github.com/iloveponies/i-am-a-horse-in-the-land-of-booleans](https://github.com/iloveponies/i-am-a-horse-in-the-land-of-booleans)

[Here](basic-tools.html#how-to-submit-answers-to-exercises) are the
instructions if you need them. Be sure to fork the repository behind
the link above.

## If then else

Any non-trivial program needs conditionals. Clojure's `if` looks like the
following:

~~~ {.clojure}
(if (my-father? darth-vader)  ; Conditional
  (lose-hand me)              ; If true
  (gain-hat me))              ; If false
~~~

`if` (usually) takes three parameters: the conditional clause, the *then*
body and the *else* body. If the first parameter - the conditional clause - is
true, the *then* body is evaluated. Otherwise, the *else* body is evaluated.

Clojure has two boolean values: `true` and `false`. However, all values can be
used in a boolean context like `if`. Everything except `nil` and `false` acts
as `true`. For example, all of the following are valid Clojure:

~~~ {.clojure}
(if "foo" "truthy" "falsey") ;=> "truthy"
(if 0     "truthy" "falsey") ;=> "truthy"
(if []    "truthy" "falsey") ;=> "truthy"
(if false "truthy" "falsey") ;=> "falsey"
(if nil   "truthy" "falsey") ;=> "falsey"
~~~

`nil` is Clojure's `null` value. We'll talk about it later.

To make it easier to talk about values in boolean context, we define the
following terminology:

- If a value is considered true in boolean context, we call it *truthy*.

- If a value is considered false, we call it *falsey*.

Any value can be turned into `true` or `false` with the `boolean` function:

~~~ {.clojure}
(boolean "foo")   ;=> true
(boolean nil)     ;=> false
~~~

<exercise>
Implement `(boolean x)`, which works like the built-in `boolean`
function: for `nil` and `false`, it returns `false`, and for all other
values it returns `true`. You can use `if` in its implementation, but
not the build-in `boolean`.

~~~{.clojure}
(boolean "foo") ;=> true
(boolean nil) ;=> false
(boolean (+ 2 3)) ;=> true
(boolean true) ;=> true
(boolean false) ;=> false
~~~
</exercise>

## Comparing values

Values can be compared for equality with `=`:

~~~ {.clojure}
(= "foo" "foo")    ;=> true
(= "foo" "bar")    ;=> false
~~~

Numerical values should be compared with `==`:

~~~ {.clojure}
(== 42  42) ;=> true
(== 5.0  5) ;=> true
(=  5.0  5) ;=> false !
~~~

Note the difference between `=` and `==`: `==` disregards the actual
type of the numeric value, whereas `=` requires that the numbers are
of the same type.

Less-than, greater-than and other such comparisons can be done with
the regular `<`, `>`, `<=` and `>=` operators:

~~~ {.clojure}
(< 1 2)   ;=> true
(> 1 2)   ;=> false
(<= 52 2) ;=> false
~~~

## Comparing many values

All the comparison functions above take an arbitrary amount of
arguments. For an example, to compare if three variables are equal,
one can give them to `=`:

~~~ {.clojure}
(= x y z) ;=> true if and only if x = y = z
~~~

The other comparison operators work similarly. You can easily check if
given variables are in ascending order:

~~~ {.clojure}
(< x y z q) ;=> true if and only if x < y < z < q
~~~

<exercise>
Write the function `(teen? age)`, which returns truthy if `age` is at least 13
and at most 19. Use only one comparison operator and give it three arguments.

~~~ {.clojure}
(teen? 12) ;=> false
(teen? 13) ;=> true
(teen? 15) ;=> true
(teen? 19) ;=> true
(teen? 20) ;=> false
(teen? 27) ;=> false
~~~
</exercise>

## Everything has a value

In functional programming, and specifically in Clojure, everything is an
expression. This is a way of saying that everything has a usable value.
Concretely, `if` has a return value; the value is the value of the evaluated
body (either the *then* or the *else* body).

As an example, let's define the function `(sign x)`, which returns the string
`"-"` if `x` is negative and otherwise `"+"`. The function looks like the
following:

~~~ {.clojure}
(defn sign [x]
  (if (< x 0)
    "-"
    "+"))
~~~

The function definition has one expression, which is an `if` expression. The
value of the function is the value of the `if` expression, because it is the
last expression in the function body. The value of the `if` expression is
either `"-"` or `"+"`, depending on the value of the parameter `x`.

You can paste the function into the REPL and try calling it with various
values of `x`:

~~~ {.clojure}
(sign  2) ;=> "+"
(sign -2) ;=> "-"
(sign  0) ;=> "+"
~~~

There is no need for a `return` clause -- there is no such keyword in Clojure
-- because the return value of a function is always the value of the last
expression in the body of the function.

<alert>
`if` does *not* have a return value in a language like Java. In other words,
it is not an expression, but a statement. Because everything in Clojure is an
expression, there is no equivalent construct to Java's `if` in it.

For illustration, you could use Java's `if` to implement `sign`:

~~~ {.java}
String sign(int x) {
    if (x < 0)
        return "-";
    else
        return "+";
}
~~~

Note that you need to use the `return` keyword to indicate when to return from
the method. Compare this to Clojure, where the last expression's value will be
the function's return value. Because Java's `if` does not return a value, you
can not say:

~~~ {.java}
return if (x < 0) "-" else "+"; // Illegal Java!
~~~
</alert>

## Conditional evaluation

In any case, *only* the appropriate expression is evaluated. So the following
is not an error:

~~~ {.clojure}
(if true
  42
  (/ 1 0))
~~~

If evaluated, `(/ 1 0)` would throw an `ArithmeticException` due to the
division by zero. However, the `if` expression does not evaluate the division
at all, because the conditional clause is true and only the *then* body, `42`,
is evaluated.

<exercise>
Write the function `(abs n)`, which returns the absolute value of `n`, i.e. if
$n < 0$, the value of `(abs n)` is $- n$, and otherwise $n$.

~~~ {.clojure}
(abs -2) ;=> 2
(abs 42) ;=> 42
~~~
</exercise>

<exercise>
Write the function `(divides? divisor n)`, which returns `true` if
`divisor` divides `n` and `false` otherwise.

`(mod num div)` returns `0` if `div` divides `num` exactly:

~~~ {.clojure}
(mod 10 5) ;=> 0
(mod 3 2)  ;=> 1
~~~

~~~ {.clojure}
(divides? 2 4) ;=> true
(divides? 4 2) ;=> false
(divides? 5 10) ;=> true
(divides? 2 5) ;=> false
~~~
</exercise>

## Conditioning

When checking for multiple conditions, you can use multiple `if` clauses:

~~~ {.clojure}
(if condition1
  true1
  (if condition2
    true2
    (if condition3
      true3
      ...)))
~~~

This is similar to `if`/`else if` in languages like Java. However, the nested
`if` clauses are awkward. We can rewrite the nested `if` clauses with the
`cond` builtin.

The general form of `cond` is:

~~~ {.clojure}
(cond
  condition1 true1
  condition2 true2
  condition3 true3
  ...)
~~~

Like with `if`, you can have an else branch in the end. The condition for the else branch is `:else`.

~~~ {.clojure}
(defn super-sign [number]
  (cond
    (neg? number) "negative"
    (pos? number) "positive"
    :else         "zero"))

(super-sign 13) ;=> "positive"
(super-sign 0)  ;=> "zero"
(super-sign -5) ;=> "negative"
~~~

<exercise>
Write the function `(fizzbuzz n)` that returns

- `"fizz"` when `n` is divisible by 3,
- `"buzz"` when `n` is divisible by 5,
- `"gotcha!"` when `n` is divisible by 15, and
- the empty string `""` otherwise.

Use the `divides?` function from the previous exercise.

~~~ {.clojure}
(fizzbuzz 2)  ;=> ""
(fizzbuzz 45) ;=> "gotcha!"
(fizzbuzz 48) ;=> "fizz"
(fizzbuzz 70) ;=> "buzz"
~~~
</exercise>

<exercise>
Write a function `(generic-doublificate x)` that takes one argument and

- doubles it if it is a number,
- returns nil if it is an empty collection,
- if it is a list or a vector, returns two times the length of it
- returns true otherwise.

You can use the following functions:

- `(number? n)` returns `true` if `n` is a number.
- `(empty? coll)` returns `true` if `coll` is empty.
- `(list? coll)` and `(vector? coll)` test if `coll` is a list or a vector.
- `(count coll)` returns the length of a list or a vector.

~~~ {.clojure}
(generic-doublificate 1)        ;=> 2
(generic-doublificate [1 2])    ;=> 4
(generic-doublificate '(65 21)) ;=> 4
(generic-doublificate {})       ;=> nil
(generic-doublificate [])       ;=> nil
(generic-doublificate {:a 1})   ;=> true
~~~
</exercise>

## Boolean Functions

The common boolean functions in Clojure are `and`, `or` and `not`. These
roughly match the `&&`, `||` and `!` operators of languages like Java.

~~~ {.clojure}
(and true true)   ;=> true
(and true false)  ;=> false

(or  true false)  ;=> true
(or  false false) ;=> false

(not true)        ;=> false
(not false)       ;=> true
~~~

`and` and `or` take an arbitrary amount of arguments:

~~~ {.clojure}
(and true)                      ;=> true
(and true true true)            ;=> true
(and true true true true false) ;=> false
(and)                           ;=> true

(or false false false false true) ;=> true
(or false false false)            ;=> false
(or)                              ;=> nil
~~~

In addition to booleans, `and`, `or` and `not` accept non-boolean values as
arguments as well. (Remember that `false` and `nil` are falsey and everything
else is truthy.)

By the way, if you have a lot of long parameters to `and`, or any
function for that matter, indent them like this:

~~~clojure
(and very-long-boolean-holding-parameter
     another-one-that-is-a-friend-of-the-previous
     the-third-guy)
~~~

`and` returns truthy if all of its arguments are truthy:

~~~ {.clojure}
(and "foo" "bar")   ;=> "bar"
(and "foo"  false)  ;=> false
(and  10    nil)    ;=> nil
~~~

`or` returns truthy if any of its arguments is truthy:

~~~ {.clojure}
(or  "foo"  false)  ;=> "foo"
(or   42    true)   ;=> 42
~~~

`not` returns `true` if its argument is falsey and `false` if its argument is
truthy:

~~~ {.clojure}
(not "foo")         ;=> false
(not nil)           ;=> true
(not [])            ;=> false
~~~

This behaviour might look surprising, but it is consistent. What's happening
is that if all the arguments to `and` are truthy, it returns the value of the
last argument. Otherwise, it returns the value of the first falsey argument.
Conversely, `or` returns either the first truthy value or the last falsey
value.

While it might seem odd that boolean functions return non-boolean
values, remember that all values in Clojure in fact act as boolean
values. This behaviour is useful in many situations. For an example,
it allows you to provide default values for variables when taking
input:

~~~ {.clojure}
(def server-port (or user-input 80))
~~~

Note that this can only be used in situations where the input may not take the
values `false` or `nil`.

<exercise>
Write the function `(not-teen? age)`, which returns `true` when teen? returns
`false` and `false` otherwise.

~~~ {.clojure}
(not-teen? 13) ;=> false
(not-teen? 25) ;=> true
(not-teen? 12) ;=> true
(not-teen? 19) ;=> false
(not-teen? 20) ;=> true
~~~
</exercise>

<exercise>
Write the function `(leap-year? year)`, which returns `true` if `year` is a
leap year, otherwise `false`. A year is a leap year if it is divisible by 4, except if it is
divisible by 100, in which case it still is a leap year if it is divisible by
400.

See [Wikipedia](http://en.wikipedia.org/wiki/Leap_year#Algorithm) for a simple
pseudocode solution.

~~~{.clojure}
(leap-year? 100) ;=> false
(leap-year? 200) ;=> false
(leap-year? 400) ;=> true
(leap-year? 12)  ;=> true
(leap-year? 20)  ;=> true
(leap-year? 15)  ;=> false
~~~
</exercise>


[Proceed to structuration! →](structured-data.html)

[Git]: http://git-scm.com
[Midje]: https://github.com/marick/Midje
