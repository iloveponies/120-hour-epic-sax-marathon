% Recursion
% 120 hour epic
% sax marathon

## Synopsis

Recursion is the low-level implementation strategy for many functional
algorithms and functions.

- TODO
- Wat we talk about

## Get the project

TODO

## Recap

This chapter talks a lot about collections and we'll need the functions
`first` and `rest`:

~~~ {.clojure}
(doc first)
(doc rest)
(first [1 2 3 4])  ;=> 1
(first '(1 2 3 4)) ;=> 1
(rest [1 2 3 4])   ;=> (2 3 4)
(rest '(1 2 3 4))  ;=> (2 3 4)
(rest [1])         ;=> ()
(rest [])          ;=> ()
~~~

`first` gets the first element of a sequence, and `rest` gets all but the
first element.

## Recursion

So far we've manipulated collections with functions like `map`, `filter` and
`for`. How do they work? They are all based on _recursion_. Recursion is the
low-level method of iteration found in functional languages. While the
higher-level functions like `map` are usually nicer to use than implementing
the equivalent algorithm with recursion ourselves, there are often situations
when the structure of the algorithm or the data it operates on is such that the
existing higher-level functions do not quite work on it.

### Lists are recursive structures

Let's look at the function `cons`. It takes two parameters, a value and a
sequence, and returns a new sequence with the value added to the front of the
original sequence. For an example, to construct the sequence `(1 2 3 4)`, we
could write:

~~~ {.clojure}
(cons 1
      (cons 2
            (cons 3
                  (cons 4
                        nil))))
;=> (1 2 3 4)
~~~

`nil` is the empty sequence.

To process this nested structure suggests that we should first process the
first element of the sequence, and then do the operation again on the rest of
the sequence. This is actually the general structure of _linear recursion_. As
a concrete example, let's look at how to implement `sum`.

~~~ {.clojure}
(defn sum [coll]
  (if (empty? coll)
    0
    (+ (first coll)
       (sum (rest coll)))))

(sum [1 2 3 4]) ;=> 10
~~~

The *sum* of a sequence is:
- 0, if the sequence is empty, or
- the *first* element of the sequence *added* to the *sum* of the *rest* of the
  sequence.

Imagine an arrow drawn from the second *sum* to the first *sum*. This is the
recursive nature of the algorithm.

The call to `sum` begins by inspecting `coll`. If `coll` is empty, `sum`
immediately returns 0. If `coll` is not empty, `sum` takes its first element
and adds it to the sum of the rest of the elements of `coll`. The value 0 is
the base case of the algorithm, which determines when the calculation stops. If
we did not have a base case, the calculation would continue infinitely. 

<exercise>
Write the function `(product coll)` that computes the product of a collection
of values.

~~~ {.clojure}
(product [])        ;=> 1  ; special case 
(product [1 2 3])   ;=> 6
(product [1 2 3 4]) ;=> 24
(product [0 1 2])   ;=> 0
(product #{2 3 4})  ;=> 24 ; works for sets too!
~~~
</exercise>

To get a better grasp on what `sum` does, let's see how it's evaluated.

~~~ {.clojure}
    (sum '(1 2 3 4))
=   (sum (cons 1 (cons 2 (cons 3 (cons 4 nil)))))
;=> (+ 1 (sum (cons 2 (cons 3 (cons 4 nil)))))
;=> (+ 1 (+ 2 (sum (cons 3 (cons 4 nil)))))
;=> (+ 1 (+ 2 (+ 3 (sum (cons 4 nil)))))
;=> (+ 1 (+ 2 (+ 3 (+ 4 (sum nil)))))
;=> (+ 1 (+ 2 (+ 3 (+ 4 0))))        ; (empty? nil) is true, so (sum nil) ;=> 0
;=> (+ 1 (+ 2 (+ 3 4)))
;=> (+ 1 (+ 2 7))
;=> (+ 1 9)
;=> 10
~~~

Note that we expanded the list `'(1 2 3 4)` to its `cons` form. If we take a
closer look at that form and the line with comment above, we'll see why:

~~~ {.clojure}
   (cons 1 (cons 2 (cons 3 (cons 4 nil))))
...
;=> (+    1 (+    2 (+    3 (+    4   0))))
~~~

We replaced the `cons` operation in the recursive structure with `+` and `nil`
with `0`. That is, we transformed the data structure into a calculation with
the same form but different result.

From this we get the general template for linear recursion over collections:

~~~ {.clojure}
(defn eats-coll [coll]
  (if (empty? coll)
    ...
    (... (first coll) ... (eats-coll (rest coll)))))
~~~

The first branch of the `if` is the base case and determines the value of
`eats-coll` when given an empty collection. The second branch determines what
operation to apply on the elements of the collection.

We call this kind of computation _linear_ because the expression it constructs
grows linearly with the size of input.

<exercise>
Write down the evaluation of `(product [1 2 4])` like we did for `sum` above.
</exercise>

<exercise>
Compute the last element of a sequence.

~~~ {.clojure}
(last-element [1 2 3]) ;=> 3
(last-element [2 5])   ;=> 5
~~~

Hint: what is the base case here? How can you check if we're there?
</exercise>

### Stopping before the end

Sometimes you can find the answer before hitting the base case. For example,
the following function checks if a sequence contains only numbers. If we find
something that isn't a number on the way through, we can immediately stop and
return `false`.

~~~ {.clojure}
(defn only-numbers? [coll]
  (cond
   (empty? coll)
     true                        ; the empty sequence contains only numbers
   (number? (first coll))
     (only-numbers? (rest coll)) ; we got a number, let's check the rest
   :else
     false))                     ; it wasn't a number so we have our answer
~~~

Here the recursion stops if we hit the base case (empty collection) or if we
find a non-number.

~~~ {.clojure}
(only-numbers? [1 2 3 4])    ;=> true
(only-numbers? [1 2 :D 3 4]) ;=> false
~~~

Let's have a closer look at the evaluation of the second line:

~~~ {.clojure}
   (only-numbers? [1 2 :D 3 4])
;=> (only-numbers? [2 :D 3 4])
    ; (number? 1) ;=> true, so we now need to check if all the rest are numbers.
;=> (only-numbers? [:D 3 4]) ; because (number? 2) ;=> true
;=> false                    ; because (number? :D) ;=> false
~~~

<exercise>
Write the function `(sequence-contains? elem collection)` that returns `true`
if the given sequence contains the given value, otherwise `false`.

~~~ {.clojure}
(sequence-contains? 3 [1 2 3]) ;=> true
(sequence-contains? 3 [4 7 9]) ;=> false
(sequence-contains? :pony [])  ;=> false
~~~

Hint: remember to stop searching when you find it.
</exercise>

### Recursing over many sequences

The template for linear recursion is very simple and is often *too* simple. For
an example, consider the function `(first-in val seq-1 seq-2)`, which returns
`1` if the value `val` is found first in `seq-1` and `2` if in `seq-2`. If
`val` is not found in either sequence, `first-in` returns `0`. `val` must not
be `nil`.

~~~ {.clojure}
(defn first-in [val seq-1 seq-2]
  (cond
    (and (empty? seq-1) (empty? seq-2)) 0
    (= (first seq-1) val) 1
    (= (first seq-2) val) 2
    :else (first-in val (rest seq-1) (rest seq-2))))
~~~

There's an obvious reason why `first-in` doesn't fit our template for linear
recursion: it has three parameters, whereas the template only takes one. We can
ignore the first parameter for our purposes, since it does not have bearing on
the recursive structure of the computation. `first-in` is linearly recursive on
both its sequence parameters, though. There's actually a way to make `first-in`
fit into our template: transform its parameters into a single sequence with
`map vector seq-1 seq-2`. This means our template is probably enough for us as
long as we remember that it does not preclude recursing over multiple
sequences.

<exercise>
Write the function `(seq= seq-1 seq-2)` that compares two sequences for
equality.

~~~ {.clojure}
(seq= [1 2 4] '(1 2 4))  ;=> true
(seq= [1 2 3] [1 2 3 4]) ;=> false
(seq= [1 3 5] [])        ;=> false
~~~
</exercise>

### Recursion on numbers

Another common data structure to recurse over are numbers. (Even though you
might not think of numbers as data structures!) Recursing over numbers is very
similar to recursing over sequences. As an example, let's define a function to
calculate the factorial of a number. (Factorial of n is 1 * 2 * ... * (n-1) *
n.)

~~~ {.clojure}
(defn factorial [n]
  (if (zero? n)
    1
    (* n (factorial (dec n)))))
~~~

The `factorial` function looks a lot like `sum`. Given the number `n`, We have
the base case (return 1 if `n` is zero) and the recursive branch, which
multiplies `n` with the factorial of `(dec n)`, that is, `(- n 1)`. To verify
that this function really does implement the definition of factorial properly,
we can look at how it is evaluated:

~~~ {.clojure}
    (factorial 4)
;=> (* 4 (factorial 3))
;=> (* 4 (* 3 (factorial 2)))
;=> (* 4 (* 3 (* 2 (factorial 1))))
;=> (* 4 (* 3 (* 2 (* 1 (factorial 0)))))
;=> (* 4 (* 3 (* 2 (* 1 1)))) ; Base case reached
;=> (* 4 (* 3 (* 2 1)))
;=> (* 4 (* 3 2))
;=> (* 4 6)
;=> 24
~~~

The line where the base case is reached shows that the function does evaluate
to the mathematical expression we wanted.

Let's look a bit closer at how sequences and numbers are related. Where a
sequence is *cons*tructed, numbers are *inc*remented, and where a sequence is
destructured with `rest`, a number is decremented with `dec`:

~~~ {.clojure}
(inc    (inc    (inc    0)))   ;=> 3
(cons 1 (cons 2 (cons 3 nil))) ;=> (1 2 3)

(dec  (dec  (dec  3)))       ;=> 0
(rest (rest (rest [1 2 3]))) ;=> ()
~~~

Sequences store more information than numbers -- the elements -- but otherwise
the expressions above are very similar.  (The numbers actually encode the
length of the sequence. Conversely, sequences can be used to encode numbers.
Benjamin Pierce's [Software Foundations] is recommended reading if you're
interested in more off-topic esoterica.) With this relationship, we can make
the evaluation of `(factorial 4)` even more similar to our example of `sum`:

~~~ {.clojure}
    (factorial (inc (inc (inc (inc 0))))) ; Unwrap inc with dec
;=> (* 4 (factorial (inc (inc (inc 0))))) ; like cons with rest
;=> (* 4 (* 3 (factorial (inc (inc 0))))) ; almost a haiku
;=> (* 4 (* 3 (* 2 (factorial (inc 0)))))
;=> (* 4 (* 3 (* 2 (* 1 (factorial 0)))))
;=> (* 4 (* 3 (* 2 (* 1 1))))             ; Base case reached
;=> (* 4 (* 3 (* 2 1)))
;=> (* 4 (* 3 2))
;=> (* 4 6)
;=> 24
~~~

Let's define the general template for recursion over (natural) numbers, like we
did for sequences.

~~~ {.clojure}
(defn eats-numbers [n]
  (if (zero? n)
    ...
    (... n ... (eats-numbers (dec n)))))
~~~

<exercise>
Write the function `power` that computes the mathematical expression n ^k^.

~~~ {.clojure}
(power 2 2) ;=> 4
(power 5 3) ;=> 125
(power 7 0) ;=> 1
(power 0 10) ;=> 0
~~~
</exercise>

### Nonlinear recursion

There are other recursive computations besides linear recursion. Another common
type is _tree recursion_. Here _tree_ refers again to the shape of the
computation. The natural use for tree recursion is with hierarchical data
structures, which we will come back to later. Tree recursion can be illustrated
with simple processes over numbers. For an example, let's look at how to
compute the following integer series:

Let $f(n) =$
- $n$ if $n < 3$,
- $f(n-1) + 2*f(n-2) + 3*f(n-3)$ otherwise.

Translating this to Clojure gives us the following program:

~~~ {.clojure}
(defn f [n]
  (if (< n 3)
    n
    (+      (f (- n 1))
       (* 2 (f (- n 2)))
       (* 3 (f (- n 3))))))
~~~

(The odd alignment is for clarity.) Consider how this function evaluates:

!tree-recursion.png|border=0!

It is easy to see that the computation forms a tree structure.

<exercise>
Compute the $n$th [Fibonacci number]. The $n$th Fibonacci number, $F_n$, is
defined as:

- $F_0 = 0$
- $F_1 = 1$
- $F_n = F_{n-1} + F_{n-2}$

Write the function `(fib n)` which returns $F_n$.

~~~ {.clojure}
(fib 0) ;=> 0
(fib 1) ;=> 1
(fib 2) ;=> 1
(fib 3) ;=> 2
(fib 4) ;=> 3
(fib 5) ;=> 5
(fib 6) ;=> 8
...
(fib 10) ;=> 55
~~~
</exercise>

### Sequence operations

This is the code for the recursive function `repeat` that generates a list with
one element repeated a number of times.

~~~ {.clojure}
(defn repeat [what-to-repeat how-many-times]
  (when (pos? how-many-times)
    (cons what-to-repeat
          (repeat what-to-repeat (dec how-many-times)))))

(repeat 2 3) ;=> (2 2 2)
~~~

In the following exercises you should use recursion to build lists. Do not use
`for`.

<exercise>
Write the function `(my-range up-to)` that works like this:

~~~ {.clojure}
(my-range 0)  ;=> nil
(my-range 1)  ;=> (0)
(my-range 2)  ;=> (1 0)
(my-range 3)  ;=> (2 1 0)
~~~
</exercise>

<exercise>
Write the function `map-1` that works like `map` but supports only one argument
sequence.

~~~ {.clojure}
(map-1 identity [])                 ;=> ()
(map-1 identity [1 2 3])            ;=> (1 2 3)
(map-1 count ["aaa" "bb" "cccc"])   ;=> (3 2 4)
(map-1 first [[1 2] [4] [7 12 28]]) ;=> (1 4 7)
(map-1 zero? [0 2 0 13 4 0])        ;=> (true false true false false true)
~~~
</exercise>

<exercise>
Write the function `snip-many` that takes a sequence like `(0 1 2 :snip 3 4 5
:snip 6)` and returns a sequence of sequences like:

~~~ {.clojure}
((0 1 2) (3 4 5) (6))
~~~

_Hint_: remember `snip`.

More examples:

~~~
(snip-many [1 2 3])                   ;=> ((1 2 3))
(snip-many [])                        ;=> (())
(snip-many [:snip 1 2 :snip 3 :snip]) ;=> (() (1 2) (3) ())
(snip-many [:snip])                   ;=> (() ())
~~~
</exercise>

<exercise>
Write the functions `tails` and `inits` that return all the suffixes and
prefixes of a sequence, respectively. Examples:

~~~ {.clojure}
(tails [1 2 3 4])   ;=> ((1 2 3 4) (2 3 4) (3 4) (4) ())
(inits [1 2 3 4])   ;=> (() (1) (1 2) (1 2 3) (1 2 3 4))
~~~

You can output the tails and inits in any order you like. That is,

~~~ {.clojure}
(inits [1 2 3 4])   ;=> ((1 2) () (1 2 3) (1) (1 2 3 4))
~~~

is perfectly acceptable.

_Hint:_ You can use `reverse` and `map-1`.
</exercise>

<exercise>
Write the function `split-into-monotonics` that takes a sequence and returns
the sequence split into monotonic pieces. Examples:

~~~ {.clojure}
(split-into-monotonic [0 1 2 1 0])   ;=> ((0 1 2) (1 0))
(split-into-monotonic [0 5 4 7 1 3]) ;=> ((0 5) (4 7) (1 3))
~~~
</exercise>

### Passing state

Sometimes when recursing over a structure we want to keep track of something.
For an example, we might want to count how many elements we have processed, or
how many `:D` keywords we have seen. How do we do this, in the absence of state
in our language? (Or at least in the absence of instructions on how to use
state on these pages!)

The answer is two-fold: we store the state explicitly in a parameter we pass
back to ourselves on each recursion, and we hide the state from the users of
our function by using a helper function that we give an initial empty state to
as a parameter.

Here's an example of a function that counts how many times a sequence contains
a given value:

~~~ {.clojure}
(defn my-count-helper [n val coll]
  (if (empty? coll)
    n
    (let [new-count (if (= val (first coll))
                      (inc n)
                      n)]
      (my-count-helper
        new-count
        val
        (rest coll)))))

(defn my-count [val coll]
  (my-count-helper 0 val coll))
~~~

First, we define a helper function, `my-count-helper`. It takes three
parameters: `n`, which keeps count of how many recursions have been made,
`val`, which is the value we are looking for, and `coll`, which the function
recurses over. With this helper function, our definition of `my-count` is a
simple call to `my-count-helper` with `n` initialized to 0. This way users of
`my-count` do not need to provide the initialization argument for `n`.

<exercise>
Write the function `rotations` that, when given a sequence, returns all the
rotations of that sequence.

~~~ {.clojure}
(rotations [])                  ;=> ()
(rotations [1 2 3])             ;=> ((1 2 3) (2 3 1) (3 1 2))
(rotations [:a :b])             ;=> ((:a :b) (:b :a))
(rotations [1 5 9 2])           ;=> ((1 5 9 2) (2 1 5 9) (9 2 1 5) (5 9 2 1))
(count (rotations [6 5 8 9 2])) ;=> 5
~~~

The order of rotations does not matter.

You can use `concat` in your function. It concatenates two sequences:
~~~ {.clojure}
(concat [1 2 3] [:a :b :c]) ;=> (1 2 3 :a :b :c)
(concat [1 2] [3 4 5 6])    ;=> (1 2 3 4 5 6)
~~~
</exercise>

<exercise>
Write the function `my-frequencies` that computes a map of how many times each
element occurs in a sequence. E.g.:

~~~ {.clojure}
(my-frequencies []) ;=> {}
(my-frequencies [:a "moi" :a "moi" "moi" :a 1]) ;=> {:a 3, "moi" 3, 1 1}
~~~

You'll want to structure your code like this:

~~~
(defn frequencies-helper [freqs coll]
  ...)

(defn my-frequencies [coll]
  (frequencies-helper {} coll))
~~~

Where `frequencies-helper` is the recursive function.
</exercise>

<exercise>
Write the function `un-frequencies` which takes a map produced by
`my-frequencies` and generates a sequence with the corresponding numbers of
different elements.

~~~ {.clojure}
(un-frequencies {:a 3 :b 2 "^_^" 1})             ;=> (:a :a :a "^_^" :b :b)
(un-frequencies (my-frequencies [:a :b :c :a]))  ;=> (:a :a :b :c)
(my-frequencies (un-frequencies {:a 100 :b 10})) ;=> {:a 100 :b 10}
~~~

The order of elements in the output sequence doesn't matter.

Hint 1: Remember that you can use `first` and `rest` on a map too!

Hint 2: There are multiple ways to implement this, but you can consider using `concat` and `repeat`.
</exercise>

### Merging and sorting

<exercise>
Write a function `seq-merge` that takes two (low to high) sorted number
sequences and combines them into one sorted sequence. E.g.:

~~~ {.clojure}
(seq-merge [4] [1 2 6 7])        ;=> (1 2 4 6 7)
(seq-merge [1 5 7 9] [2 2 8 10]) ;=> (1 2 2 5 7 8 9 10)
~~~
</exercise>

<exercise>
Write the function `merge-sort` that implements [merge sort]. The idea of
merge sort is to divide the input into subsequences, sort them, and use the
`seq-merge` function defined above to merge the sorted subsequences. If two
subsequences are in sorted order, merging them will result in a sorted
sequence. If the subsequences are divided recursively into small enough pieces
that they can be sorted with other means (e.g. trivially when the subsequences
are one element long), the `merge` step then merges all the subsequences into
sorted order when the recursion returns from each subsequence.

Conceptually:
- If the sequence is 0 or 1 elements long, it is already sorted.
- Otherwise, divide the sequence into two subsequences.
- Sort each subsequence recursively.
- Merge the two subsequences back into one sorted sequence.

This conceptual code recurses until the subsequences are very short. An
alternative implementation might choose a threshold of 100 elements and sort
sequences below that length with quicksort. The exercise doesn't require this.

~~~ {.clojure}
    (merge-sort [4 2 3 1])
;=> (seq-merge (merge-sort (4 2))
;              (merge-sort (3 1)))
;=> (seq-merge (seq-merge (merge-sort (4))
;                         (merge-sort (2)))
;              (seq-merge (merge-sort (3))
;                         (merge-sort (1))))
;=> (seq-merge (seq-merge (4) (2))
;              (seq-merge (3) (1)))
;=> (seq-merge (2 4) (1 3))
;=> (1 2 3 4)
~~~

~~~ {.clojure}
(merge-sort [])                 ;=> ()
(merge-sort [1 2 3])            ;=> (1 2 3)
(merge-sort [5 3 4 17 2 100 1]) ;=> (1 2 3 4 5 17 100)
~~~

You can use the `halve` function from Collections exercise C2.
</exercise>

## Bonus problems

<exercise>
Given a sequence, return all permutations of that sequence.

~~~ {.clojure}
(permutations [])      ;=> ()
(permutations [1 5 3]) ;=> ((1 5 3) (5 1 3) (5 3 1) (1 3 5) (3 1 5) (3 5 1))
~~~

Order of permutations doesn't matter.
</exercise>

<exercise>
Given a sequence, return the powerset of that sequence. 

~~~ {.clojure}
(powerset [])      ;=> (())
(powerset [1 2 4]) ;=> (() (4) (2) (2 4) (1) (1 4) (1 2) (1 2 4))
~~~

Order of subsequences doesn't matter.
</exercise>

[Software Foundations]: http://www.cis.upenn.edu/~bcpierce/sf/Basics.html#nat
[Fibonacci number]: http://en.wikipedia.org/wiki/Fibonacci_number
[SICP on recursion]: http://mitpress.mit.edu/sicp/full-text/book/book-Z-H-11.html#%_sec_1.2
[merge sort]: http://en.wikipedia.org/wiki/Merge_sort
