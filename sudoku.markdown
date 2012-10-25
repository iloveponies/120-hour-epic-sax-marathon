% Sudoku
% 120 hour epic
% sax marathon

## Synopsis


## Get the project

~~~
git clone https://github.com/iloveponies/sudoku.git
~~~

<!-- TODO?
  - not=
-->

## Fight!

First of all, we need to have a representation for sudoku boards. Here is one.

~~~ {.clojure}
(board [[5 3 0 0 7 0 0 0 0]
        [6 0 0 1 9 5 0 0 0]
        [0 9 8 0 0 0 0 6 0]
        [8 0 0 0 6 0 0 0 3]
        [4 0 0 8 0 3 0 0 1]
        [7 0 0 0 2 0 0 0 6]
        [0 6 0 0 0 0 2 8 0]
        [0 0 0 4 1 9 0 0 5]
        [0 0 0 0 8 0 0 7 9]])
~~~

Here `0` is used to encode an empty square in a sudoku board.

The `board` function is intended to transform a nested vector structure to
some internal representation. Since these nested vectors work just fine for
now, `board` doesn't have to do anything.

The standard library defines a function called `identity` that just returns
its parameter:

~~~ {.clojure}
(identity 13) ;=> 13
(identity ":)") ;=> ":)"
~~~

Using `identity`, we can define `board` easily:

~~~ {.clojure}
(def board identity)
~~~

You're going to need the set of numbers used in sudoku often, so let's define
them as a set:

~~~ {.clojure}
(def all-values #{1 2 3 4 5 6 7 8 9})
~~~

In sudoku, one needs to fill a board so that every line, every column and
every block has the numbers from 1 to 9 exactly once. Blocks are 3x3 areas
inside the sudoku board.

~~~ {.clojure}
;[[5 3 0 | 0 7 0 | 0 0 0]
; [6 0 0 | 1 9 5 | 0 0 0]
; [0 9 8 | 0 0 0 | 0 6 0]
; -------+-------+-------
; [8 0 0 | 0 6 0 | 0 0 3]
; [4 0 0 | 8 0 3 | 0 0 1]
; [7 0 0 | 0 2 0 | 0 0 6]
; -------+-------+-------
; [0 6 0 | 0 0 0 | 2 8 0]
; [0 0 0 | 4 1 9 | 0 0 5]
; [0 0 0 | 0 8 0 | 0 7 9]]
~~~

## Working with nested structures

Getting values from nested structures with `get` gets ugly:

~~~ {.clojure}
(get (get [["a" "b"] ["c" "d"]] 0) 1)
;=> (get ["a" "b"] 1)
;=> "b"
~~~

To remedy this, there is `(get-in nested-structure directives)`

~~~ {.clojure}
(get-in [["a" "b"] ["c" "d"]] [0 1])
;=> (get (get [["a" "b"] ["c" "d"]] 0) 1)
;=> (get ["a" "b"]                     1)
;=> "b"
~~~

It works with everything that supports get, including maps and vectors.

~~~ {.clojure}
(def cities {:title "The City and the City"
             :author {:name "China Miéville"
                      :birth-year 1972}})

(get-in cities [:author :name])
;=> (get (get cities :author)                       :name)
;=> (get {:name "China Miéville", :birth-year 1972} :name)
;=> "China Miéville"
~~~

There are two other functions for dealing with nested structures, `assoc-in`
and `update-in`. We will talk about `assoc-in` in a bit.

Here is an example sudoku board together with its solution:

~~~ {.clojure}
(def sudoku-board
  (board [[5 3 0 0 7 0 0 0 0]
          [6 0 0 1 9 5 0 0 0]
          [0 9 8 0 0 0 0 6 0]
          [8 0 0 0 6 0 0 0 3]
          [4 0 0 8 0 3 0 0 1]
          [7 0 0 0 2 0 0 0 6]
          [0 6 0 0 0 0 2 8 0]
          [0 0 0 4 1 9 0 0 5]
          [0 0 0 0 8 0 0 7 9]]))

(def solved-board
  (board [[5 3 4 6 7 8 9 1 2]
          [6 7 2 1 9 5 3 4 8]
          [1 9 8 3 4 2 5 6 7]
          [8 5 9 7 6 1 4 2 3]
          [4 2 6 8 5 3 7 9 1]
          [7 1 3 9 2 4 8 5 6]
          [9 6 1 5 3 7 2 8 4]
          [2 8 7 4 1 9 6 3 5]
          [3 4 5 2 8 6 1 7 9]]))
~~~

<exercise>
Write the function `(value-at board coordinates)` that returns the value at
`coordinate` in `board`:

~~~ {.clojure}
(value-at sudoku-board [0 1]) ;=> 3
(value-at sudoku-board [0 0]) ;=> 5
~~~
</exercise>

<exercise>
Write the function `(has-value? board coordinates)` that returns `false` if
the square at `coordinates` is empty (has `0`), and otherwise `true`.

~~~ {.clojure}
(has-value? sudoku-board [0 0]) ;=> true
(has-value? sudoku-board [0 2]) ;=> false
~~~
</exercise>

Now we can check if square is empty. To figure out which numbers are valid for
a square we need to know which are already taken. Let's write a couple of
functions to figure this out.

<exercise>
Write the function `(row-values board coordinates)` that returns a set with
all numbers on the row of the coordinates

Remember that you can use destructing inside the parameter vector to get the
row.

~~~ {.clojure}
(row-values sudoku-board [0 2]) ;=> #{0 5 3 7}
(row-values sudoku-board [3 2]) ;=> #{0 8 6 3}
~~~
</exercise>

<exercise>
Write the function `(col-values board coordinates)` that returns a set with
all numbers on the col of the coordinates

~~~ {.clojure}
(col-values sudoku-board [0 2]) ;=> #{0 8}
(col-values sudoku-board [4 8]) ;=> #{3 1 6 0 5 9}
~~~
</exercise>

Finally, we need to figure out what numbers are inside the block of a square.

To make working with blocks a little easier, let's take a small detour.

You can use `for` to go through a sequence like with `map`:

~~~ {.clojure}
(for [number [1 2 3]]
  (+ number 2))
;=> (3 4 5)
~~~

Here the name `number` gets bound to each value of the sequence `[1 2 3]` one
by one. For each value, evaluate the body `(+ number 2)` with it and collect
the results into a sequence.

But you can give `for` multiple bindings, and it will go through all
combinations:

~~~ {.clojure}
(for [name ["John" "Jane"]
      number [1 2 3]]
  (str name " " number))
;=> ("John 1" "John 2" "John 3" "Jane 1" "Jane 2" "Jane 3")
~~~

If you happen to be familiar with list comprehensions from some other
language, `for` is a Clojures list comprehension form.

To make working with coordinates a bit easier, let's write a function that
returns a sequence of coordinate pairs.

<exercise>
Write the function `(coord-pairs coord-sequence)` that returns all
coordinate-pairs of the form `[row col]` where `row` is from `coord-sequence`
and `col` is from `coord-sequence`.

~~~ {.clojure}
(coord-pairs [0 1])   ;=> [[0 0] [0 1]
                      ;    [1 0] [1 1]]

(coord-pairs [0 1 2]) ;=> [[0 0] [0 1] [0 2]
                      ;    [1 0] [1 1] [1 2]
                      ;    [2 0] [2 1] [2 2]]
~~~
</exercise>

<exercise>
Write the function `(block-values board coordinates)` that returns a set with
all numbers in the block of `coordinates`.

You might want to write a helper function that returns the coordinates for the
top left corner of the block.

~~~ {.clojure}
(block-values sudoku-board [0 2]) ;=> #{0 5 3 6 8 9}
(block-values sudoku-board [4 5]) ;=> #{0 6 8 3 2}
~~~
</exercise>

The `clojure.set` namespace has some useful functions for working with sets.
`(clojure.set/union set1 set2 ...)` returns a set containing all the elements
of its arguments:

~~~ {.clojure}
(clojure.set/union #{1 2} #{2 3} #{7}) ;=> #{1 2 3 7}
~~~

In the project file, `clojure.set` is required with the shorthand `set`, so
you can also just write:

~~~ {.clojure}
(set/union #{1 2} #{2 3} #{7}) ;=> #{1 2 3 7}
~~~

Another helpful set operation is `(set/difference set1 set2)`, which returns a
set with all elements of `set1` except those that are also in `set2`. Or put
another way, removes all elements of `set2` from `set1`:

~~~ {.clojure}
(set/difference #{1 2 3} #{1 3})   ;=> #{2}
(set/difference #{1 2 3} #{2 4 5}) ;=> #{1 3}
~~~

<exercise>
Write the function `(valid-values board coordinates)` that returns a set with
all valid numbers for the square at `coordinates`.

If the square at `coordinates` already has a value, `valid-values` should
return the empty set `#{}`.

Remember that we already defined the set `all-values`.

~~~ {.clojure}
(valid-values-for sudoku-board [0 0]) ;=> #{}
(valid-values-for sudoku-board [0 2]) ;=> #{1 2 4})
~~~
</exercise>

Next, let's write a function to figure out if a sudoku board is completely
filled.

<exercise>
Write the function `(filled? board)` which returns `true` if there are no
empty squares in `board`, and otherwise `false`.

It might help to write a helper function that returns all numbers of the board
in a sequence.

Remember that `(contains? set element)` can be used to check if `element` is
in `set`.

~~~ {.clojure}
(filled? sudoku-board) ;=> false
(filled? solved-board) ;=> true
~~~
</exercise>

Now that we can check if a board is full, it would be nice to know the
solution is valid.

A sudoku is valid if each row, each column and each block contains the numbers
from 1 to 9 exactly once. Let's write functions for checking each of these
conditions.

To start, let's write some functions to get the values for each row, column
and block.


<exercise>
Write the function `(rows board)` that returns a sequence of value sets for
each row of `board`. That is, the first set in `(rows board)` is a set that
has every element of the first row of `board` as element and so on.

~~~{.clojure}
(rows sudoku-board) ;=> [#{5 3 0 7}
                    ;    #{6 0 1 9 5}
                    ;    #{0 9 8 6}
                    ;    #{8 0 6 3}
                    ;    #{4 0 8 3 1}
                    ;    #{7 0 2 6}
                    ;    #{0 6 2 8}
                    ;    #{0 4 1 9 5}
                    ;    #{0 8 7 9}]

(rows solved-board) ;=> [#{1 2 3 4 5 6 7 8 9}
                    ;    #{1 2 3 4 5 6 7 8 9}
                    ;    #{1 2 3 4 5 6 7 8 9}
                    ;    #{1 2 3 4 5 6 7 8 9}
                    ;    #{1 2 3 4 5 6 7 8 9}
                    ;    #{1 2 3 4 5 6 7 8 9}
                    ;    #{1 2 3 4 5 6 7 8 9}
                    ;    #{1 2 3 4 5 6 7 8 9}
                    ;    #{1 2 3 4 5 6 7 8 9}]
~~~

Write the function `(cols board)` that returns the values of each column in
`board` as a sequence of sets.

~~~{.clojure}
(cols sudoku-board) ;=> [#{5 6 0 8 4 7}
                    ;    #{3 0 9 6}
                    ;    #{0 8}
                    ;    #{0 1 8 4}
                    ;    #{7 9 0 6 2 1 8}
                    ;    #{0 5 3 9}
                    ;    #{0 2}
                    ;    #{0 6 8 7}
                    ;    #{0 3 1 6 5 9}]

(cols solved-board) ;=> [#{1 2 3 4 5 6 7 8 9}
                    ;    #{1 2 3 4 5 6 7 8 9}
                    ;    #{1 2 3 4 5 6 7 8 9}
                    ;    #{1 2 3 4 5 6 7 8 9}
                    ;    #{1 2 3 4 5 6 7 8 9}
                    ;    #{1 2 3 4 5 6 7 8 9}
                    ;    #{1 2 3 4 5 6 7 8 9}
                    ;    #{1 2 3 4 5 6 7 8 9}
                    ;    #{1 2 3 4 5 6 7 8 9}]
~~~
</exercise>

<exercise>
Write the function `(blocks board)` that returns the values of each block in
`board` as a sequence of sets.

~~~{.clojure}
(blocks sudoku-board) ;=> [#{5 3 0 6 9 8}
                      ;    #{0 7 1 9 5}
                      ;    #{0 6}
                      ;    #{8 0 4 7}
                      ;    #{0 6 8 3 2}
                      ;    #{0 3 1 6}
                      ;    #{0 6}
                      ;    #{0 4 1 9 8}
                      ;    #{2 8 0 5 7 9}]

(blocks solved-board) ;=> [#{1 2 3 4 5 6 7 8 9}
                      ;    #{1 2 3 4 5 6 7 8 9}
                      ;    #{1 2 3 4 5 6 7 8 9}
                      ;    #{1 2 3 4 5 6 7 8 9}
                      ;    #{1 2 3 4 5 6 7 8 9}
                      ;    #{1 2 3 4 5 6 7 8 9}
                      ;    #{1 2 3 4 5 6 7 8 9}
                      ;    #{1 2 3 4 5 6 7 8 9}
                      ;    #{1 2 3 4 5 6 7 8 9}])
~~~
</exercise>

Now we can get the values used in every row, column and block. Let's write
functions that check if every row, column and block is valid as per the rules
of sudoku.

<exercise>
Write the function `(valid-rows? board)` that returns `true` if every row in
`board` is a valid filled row.

~~~{.clojure}
(valid-rows? solved-board)  ;=> truthy
(valid-rows? invalid-board) ;=> falsey
~~~

Write the function `(valid-cols? board)` that returns `true` if every row in
`board` is a valid filled column.

~~~{.clojure}
(valid-cols? solved-board)  ;=> truthy
(valid-cols? invalid-board) ;=> falsey
~~~

Write the function `(valid-blocks? board)` that returns `true` if every block
in `board` is a valid filled block.

~~~{.clojure}
(valid-blocks? solved-board)  ;=> truthy
(valid-blocks? invalid-board) ;=> falsey
~~~
</exercise>

Finally, we can write a function that checks if the whole board is a valid
solution.

<exercise>
Write the function `(valid-solution? board)` that returns `true` if `board` is
a valid solution to sudoku.

~~~{.clojure}
(valid-solution? solved-board)  ;=> truthy
(valid-solution? invalid-board) ;=> falsey)
~~~
</exercise>

Now we can verify whether or not a solution is valid. However, if we want to
actually solve a sudoku, we need to be able to modify a partial solution.

Earlier we saw how useful `get-in` can be when indexing nested structures.
Theres a similar function for changing nested structures, called `assoc-in`.
`(assoc-in nested-structure path new-value)` changes the value pointed by
`path`, which is a sequence of keys. Here's an example:

~~~{.clojure}
 (assoc-in [[:a :b] [:c :d]] [1                                  0] :E)
;=> (assoc [[:a :b] [:c :d]]  1 (assoc (get [[:a :b] [:c :d]] 1) 0  :E))
;=> (assoc [[:a :b] [:c :d]]  1 (assoc               [:c :d]     0  :E))
;=> (assoc [[:a :b] [:c :d]]  1 [:E :d])
;=>        [[:a :b] [:E :d]]
~~~

Now we can write a function to change a single value in our representation of
a sudoku.

<exercise>
Write the function `(set-value-at board coord new-value)` that changes the
value at `coord` in `board` to `new-value`.

~~~{.clojure}
(def before-change
  (board [[5 3 0 0 7 0 0 0 0]
          [6 0 0 1 9 5 0 0 0]
          [0 9 8 0 0 0 0 6 0]
          [8 0 0 0 6 0 0 0 3]
          [4 0 0 8 0 3 0 0 1]
          [7 0 0 0 2 0 0 0 6]
          [0 6 0 0 0 0 2 8 0]
          [0 0 0 4 1 9 0 0 5]
          [0 0 0 0 8 0 0 7 9]]))

(def after-change
  (board [[5 3 0 0 7 0 0 0 0]
          [6 0 0 1 9 5 0 0 0]
          [0 4 8 0 0 0 0 6 0]
          [8 0 0 0 6 0 0 0 3]
          [4 0 0 8 0 3 0 0 1]
          [7 0 0 0 2 0 0 0 6]
          [0 6 0 0 0 0 2 8 0]
          [0 0 0 4 1 9 0 0 5]
          [0 0 0 0 8 0 0 7 9]]))

(set-value-at before-change [2 1] 4)
~~~
</exercise>

Now that we can change the board, the next obstacle is figuring out what to
change. Now we need to find an empty point in the sudoku board.

<exercise>
Write the function `(find-empty-point board)` that returns coordinates to an
empty point (that is, in our representation has value $0$).
</exercise>

Okay, so now we can find an empty location and we also know what the valid
values for that location are. What's left is to try each one of those values
in that location and trying to solve the rest. This is called backtracking
search. You try one choice and recurse, if the recursive call didn't find any
solutions, try the next choice. If none of the choices return a valid
solution, return `nil`.

Let's take a small detour and see an example of backtracking search.

### Subset Sum

Subset sub is a classic problem. Here's how it goes. You are given:

- a set of numbers, like `#{1 2 10 5 7}`
- and a number, say `23`

and you want to know if there is some subset of the original set that sums up
to the target. We're going to solve this by brute force using a backtracking
search.

Here's one way to implement it:

~~~{.clojure}
(defn sum [a-seq]
  (reduce + a-seq))

(defn subset-sum-helper [a-set current-set target]
  (if (= (sum current-set) target)
    [current-set]
    (let [remaining (clojure.set/difference a-set current-set)]
      (for [elem remaining
            solution (subset-sum-helper a-set
                                        (conj current-set elem)
                                        target)]
        solution))))

(defn subset-sum [a-set target]
  (subset-sum-helper a-set #{} target))
~~~

So the main thing happens inside `subset-sum-helper`. First of all, always
check if we have found a valid solution. Here it's checked with

~~~{.clojure}
  (if (= (sum current-set) target)
    [current-set]
~~~

If we have found a valid solution, return it in a vector (We'll see soon why
in a vector). Okay, so if we're not done yet, what are our options? Well, we
need to try adding some element of `a-set` into `current-set` and try again.
What are the possible elements for this? They are those that are not yet in
`current-set`. Those are bound to the name `remaining` here:

~~~{.clojure}
    (let [remaining (clojure.set/difference a-set current-set)]
~~~

What's left is to actually try calling `subset-sum-helper` with each new set
obtainable in this way:

~~~{.clojure}
      (for [elem remaining
            solution (subset-sum-helper a-set
                                        (conj current-set elem)
                                        target)]
        solution))))
~~~

Here first `elem` gets bound to the elements of `remaining` one at a time. For
each `elem`, `solution` gets bound to each element of the recursive call

~~~{.clojure}
            solution (subset-sum-helper a-set
                                        (conj current-set elem)
                                        target)]
~~~

And this is the reason we returned a vector in the base case, so that we can
use `for` in this way. Finally, we return each such `solution` in a sequence.

So let's try this out:

~~~{.clojure}
    (subset-sum #{1 3 4 10 9 23} 20)
;=> (#{1 9 10} #{1 9 10} #{1 9 10} #{1 9 10} #{1 9 10} #{1 9 10})
~~~

Okay, so the above example is not exactly optimal. It forms each set many
times. Since we were only interested in one solution, however, we can just add
`first` to the call if the helper:

~~~{.clojure}
(defn subset-sum [a-set target]
  (first (subset-sum-helper a-set #{} target)))
~~~

And due to the way Clojure uses laziness, this actually cuts the computation
after a solution is found (well, to be exact, after 32 solutions have been
found due to the way Clojure chunks lazy sequences).

### Solving Sudokus

It's finally time to write the search for a solution to sudokus.

<exercise>
Write the function `(solve board)` which takes a sudoku board as a parameter
and returns a valid solution to the given sudoku.

~~~{.clojure}
  (solve sudoku-board) => solved-board)
~~~

Recap of backtracking:

- check if you are at the end
  - if so, is the solution valid?
    - if not, return an empty sequence
    - otherwise return `[solution]`
  - if not
    - select an empty location
    - try solving with each valid value for that location
</exercise>
