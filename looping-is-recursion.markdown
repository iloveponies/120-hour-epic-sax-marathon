% Looping is recursion
% 120 hour epic
% sax marathon

## Synopsis

In which we learn how to recur tails.

## Fork this

[https://github.com/iloveponies/looping-is-recursion](https://github.com/iloveponies/looping-is-recursion)

[Here](basic-tools.html#how-to-submit-answers-to-exercises) are the
instructions if you need them. Be sure to fork the repository behind the link
above.

## Starting out

Clojure has a form called `loop`. But it's not actually a looping construct,
it is _recursive_ in nature. Let's start with some examples.

This is the standard recursive factorial:

~~~ {.clojure}
(defn recursive-factorial [n]
  (if (zero? n)
      1
      (* n (recursive-factorial (dec n)))))
~~~

Like we've seen in the [chapter on recursion][recursion], this is a linear
recursive process, that is, it constructs an expression linear in size to its
input, `n`. When the base case is reached, we will have the expression `(* n
(* (dec n) (* ... (* 3 (* 2 (* 1 1))) ...)))`. This also means that the amount
of memory taken by `recursive-factorial` is $\mathcal{O}(n)$.

We can make this computation more efficient by using _tail recursion_. A
function is _tail recursive_ when its return value is calculated directly by a
recursive call. `recursive-factorial` is not tail recursive, because the value
of the recursive call `(recursive-factorial (dec n))` is not returned
directly, but given to `*`.

We'll now introduce a tail recursive version of `recursive-factorial` and then
look at how its evaluation differs from the evaluation of
`recursive-factorial`.

In order to make factorial tail-recursive we introduce an *accumulator*.

~~~ {.clojure}
(defn accumulating-factorial [n]
  (let [helper (fn helper [acc n]
                 (if (zero? n)
                   acc
                   (helper (* acc n) (dec n))))]
    (helper 1 n)))
~~~

`helper` uses the return value of its recursive call directly as its return
value. That means it is tail recursive. Let's see how it evaluates:

~~~ {.clojure}
    (accumulating-factorial 5)
;=> (helper 1 5)
;=> (helper (* 1 5)   (dec 5)) => (helper 5 4)
;=> (helper (* 5 4)   (dec 4)) => (helper 20 3)
;=> (helper (* 20 3)  (dec 3)) => (helper 60 2)
;=> (helper (* 60 2)  (dec 2)) => (helper 120 1)
;=> (helper (* 120 1) (dec 1)) => (helper 120 0)
;=> 120
~~~

Now we see that evaluating `helper` does not grow the expression we are
computing. This is because we do not add any structure around the recursive
call. That keeps the structure of the returned expression constantly `(helper
...)` and the parameters vary. Since we can't build the computation as a
recursive expression, we're instead computing each step explicitly into the
`acc` accumulator.

This is a _linear iterative process_ or just _linear iteration_ (compared to
_linear recursion_). It is indeed similar to iteration in imperative
languages.

Let's rewrite factorial one more time, now using a new construct called
`recur`. `recur` means "recursively call this function (that we're in)", with
the additional restriction that the recursion must be tail recursion.

~~~ {.clojure}
(defn recur-factorial [number]
  (let [helper (fn [acc n]
                 (if (zero? n)
                   acc
                   (recur (* acc n) (dec n))))]
    (helper 1 number)))
~~~

Here we've replaced the recursive call `helper` with `recur`. Since `recur` can
only occur in a tail position (that is, a call whose return value is directly
returned), the compiler _knows_ the recursion is actually iteration, and can
compile it into a simple loop. This is called _tail-call optimization_.

Again, because `recur` guarantees tail-call optimization, it can be present
_only_ in a tail position. While this might seem awkward, it's an advantage
too. When we've placed `recur` in a non-tail position where Clojure can not
perform tail-call optimization, the compiler will give us an error. This
indicates that our request to optimize the tail call is not possible. If the
compiler allowed `recur` outside tail positions (and simply performed regular
recursion), we would not know whether tail-call optimization actually took
place or not.

In short: `recur` _guarantees_ tail-call optimization by _requiring_ that the
call to it is in an optimizable position.

<exercise>
Write the function `(power n k)` that computes the mathematical expression
$n^k$.

~~~ {.clojure}
(power 2 2)  ;=> 4
(power 5 3)  ;=> 125
(power 7 0)  ;=> 1
(power 0 10) ;=> 0
~~~
</exercise>

<exercise>
Compute the last element of a sequence.

~~~ {.clojure}
(last-element [])      ;=> nil
(last-element [1 2 3]) ;=> 3
(last-element [2 5])   ;=> 5
~~~
</exercise>

Because defining the sort of helper functions like `helper` in our `factorial`
is quite usual in functional programming, there is a utility called `loop` for
this. The previous code could be written like this:

~~~ {.clojure}
(defn loopy-factorial [down-from]
  (loop [acc 1
         n down-from]
    (if (zero? n)
      acc
      (recur (* acc n) (dec n)))))
~~~

Let's dissect that. A `loop` begins with a sequence of _bindings_, just like
in a `let`.

~~~ {.clojure}
  (loop [acc 1
         n down-from]
~~~

This introduces the variables `acc` and `n` and gives them initial values. `n`
gets its value from the parameter `loopy-factorial`.

After this comes the body of the loop, which is exactly the same as the body
of the `helper` function above:

~~~ {.clojure}
    (if (zero? n)
      acc
      (recur (* acc n) (dec n)))))
~~~

Inside a `loop` we can think of a `recur` meaning "go to the start of the
loop, and give the variables these new values". So after that `recur` call the
variable `n` gets the new value `(dec n)`, and `acc` gets the new value `(* n
acc)`. That is, calling `recur` either calls the function iteratively, or
iterates a `loop`, whichever is innermost.

This kind of corresponds to the following Java loop (if you want to look at it
that way):

~~~ {.clojure}
int n = number;
int acc = 1;
while (true) {
    if (n <= 1) {
        break;
    } else {
        acc = n * acc;
        n = n - 1;
    }
}
return acc;

~~~

<exercise>
Write the function `(seq= a-seq b-seq)` that compares two sequences for equality.

~~~ {.clojure}
(seq= [1 2 4] '(1 2 4))  ;=> true
(seq= [1 2 3] [1 2 3 4]) ;=> false
(seq= [1 3 5] [])        ;=> false
~~~
</exercise>

<exercise>
Implement the function `(find-first-index [f seq])` that returns the first
index in `seq` for which `f` returns true, or `nil` if no such index exists.

~~~ {.clojure}
(find-first-index zero? [1 1 1 0 3 7 0 2])            ;=> 3
(find-first-index zero? [1 1 3 7 2])                  ;=> nil
(find-first-index #(= % 6) [:cat :dog :six :blorg 6]) ;=> 4
(find-first-index nil? [])                            ;=> nil
~~~

</exercise>

<exercise>
Implement the function `(avg a-seq)` that computes the average of a sequence.

~~~ {.clojure}
(avg [1 2 3])   ;=> 2
(avg [0 0 0 4]) ;=> 1
(avg [1 0 0 1]) ;=> 1/2 ;; or 0.5
~~~

_Hint:_ You need to keep track of two things in the loop.
</exercise>

<exercise>
Write the function `(parity a-seq)` that takes in a sequence and returns a
*set* of those elements that occur an odd number of times in the sequence.

~~~ {.clojure}
(parity [:a :b :c])           ;=> #{:a :b :c}
(parity [:a :b :c :a])        ;=> #{:b :c}
(parity [1 1 2 1 2 3 1 2 3 4] ;=> #{2 4}
~~~

_Hint:_ Recall the fuction `(toggle set elem)` from
[Structured data](structured-data.html#toggle)

~~~clojure
(toggle #{1 2 3} 1) ;=> #{2 3}
(toggle #{2 3} 1) ;=> #{1 2 3}
~~~

</exercise>

<exercise>
Write the function `(fast-fibo n)` that computes the `n`th fibonacci number
using `loop` and `recur`. Do not use recursion.

~~~ {.clojure}
(fast-fibo 0) ;=> 0
(fast-fibo 1) ;=> 1
(fast-fibo 2) ;=> 1
(fast-fibo 3) ;=> 2
(fast-fibo 4) ;=> 3
(fast-fibo 5) ;=> 5
(fast-fibo 6) ;=> 8
~~~

_Hint:_ to avoid recursion, you need to keep track of $F_{n-1}$ and $F_n$ in the
loop.

</exercise>

<exercise>
Write the function `(cut-at-repetition a-seq)` that takes in a sequence and
returns elements from the sequence up to the first repetition.

~~~ {.clojure}
(cut-at-repetition [1 1 1 1 1])
;=> [1] doesn't have to be a vector, a sequence is fine too
(cut-at-repetition [:cat :dog :house :milk 1 :cat :dog])
;=> [:cat :dog :house :milk 1]
(cut-at-repetition [0 1 2 3 4 5])
;=> [0 1 2 3 4 5]
~~~

_Hint:_ Remember that `conj`ing onto a vector appends the element.

_Hint:_ You can search in a sequence with `some`.
</exercise>

## Performance viewpoint

Tail recursion is efficient. This is because the compiler can replace it with
a goto (this is called _tail-call optimisation_. So a tail-recursive function
is about exactly as fast as the corresponding loop.

However, this doesn't exactly apply in the Java Virtual Machine. This is
because the security model of the JVM makes tail-call optimisation hard. This
is why Clojure uses the `recur` construct: it is _guaranteed_ that a call to
`recur` gets optimised. I'll say that again. When you use `recur`, Clojure
generates an _actual loop_ as JVM bytecode.

[recursion]: recursion.html

