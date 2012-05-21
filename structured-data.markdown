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
As we have seen, package global names are declared with `def`. A function or
value that is needed only inside one function can be given a *local name* with
`let`.

As an example, let's define a function for calculating the length of a
triangle's hypotenuse, given the length of its two legs:

~~~ {.clojure}
(defn hypotenuse [x y]
  (let [xx (* x x)
        yy (* y y)]
    (Math/sqrt (+ xx yy))))
~~~

Here we give the expressions `(* x x)` and `(* y y)` the local names `xx` and
`yy`, respectively. They are visible only inside `hypotenuse`.

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

~~~ {.clojure}
user=> (let [x 42]
         (+ x x))
;=> 84
user=> x
CompilerException java.lang.RuntimeException:
Unable to resolve symbol: x in this context, compiling:(NO_SOURCE_PATH:0) 
~~~

<exercise>
The following function does a thing:

~~~ {.clojure}
(defn do-a-thing [x]
  (Math/pow (+ x x) (+ x x)))
~~~

Change the function `do-a-thing` so that it uses `let` to give a name to the
common expression `(+ x x)` in its body.
</exercise>

The names declared in a `let` expression can refer to previous names in the
same expression:

~~~ {.clojure}
(let [a 42
      b (+ a 8)]
  [a b])
;=> [42 50]
~~~

In the example above, `b` can refer to `a` because `a` is declared before it.
On the other hand, `a` can not refer to b:

~~~ {.clojure}
(let [a (+ b 42)
      b 8]
  [a b])
; CompilerException java.lang.RuntimeException: Unable to resolve symbol:
; b in this context, compiling:(NO_SOURCE_PATH:1) 
~~~

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

Strings         `"foo"`              Text values.

Characters      `\x`, `\y`, `\√`     A single characer is written with a
                                     preceding `\`.

Keywords        `:foo`, `:?`         Values often used as map keys.

Booleans        `true`, `false`      Boolean values.

------------------------------------------------------------------------------

## Vectors

Collections are the other kind of data structure, in addition to scalars, that
are crucial to programming. Clojure has support for a rich set of collection
data structures. We'll go over the most important structures in this chapter.

A *vector* is a collection that can be indexed with integers, like an array in
other languages. It can contain values of different types.

~~~ {.clojure}
[1 2 3]                 ;=> [1 2 3]
[:foo 42 "bar" (+ 2 3)] ;=> [:foo 42 "bar" 5]
~~~

A vector is written with surrounding brackets, `[]`, and the elements are
written inside, separated by whitespace and optionally commas (`,`).

Vectors are indexed with the `get` function:

~~~ {.clojure}
(get ["a" "b" "c"] 1)  ;=> "b"
(get ["a" "b" "c"] 15) ;=> nil
(get ["x"] 0)          ;=> "x"
~~~

Trying to index a vector beyond its size does *not* throw an exception.
The special value `nil` is returned, instead.

<exercise>
Write the function `(spiff v)` that takes a vector and returns the sum of the
first and third elements of the vector. What happens when you pass in a vector
that is too short?

~~~ {.clojure}
(spiff [1 2 3])       ;=> 4
(spiff [1 2 3 4 5 6]) ;=> 4
(spiff [1 2])         ;=> ?
(spiff [])            ;=> ?
~~~
</exercise>

### Basic vector operations

Vectors are immutable: once you have a vector, *you can not change it*. You
can, however, easily create new vectors based on a vector:

~~~ {.clojure}
(conj [1 2 3] 4)          ;=> [1 2 3 4]
(assoc [1 2 3 4] 2 "foo") ;=> [1 2 "foo" 4]
~~~

`conj` adds a value to a collection. Its behaviour depends on the type of
collection: with vectors, it adds the value to the end of the vector. To be
exact, `conj` does *not* change the given vector. Instead, it returns a new
vector, based on the given vector, with the new element appended to this new
vector.

`assoc` associates a new value for the given key in the collection. A vector's
indexes are its keys. Above, we create a new vector based on the previous one,
with `"foo"` at index `2`. The original vector doesn't change in either of
these operations:

~~~ {.clojure}
(let [original [1 2 3 4]
      new      (assoc original 2 "foo")]
  original)
;=> [1 2 3 4]
~~~

Finally, `count` returns the size of a collection:

~~~ {.clojure}
(count [1 2 3 4]) ;=> 4
(count [])        ;=> 0
~~~

### Vectors: A Postmodern Deconstruction

Another way of extracting values from a vector is by *destructuring* it:

~~~ {.clojure}
(let [[x y z] [1 2 3 4 5 6]]
  (str x y z))
;=> "123"
~~~

Here, instead of giving a name to the vector `[1 2 3 4 5 6]`, we indicate with
the brackets in `[x y z]` that we want to destructure the vector instead.
Inside the brackets, we give names to the first three elements of the vector.
`x` will be given the value of the first element, `1`; `b` will be `2` and `c`
will be `3`. The concatenation of these values that `str` returns is `"123"`.

You can destructure function parameters directly. For an example, take the
following function:

~~~ {.clojure}
(defn sum-pairs [first-pair second-pair]
  [(+ (first  first-pair) (first  second-pair))
   (+ (second first-pair) (second second-pair))])
~~~

The function takes two vectors and sums their first pairwise elements:

~~~ {.clojure}
(sum-pairs [42 5]   [-42 -5])   ;=> [0 0]
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
destructuring the parameters. We could have also destructured the parameters
with a `let`.

<exercise>
Rewrite our earlier function `spiff` by destructuring its
parameters. Call this new function `spiff-destructuring`.
</exercise>

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
(def book {:title "The City and the City"
           :author {:name "China Miéville", :birth-year 1972}})

(get book :title) ;=> "The City and the City"
~~~

Keywords are even more convenient than this. They work as functions that
access collections:

~~~ {.clojure}
(:title book) ;=> "The City and the City"
~~~

When used as a function and given a collection, a keyword looks itself up in
the collection and returns the value associated with it.

`assoc` works with a map:

~~~ {.clojure}
(assoc book :awards ["Hugo", "World Fantasy Award", "Arthur C. Clarke Award", "British Science Fiction Award"])
;=> {:author {:birth-year 1972, :name "China Miéville"}
;    :awards ["Hugo" "World Fantasy Award" "Arthur C. Clarke Award" "British Science Fiction Award"]
;    :title "The City and the City"}
~~~

The keys and values of a map can be of any data type, and one map can contain
any number of different data types as both keys and values.

`count` returns the size of a map, which is determined by how many keys it
has:

~~~ {.clojure}
(count {:a 42, :b "foo", :c 1337}) ;=> 3
(count {})                         ;=> 0
~~~

Let's define a couple of books like this:

~~~ {.clojure}
(def cities {:title "The City and the City"
             :author {:name "China Miéville", :birth-year 1972}})
(def wild-seed {:title "Wild Seed",
                :author {:name "Octavia E. Butler"
                         :birth-year 1947
                         :death-year 2006}})
~~~

<exercise>
Write the function `(alive? author)` which takes an author map and returns
`true` if the `author` is alive, otherwise `false`.

~~~ {.clojure}
(alive? (:author cities))    ;=> true
(alive? (:author wild-seed)) ;=> false
~~~
</exercise>

<exercise>
Write the function `(title-length book)` that counts the length of the book's
title. Use `let` to extract the title.

You can use `count` to find out the length of a string:

~~~ {.clojure}
(count "foo") ;=> 3
~~~

~~~ {.clojure}
(title-length cities)    ;=> 21
(title-length wild-seed) ;=> 9
~~~
</exercise>

## Serial grave digging

We know how to extract information from a single book or author. However, we
often want to extract information from a collection of items. As an example,
given a collection of books, we want the names of all the authors:

~~~ {.clojure}
(def embassytown {:title "Embassytown",
                  :author {:name "China Miéville",
                           :birth-year 1972}})

(def books [cities, wild-seed, embassytown])

(all-author-names books) ;=> #{"China Miéville" "Octavia E. Butler"}
~~~

How should we implement `all-author-names`?

We'll give the implementation now, and introduce the new concepts used one by
one. The implementation looks like this:

~~~ {.clojure}
(defn all-author-names [books]
  (let [author-name (fn [book] (:name (:author book)))]
    (set (map author-name books))))
~~~

Now there's a lot of new stuff there, so we'll take a detour to learn them
before continuing with our book library.

### Anonymous functions

`fn` defines an anonymous function.

~~~ {.clojure}
user=> (fn [x] (* x x))
#<user$eval1189$fn__1190 user$eval1189$fn__1190@5627f221>
~~~

Okay, se we get a function. This can be called like any other function:

~~~ {.clojure}
user=> ((fn [x] (* x x)) 4)
16
~~~

Using it like this is pretty awkward, usually we want our functions to have a
name instead.

~~~ {.clojure}
(def square
  (fn [x] (* x x)))
(square 4) ;=> 16
~~~

This is pretty much how defn works, though it does more, like handles
doc-strings that you can find with `doc`.

Anonymous functions are useful when you want short helper functions. You can
give them names with a `let` and they will only be visible in that context.

In the function `all-author-names`, that we can't fully understand yet, we
wanted a helper function that the name of the author of a book:

~~~ {.clojure}
(defn all-author-names [books]
  (let [author-name (fn [book] (:name (:author book)))]
    (set (map author-name books))))
~~~

So we want that `author-name` works like this:

~~~ {.clojure}
(def wild-seed {:title "Wild Seed",
                :author {:name "Octavia E. Butler"
                         :birth-year 1947
                         :death-year 2006}})

(author-name wild-seed) ;=> "Octavia E. Butler"
~~~

And that's what the above definition does. But since it is defined inside
`all-author-names`, it is only visible inside that function.

TODO: fn-sormiharjoittelua, tehtävä tai pari, mahollisesti letin kanssa

Theres another elephant in the living room, so let's look at this `map`
function next.

### Sequences

Before talking about `map`, we need to introduce a concept: the *sequence*.
Many of Clojure's functions that operate on vectors and other collections
actually operate on sequences. The `(seq collection)` function returns a
sequence constructed from a collection, such as a vector or a map.

Sequences have the following operations:

- `(first sequence)` returns the first element of the sequence.

- `(rest sequence)` returns the sequence without its first element.

- `(cons item sequence)` returns a new sequence where `item` is the first
element and `sequence` is the rest.

~~~ {.clojure}
(seq [1 2 3])          ;=> (1 2 3)
(seq {:a 42 :b "foo" :c ["ur" "dad"]})
                       ;=> ([:a 42] [:c ["ur" "dad"]] [:b "foo"])
(first (seq [1 2 3]))  ;=> 1
(rest (seq [1 2 3))    ;=> (2 3)
(cons 0 (seq [1 2 3])) ;=> (0 1 2 3)
~~~

Here you can see the printed form of sequences, the elements inside `(` and
`)`. This has the consequence that copying `(1 2 3)` back to the REPL tries to
call `1` as a function. The result is that you can not use the printed form of
a sequence as a value like you could with vectors and maps.

Actually, the sequence functions call `seq` on their collection parameters
themselves, so we can just write the above examples like this:

~~~ {.clojure}
(first [1 2 3])  ;=> 1
(rest [1 2 3])   ;=> (2 3)
(cons 0 [1 2 3]) ;=> (0 1 2 3)
~~~

<exercise>
TODO: exercise
</exercise>

### The map function

`(map function collection)` takes two parameters, a function and a sequencable
collection.  It calls the function on each element of the sequence and returns
a sequence of the return values.

~~~ {.clojure}
(defn munge [x]
  (+ x 42))

(map munge [1 2 3 4])
;=> ((munge 1) (munge 2) (munge 3) (munge 4)) ; [note below]
;=> ( 43        44        45        46)
~~~

*Note:* You can't paste the result line (or the middle one) to the REPL, as it
is the printed form of a sequence.

<exercise>
Write the function `(element-lengths collection)` that returns the
lengths of every item in `collection`.

~~~ {.clojure}
(element-lengths ["foo" "bar" "" "quux"])  ;=> (3 3 0 4)
(element-lengths ["x" [:a :b :c] {:y 42}]) ;=> (1 3 1)
~~~
</exercise>

<exercise>
Use `map` to write the function `(second-elements collection)` that takes a
vector of vectors and returns a sequence of the second elements.

~~~ {.clojure}
(second-elements [[1 2] [2 3] [3 4]]) ;=> (2 3 4)
(second-elements [[1 2 3 4] [1] ["a" "s" "d" "f"]])
;=> (2 nil "s")
~~~

Remember that you can use `get` to index a vector.

Use `fn` and `let` to create a helper function and use it with `map`.
</exercise>

<exercise>
Write the function `(titles books)` that takes a collection of books and
returns their titles.

Using our earlier examples:

~~~ {.clojure}
(def cities {:title "The City and the City"
             :author {:name "China Miéville", :birth-year 1972}})
(def wild-seed {:title "Wild Seed",
                :author {:name "Octavia E. Butler"
                         :birth-year 1947
                         :death-year 2006}})
(def embassytown {:title "Embassytown",
                  :author {:name "China Miéville",
                           :birth-year 1972}})

(def books [cities, wild-seed, embassytown])
~~~

`titles` should work like this:

~~~
(titles [cities]) ;=> ("The City and the City" )
(titles books)    ;=> ("The City and the City" "Wild Seed" "Embassytown")
~~~

Remember that you can use `:keywords` as functions.

~~~ {.clojure}
(:name {:name "MEEEE", :secret "Awesome"}) ;=>  "MEEEE"
~~~
</exercise>

We can now almost undestand the definition of `all-author-names`. Remember
that our implementation looked like this:

~~~ {.clojure}
(defn all-author-names [books]
  (let [author-name (fn [book] (:name (:author book)))]
    (set (map author-name books))))
~~~

The final piece is the `set` function, which we haven't introduced yet.
However, let's try the function without `set`, first.

We had these example books:

~~~ {.clojure}
(def cities {:title "The City and the City"
             :author {:name "China Miéville", :birth-year 1972}})
(def wild-seed {:title "Wild Seed",
                :author {:name "Octavia E. Butler"
                         :birth-year 1947
                         :death-year 2006}})
(def embassytown {:title "Embassytown",
                  :author {:name "China Miéville",
                           :birth-year 1972}})

(def books [cities, wild-seed, embassytown])
~~~

And if we define `all-author-names` without `set`, we have:

~~~ {.clojure}
(defn all-author-names [books]
  (let [author-name (fn [book] (:name (:author book)))]
    (map author-name books)))
~~~

Here is how it works:

~~~ {.clojure}
(all-author-names books) ;=> ("China Miéville" "Octavia E. Butler" "China Miéville")
~~~

We had two books by China Miéville, so his name is in the resulting sequence
twice. But when we want to see the authors, we are usually not interested in
duplicates. So lets turn the sequence into a data structure that supports
this.

### Set

Our last major data structure is set. It is an unordered collection of items
without duplicates.

~~~ {.clojure}
(set ["^^" "^^" "^__*__^"]) ;=> #{"^__*__^" "^^"}
(set [1 2 3 1 1 1 3 3 2 1]) ;=> #{1 2 3}
~~~

The textual form of sets is `#{an-elem another-elem ...}` and you can convert
another collection into a set with the function `set`.

Sets have three basic operations:

You can check whether a set contains an element with the function `contains?`:

~~~ {.clojure}
(def games #{"Portal", "Planescape: Torment",
             "Machinarium", "Alpha Protocol"})

(contains? games "Portal") ;=> true
(contains? games "RAGE")   ;=> false
(contains? games 42)       ;=> false
~~~

`(conj set elem)` adds elem to `set` if it does not already have `elem`:

~~~ {.clojure}
(conj #{:a :b :c} :EEEEE) ;=> #{:a :c :b :EEEEE}
(conj #{:a :b :c} :a)     ;=> #{:a :c :b}
(conj #{:a :b :c} :d :e)  ;=> #{:a :c :b :d :e}
~~~

Finally, `(disj set elem)` removes `elem` from `set` if it contains `elem`:

~~~ {.clojure}
(disj #{:a :b :c} :c) ;=> #{:a :b}
(disj #{:a :b :c} :EEEEE) ;=> #{:a :c :b}
(disj #{:a :b :c} :c :a) ;=> #{:b}
~~~

TODO: joku settitehtävä tähän

Now we can understand the whole implementation of `all-author-names`. We use
- `fn` to introduce a helper function,
- keywords to index the books,
- `let` to give a name to our helper function,
- `map` to apply the helper function to all the given books, and
- construct a set with the `set` function to get rid of duplicates.

~~~ {.clojure}
(defn all-author-names [books]
  (let [author-name (fn [book] (:name (:author book)))]
    (set (map author-name books))))
~~~

Calling our function returns the desired set:

~~~ {.clojure}
(all-author-names books) ;=> #{"China Miéville" "Octavia E. Butler"}
~~~

## Filtering sequences

Another common function besides `map` is `filter`. It is used to select some
elements of a sequence and disregard the rest:

~~~ {.clojure}
(filter pos? [-4 6 -2 7 -8 3]) ;=> (6 7 3)
(filter (fn [x] (> (count x) 2)) ["ff" "f" "ffffff" "fff"])
;=> ("ffffff" "fff")
~~~

`(filter predicate collection)` takes two parameters, a function and a
sequencable collection. It calls the function on each element of the sequence
and returns a sequence of the values from the collection for which the function
returned a truthy value. In the above example the values `(6 7 3)` were
selected because for them `pos?` returned true; for the others it returned
false, a falsey value, and they were filtered out.

<exercise>
Write the function `(books-by-author author books)`.

~~~ {.clojure}
(books-by-author "China Miéville" books) ;=> (cities embassytown)
~~~
</exercise>

<exercise>
Implement `(book-titles-by-author author books)`, which returns the book
titles of the books by the given author.

Use `books-by-author` as a helper function.
</exercise>

<exercise>
Implement `(author-names authors)`, which returns all the author names in a
set.
</exercise>

<exercise>
Implement `(authors books)`, which returns all the authors in a set.
</exercise>

<exercise>
Using the two previous functions, implement `(books->author-names books)`,
which returns all the books' authors' names in a set.
</exercise>

### Keeping your vectors

`map` and `filter` always return sequences, regardless of the collection type
given as a parameter. Sometimes, however, you want the result to be a vector.
For an example, you may want to index the vector afterwards. In this
situation, you can use `mapv` and `filterv`, which are variants of `map` and
`filter` that always return vectors.

~~~ {.clojure}
(mapv ... [...])    ;=> [...]
(filterv pos? [-4 6 -2 7 -8 3])  ;=> [6 7 3]
(filterv pos? #{-4 6 -2 7 -8 3}) ;=> [3 6 7]
(mapv ... #{...})   ;=> [...]
~~~
