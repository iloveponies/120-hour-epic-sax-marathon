% Structured data
% 120 hour epic
% sax marathon

## Synopsis

In which we learn to work with structured data.

- Names
- Sequences
- Vectors
- Maps

## Let there be names

We often want to give a piece of data name, either because the act of naming
gives clarity to the code, or because we want to refer to the data many times.
As we have seen, global names are declared with `def`. Local names, on the
other hand, are declared with `let`.

As an example, let's define a function for calculating the length of a
triangle's hypotenuse, given the length of its two legs:

~~~ {.clojure}
(defn hypotenuse [x y]
  (let [xx (* x x)
        yy (* y y)]
    (Math/sqrt (+ xx yy))))
~~~

`let` introduces one or more names and a scope for them:

~~~ {.clojure}
(let [name1 value1
      name2 value2
      ...]
  (expression1)
  (expression2)
  ...)
~~~

The names introduced by `let` are visible in all the expressions after them,
under `let`. A name is not visible to code outside the body of the `let` it is
defined in.

TODO: Example

*Exercise:* The following function does a thing:

~~~ {.clojure}
(defn do-a-thing [x]
  (Math/pow (+ x x) (+ x x)))
~~~

Change the function `do-a-thing` so that it uses `let` to give a name to the
common expression `(+ x x)` in its body.

TODO: let is let\*

## Simple values

Now that we know how to give names to values, let's look at what kind of
values Clojure supports.

Scalar values are the regular, singular simple values like `42`, `"foo"` or
`true`. The following table describes some of them.

------------------------------------------------------------------------------
Type            Examples             Description
----            --------             -----------------------------------------
Numbers         `42`, `3/2`, `2.1`   Numbers include integers, fractions,
                                     and floats.

Strings         "foo"                Foo.

Characters      `\x`, `\y`, `\√`     A single characer is written with a
                                     preceding `\`.

Keywords        `:foo`, `:?`         How do you describe keywords?

Booleans        `true`, `false`      Boolean values.

------------------------------------------------------------------------------

## Vectors

Clojure has support for a rich set of collections.

A *vector* is a collection that can be indexed with integers, like an array in
other languages. It can contain values of different types.

~~~ {.clojure}
[1 2 3]                 ;=> [1 2 3]
[:foo 42 "bar" (+ 2 3)] ;=> [:foo 42 "bar" 5]
~~~

You can index a vector with `get`:

~~~ {.clojure}
(get ["a" "b" "c"] 1)  ;=> "b"
(get ["a" "b" "c"] 15) ;=> nil
(get ["x"] 0)          ;=> "x"
~~~

*Exercise:* Write the function `(spiff v)` that takes a vector and returns the
sum of the first and third elements of the vector. What happens when you pass
in a vector that is too short?

~~~ {.clojure}
(spiff  [1 2 3])       ;=> 4
(spiff  [1 2 3 4 5 6]) ;=> 4
(spiff  [1 2])         ;=> ?
(spiff  [])            ;=> ?
~~~

Vectors are immutable: once you have a vector, *you can not change it*. You
can, however, easily create new vectors based on a vector:

~~~ {.clojure}
(conj [1 2 3] 4)          ;=> [1 2 3 4]
(assoc [1 2 3 4] 2 "foo") ;=> [1 2 "foo" 4]
~~~

`conj` adds a value to a collection. Its behaviour depends on the type of
collection: with vectors, it adds the value to the end of the vector.

`assoc` associates a new value for the given key in the collection. A vector's
indexes are its keys. Above, we create a new vector based on the previous one,
with "foo" at index 2. The original vector doesn't change in either of these
operations.

~~~ {.clojure}
(let [original [1 2 3 4]
      new      (assoc original 2 "foo")]
  original)
;=> [1 2 3 4]
~~~

## Postmodernism

Another way of extracting values from a vector is by *destructuring* it:

~~~ {.clojure}
(let [[x y z] [1 2 3 4 5 6]]
  (str x y z))
;=> "123"
~~~

Here, instead of giving a name to the vector `[1 2 3 4 5 6]`, we indicate with
the brackets in `[x y z]` that we want to destructure the vector instead.
Inside the brackets, we give names to the first three elements of the vector.

`let` is not the only context destructuring works in. You can also destructure
function parameters directly. For an example, take the following function:

~~~ {.clojure}
(defn sum-pairs [first-pair second-pair]
  [(+ (first  first-pair) (first  second-pair))
   (+ (second first-pair) (second second-pair))])
~~~

The function takes two vectors and sums their first pairwise elements:

~~~ {.clojure}
(sum-pairs [42 5] [-42 -5])     ;=> [0 0]
(sum-pairs [64 256] [-51 -219]) ;=> [13 37]
~~~

`sum-pair` is not very pretty to look at. We can spiff it up by taking out the
elements of its parameter vectors by destructuring them:

~~~ {.clojure}
(defn sum-pairs [[x1 y1] [x2 y2]]
  [(+ x1 x2) (+ y1 y2)])
~~~

`sum-pairs` still takes two parameter vectors, but now it does not give names
to its parameters. Instead, it gives names to their first two elements by
destructuring the parameters.

TODO: `&`, nested destructuring, `:as`, `(let [[x] [1 2]])`

*Exercise:* Rewrite our earlier function `spiff` by destructuring its
parameters.

## Maps

Where a vector associates integers to values, a *map* is not restricted to
integer keys. You can use any kind of value as a key. A map is written with
curly brackets, `{}`.

~~~ {.clojure}
{"foo" 42, "bar" 666}
{"mehmeh" (+ 2 5)
 "rupatipor" "ropopo"}
~~~

A map is indexed with the `get` function:

~~~ {.clojure}
(let [ages {"Juhana" 3
            "Ilmari" 42
            "King of All Cosmos" -6}]
  (get ages "King of All Cosmos"))
;=> -6
~~~

In idiomatic Clojure programs, the keys of a map are often *keywords*.
Keywords are a convenient way of naming keys for values in associative
collections such as maps. They are written with a preceding `:`.

~~~ {.clojure}
(def my-book {:title "My little book of ponies"
              :description "Learn all about ponies!"})

(get my-book :title) ;=> "My little book of ponies"
~~~

Keywords are even more convenient than this. They work as functions that
access collections:

~~~ {.clojure}
(:description my-book) ;=>  "Learn all about ponies!"
~~~

When used as a function and given a collection, a keyword looks itself up in
the collection and returns the value associated with it.

`assoc` works with a map:

~~~ {.clojure}
(assoc my-book :price "NINE GIGAZILLION ERDÖS")
;=> {:title "My little book of ponies"
;    :description "Learn all about ponies!"
;    :price "NINE GIGAZILLION ERDÖS"}
~~~

The keys and values of a map can be of any data type, and one map can contain
any number of different data types as both keys and values.

TODO: Talk about destructuring maps at some point.

<section class="alert alert-success">

Let's define a map that represents a book:

~~~ {.clojure}
(def cities {:author "China Miéville" :title "The City and the City"})
~~~

Write the function `(title-length book)` that counts the length of the book's
title. Use `let` to extract the title.

~~~ {.clojure}
(title-length cities) ;=> 21
~~~

TODO: kirjakamaa: vektorillinen kirjoja ja niihin liittyviä apufunktioita,
paloittele Conania tänne sekaan.

</section>

## Sequences

Do we want to speak about sequences here?

## Lists

Should we talk about lists?

Lists are :

~~~ {.clojure}
(+ 1 2)
(get "Foobar" 3)
~~~

When a list is evaluated, the first element (the *head*) is resolved to a
function and called, with the other items given to the function as arguments.
