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

Or like this:

~~~{.clojure}
    (cons 1 (cons 2 (cons 3 nil)))
;=> (*    1 (*    2 (*    3 0)))
~~~

<!-- ******* -->

Our tool for this job was recursion:

~~~clojure
(defn sum [a-seq]
  (if (empty? a-seq)
    0
    (+ (first a-seq) (sum (rest a-seq)))))
~~~

To make this more efficient, we made this tail recursive using `recur` and an
accumulator:

~~~clojure
(defn sum [a-seq]
  (let [sum-helper (fn [acc a-seq]
                     (if (empty? a-seq)
                       acc
                       (recur (+ acc (first a-seq))
                              (rest a-seq))))]
    (sum-helper 0 a-seq)))
~~~

This iterative `sum` would evaluate like this:

~~~{.clojure}
;function evaluation                                        accumulator value
(sum              (cons 1 (cons 2 (cons 3 (cons 4 nil))))) ;
;=> (sum-helper 0 (cons 1 (cons 2 (cons 3 (cons 4 nil))))) ; 0
;=> (sum-helper 1 (cons 2 (cons 3 (cons 4 nil))))          ; (+ 0 1) => 1
;=> (sum-helper 3 (cons 3 (cons 4 nil)))                   ; (+ 1 2) => 3
;=> (sum-helper 6 (cons 4 nil))                            ; (+ 3 3) => 6
;=> (sum-helper 10 nil)                                    ; (+ 6 4) => 10
;=> 10
~~~

Now lets say that we would like to compute the product of a list of numbers.
It would go like this:

~~~clojure
(defn product [a-seq]
  (let [product-helper (fn [acc a-seq]
                         (if (empty? a-seq)
                           acc
                           (recur (* acc (first a-seq))
                                  (rest a-seq))))]
    (product-helper 1 a-seq)))
~~~

The only two things that changed was the function `+` that was replaced with
`*` and the initial value `0` that was replaced by `1`. So one starts to
wonder if there is a pattern behind this all. And it turns out that there is.
A function called `reduce`.

`(reduce combining-function initial-accumulator-value a-sequence)` takes:

- a function that is used to combine the current accumulator value and the
  current element of the parameter sequence
- an initial value for the accumulator
- a sequence

So what do we get if we re-define our `sum` and `product` with `reduce`?

~~~clojure
(defn sum [a-seq]
  (reduce + 0 a-seq))
(defn product [a-seq]
  (reduce * 1 a-seq))
~~~

Let's see this `sum` would evaluate:

~~~{.clojure}
(sum            (cons 4 (cons 7 (cons 2 nil))))
;=> (reduce + 0 (cons 4 (cons 7 (cons 2 nil))))
;=> (reduce + (+ 0 4) (cons 7 (cons 2 nil)))    ; accumulator: 0, element: 4
;=> (reduce + 4 (cons 7 (cons 2 nil)))          ; (+ 0 4) => 4
;=> (reduce + (+ 4 7) (cons 2 nil))             ; accumulator: 4, element: 7
;=> (reduce + 11 (cons 2 nil))                  ; (+ 4 7) => 11
;=> (reduce + (+ 11 2) nil)                     ; accumulator: 11, element: 2
;=> (reduce + 13 nil)                           ; (+ 11 2) => 13
;=> 13                                          ; accumulator: 13
~~~

So `reduce` managed to abstract out just the two things that where different
in `sum` and `product`. The initial value and the operation that composes the
values into a one value. Everything else seems to be handled by `reduce`. So
how does it work?

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
    (reduce + 0                   [1 2 3])
;=> (reduce + (+ 0 1)             [2 3])
;=> (reduce + (+ (+ 0 1) 2)       [3])
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

## Two Sides of a Coin

One can call `reduce` in two different ways:

~~~{.clojure}
(reduce combinator-function initial-accumulator-value input-sequence)
~~~

or

~~~{.clojure}
(reduce combinator-function                           input-sequence)
~~~

If `input-sequence` is not empty, then the second form works like this:

~~~{.clojure}
    (reduce f (cons elem rest))
;=> (reduce f elem rest)
~~~

that is, it uses the first element of the parameter sequence as the initial
accumulator value.

And f `input-sequence` is empty, then:

- The first form returns `initial-accumulator-value`
- The second form returns `(combinator-function)`, that is, it calls
  `combinator-function` with zero parameters.


Let's try this version without initial value:
~~~{.clojure}
(defn seq-min [a-seq]
  (reduce min a-seq))

(seq-min [1])       => 1
(seq-min [5 3 2 6]) => 2
(seq-min [])
  => java.lang.IllegalArgumentException:
     Wrong number of args (0) passed to: core$min (NO_SOURCE_FILE:0)
~~~

Now the call with empty sequence results in an exception, since `min` is not
defined for 0 arguments. Since `seq-min` used `reduce` without an initial
value, it called `(min)` when it was given an empty sequence.

Lets look at an evaluation of a `reduce` call without an initial value.

~~~clojure
(seq-min [5 3 2 6])
;=> (reduce min [5 3 2 6])
;=> (reduce min 5 [3 2 6])       ; Use the first element as the initial value
;=> (reduce min (min 5 3) [2 6])
; = (reduce min 3 [2 6])
;=> (reduce min (min 3 2) [6])
; = (reduce min 2 [6])
;=> (reduce min (min 2 6) [])
; = (reduce min 2 [])
;=> 2
~~~

<exercise>
Write the function `(str-cat a-seq)` that takes a sequence of strings and
catenates them with one space character between each.

~~~clojure
(str-cat ["I" "am" "Legend"])  ;=> "I am Legend"
(str-cat ["I" "am" "back"])    ;=> "I am back"
(str-cat ["more" " " "space"]) ;=> "more   space"
(str-cat [])                   ;=> ""
~~~

You probably want to handle the special case of empty parameter outside
reduce.
</exercise>

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

Let's look at another example. We implemented the function `my-count` in
[Recursion], which counts the occurrences of an element in a sequence. Let's
reimplement that function with reduce:

[Recursion]: recursion.html

~~~{.clojure}
(defn my-count [elem a-seq]
  (let [counter (fn [count e]
                  (if (= e elem)
                    (inc count)
                    count))]
    (reduce counter 0 a-seq)))
~~~

~~~{.clojure}
(my-count :D [13 "\o/" :D :$ :D [:D] :< "~^._.^~"])
;=> (reduce counter 0                 [13 "\o/" :D :$ :D [:D] :< "~^._.^~"])
;=> (reduce counter (counter 0 13)    ["\o/" :D :$ :D [:D] :< "~^._.^~"])
;=> (reduce counter 0                 ["\o/" :D :$ :D [:D] :< "~^._.^~"])
;=> (reduce counter (counter 0 "\o/") [:D :$ :D [:D] :< "~^._.^~"])
;=> (reduce counter 0                 [:D :$ :D [:D] :< "~^._.^~"])
;=> (reduce counter (counter 0 :D)    [:$ :D [:D] :< "~^._.^~"])
;=> (reduce counter 1                 [:$ :D [:D] :< "~^._.^~"])
;=> (reduce counter (counter 1 :$)    [:D [:D] :< "~^._.^~"])
;=> (reduce counter 1                 [:D [:D] :< "~^._.^~"])
;=> (reduce counter (counter 1 :D)    [[:D] :< "~^._.^~"])
;=> (reduce counter 2                 [[:D] :< "~^._.^~"])
;=> (reduce counter (counter 2 [:D])  [:< "~^._.^~"])
;=> (reduce counter 2                 [:< "~^._.^~"])
;=> (reduce counter (counter 2 :<)    ["~^._.^~"])
;=> (reduce counter 2                 ["~^._.^~"])
;=> (reduce counter (counter 2 "~^._.^~") [])
;=> (reduce counter 2 [])
;=> 2
~~~

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
