% Structured data
% 120 hour epic
% sax marathon

## Synopsis

In which we learn to work with structured data.

- Sequences
- Vectors
- Maps

## Collecting all the data

Introduction to Clojure collections here.

### Sequences

Do we want to speak about sequences here?

### Lists

Should we talk about lists?

Lists are :

~~~ {.clojure}
(+ 1 2)
(get "Foobar" 3)
~~~

When a list is evaluated, the first element (the *head*) is resolved to a
function and called, with the other items given to the function as arguments.

### Vectors

A vector is a collection that can be indexed with integers, like an array in
other languages:

~~~ {.clojure}
[1 2 3]                 ;=> [1 2 3]
[:foo 42 "bar" (+ 2 3)] ;=> [:foo 42 "bar" 5]
~~~

As you can see, like most data structures, vectors evaluate to themselves.

### Maps

A map is an associative collection. It associates keys to values (like a
vector associates integer keys to values).

~~~ {.clojure}
{:a 42 :b "quux"}      ;=> {:a 42 :b "quux"}
(:a {:a 42 :b "quux"}) ;=> 42
{"quux" :foo 42 \i}    ;=> {"quux" :foo 42 \i}
~~~

The keys and values can be of any data type, and one map can contain any
number of different data types as both keys and values.

Maps evaluate to themselves.

## Can't change this

Collections are immutable.

## Yummy innards

Destructuring.
