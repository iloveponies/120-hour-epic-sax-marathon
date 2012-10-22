% One function to rule them all
% 120 hour epic
% sax marathon

## Synopsis

## Fork this

[https://github.com/iloveponies/one-function-to-rule-them-all](https://github.com/iloveponies/one-function-to-rule-them-all)

## Return of the recursion

Often you want to combine elements of a collection, like calculate the sum or
product of a list of numbers, or concatenate a list of strings. That is, we
want to make a transformation like this:

~~~clojure
    (cons 1 (cons 2 (cons 3 nil)))
;=> (+    1 (+    2 (+    3 0)))
~~~

Our tool for this job was recursion:

~~~clojure
(defn sum [a-seq]
  (if (empty? a-seq)
    0
    (+ (first a-seq) (sum (rest a-seq)))))
~~~

To make this more efficient, we extended our toolkit with `recur`:

~~~clojure
(defn sum [a-seq]
  (let [h (fn [acc a-seq]
            (if (empty? a-seq)
              acc
              (recur (+ acc (first a-seq))
                     (rest a-seq))))]
    (h 0 a-seq)))
~~~

Now lets say that we would like to compute the product of a list of numbers.
It would go like this:

~~~clojure
(defn product [a-seq]
  (let [h (fn [acc a-seq]
            (if (empty? a-seq)
              acc
              (recur (* acc (first a-seq))
                     (rest a-seq))))]
    (h 1 a-seq)))
~~~

The only two things that changed was the function `+` that was replaced with
`*` and the initial value `0` that was replaced by `1`. So one starts to
wonder if there is a pattern behind this all. And it turns out that there is.
A function called `reduce`.

So what do we get if we re-define our `sum` and `product` with `reduce`?

~~~clojure
(defn sum [a-seq]
  (reduce + 0 a-seq))
(defn product [a-seq]
  (reduce * 1 a-seq))
~~~

So `reduce` managed to abstract out just the two things that where different
in `sum` and `product`. The initial value and the operation that composes the
values into a one value. Everything else seems to be handled by `reduce`. So
what does it do?

~~~clojure
(defn reduce [f initial a-seq]
  (if (empty? a-seq)
    initial
    (recur f
           (f initial (first a-seq))
           (rest a-seq))))
~~~

Lets go through an evaluation of `reduce`:

~~~clojure
(reduce + 0 [1 2 3])
;=> (reduce + (+ 0 1) [2 3])
;=> (reduce + (+ (+ 0 1) 2) [3])
;=> (reduce + (+ (+ (+ 0 1) 2) 3) [])
;=> (+ (+ (+ 0 1) 2) 3)
;=> 6
~~~

Time to put the good tool to use.

<exercise>

Write the function `(concat-elements a-seq)` that takes a sequence of
sequences and concatenates them together with `concat`.

Don't use `apply` to implement this function.

~~~clojure
(concat-elements [])            ;=> ()
(concat-elements [[1 2]])       ;=> (1 2)
(concat-elements [[1 2] [3 4]]) ;=> (1 2 3 4)
~~~

</exercise>

<exercise>

Write the function `(my-count a-seq)` that returns the length of a sequence.

You are not to use `count` in your implementation.

~~~clojure
(my-count [])      ;=> 0
(my-count [1 2 3]) ;=> 3
(my-count [1])     ;=> 1
~~~

</exercise>

<exercise>

Write the function `(count-occurences elem a-seq)` that counts the number of
occurences of `elem` in the `a-seq`.

~~~clojure
(count-occurences :a [:a :b :c]) ;=> 1
(count-occurences :a [:b :c])    ;=> 0
(count-occurences 1 [1 1 1 2])   ;=> 3
~~~

</exercise>

## Two 

One can call `reduce` in two different ways.

- If the initial accumulator is provided and the input sequence is empty,
  reduce will return the initial accumulator value and will not call the
  combinator function.
  
    ~~~clojure
    (reduce (fn [x] (/ x 0)) 2 []) ;=> 2
    ~~~
    
- If no initial value is given, the first element in the input sequence is
  used. If the input sequence only has a one value, it is returned and the
  combinator function is not called. If the input sequence is empty, the
  combintor function is called with no arguments.
  
    ~~~clojure
    (reduce + [1 2 3])            ;=> 6
    (reduce (fn [x] (/ x 0)) [1]) ;=> 1
    (reduce + [])                 ;=> 0
    (reduce * [])                 ;=> 1
    ~~~

Lets look at an evaluation of a `reduce` call without an initial value.

~~~clojure
(reduce + [4 3 2])
;=> (reduce + 4 [3 2]) ; here we use the first element as the initial value
;=> (reduce + (+ 4 3) [2])
;=> (reduce + (+ (+ 4 3) 2) [])
;=> (+ (+ 4 3) 2)
;=> 9
~~~

<exercise>

Write the function `(my-interpose x a-seq)` that places `x` between every
element of `a-seq`.

Keep in mind the function `concat`.

~~~clojure
(my-interpose 0 [1 2 3])               ;=> (1 0 2 0 3)
(my-interpose "," ["I" "me" "myself"]) ;=> ("I" "," "me" "," "myself")
(my-interpose :a [1])                  ;=> (1)
(my-interpose :a [])                   ;=> ()
~~~

</exercise>

<exercise>

Write the function `(str-cat a-seq)` that takes a sequence of strings and
catenates them with one space character between each.

~~~clojure
(str-cat ["I" "am" "Legend"]) ;=> "I am Legend"
(str-cat ["I" "am" "back"])   ;=> "I am back"
(str-cat ["more" " " "space"]) ;=> "more   space"
~~~

</exercise>

<exercise>

Write the function `(my-reverse a-seq)` that reverses a sequence.

~~~clojure
(my-reverse [1 2 3]) ;=> (3 2 1)
(my-reverse [1 2])   ;=> (2 1)
(my-reverse [])      ;=> ()
~~~

</exercise>

<exercise>

Write the function `(min-max-element a-seq)` that returns the maximal and
minimal elements of `a-seq` in a vertor like `[min max]`.

~~~clojure
(min-max-element [2 7 3 15 4]) ;=> (2 15)
(min-max-element [1 2 3 4])    ;=> (1 4)
(min-max-element [1])          ;=> (1 1)
~~~

</exercise>

<exercise>

Write the function `(insert sorted-seq n)` that adds the number `n` into a
sorted sequence of number. The ordering of the sequence must be preserved.

~~~clojure
(insert [] 2)      ;=> (2)
(insert [1 3 4] 2) ;=> (1 2 3 4)
(insert [1] 2)     ;=> (1 2)
~~~

</exercise>

<exercise>

Implement `(insertion-sort a-seq)` using `reduce` and the function `insert`
from the previous exercise.

~~~clojure
(insertion-sort [2 5 3 1]) ;=> (1 2 3 5)
(insertion-sort [1 2])     ;=> (1 2)
~~~

</exercise>

<exercise>

Write the fuction `(parity a-seq)` that picks into a set those elements of
`a-seq` that occur odd number of time.

~~~clojure
(parity [:a :b :c])    ;=> #{:a :b :c}
(parity [:a :a :b :b]) ;=> #{}
(parity [1 2 3 1])     ;=> #{2 3}
~~~

</exercise>
