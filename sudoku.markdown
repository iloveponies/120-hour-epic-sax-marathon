% Sudoku
% 120 hour epic
% sax marathon

## Synopsis

<alert>Work in progress!</alert>

## Get the project

~~~
git clone https://github.com/iloveponies/sudoku.git
~~~

- not=
- every?
- working with nested structures
    - get-in
    - assoc-in
- for
    - multiple sequences
    - :when
    - :let
- backtracking
- clojure/set
    - union
    - difference
    - set equality
    - contains
    
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

But you can give `for` multiple bindings, and it will go through all
combinations:

~~~ {.clojure}
(for [name ["John" "Robert"]
      number [1 2 3]]
  (str name " " number))
;=> ("John 1" "John 2" "John 3" "Robert 1" "Robert 2" "Robert 3")
~~~

To make working with coordinates a bit easier, lets write a function that
returns a sequence of coordinate pairs.

<exercise>
Write the function `(coord-pairs coord-sequence)` that returns all
coordinate-pairs of the form `[row col]` where `row` is from `coord-sequence`
and `col` is from `coord-sequence`.

~~~ {.clojure}
(coord-pairs [0 1])   ;=> [[0 0] [0 1]
                      ;   [1 0] [1 1]]

(coord-pairs [0 1 2]) ;=> [[0 0] [0 1] [0 2]
                      ;   [1 0] [1 1] [1 2]
                      ;   [2 0] [2 1] [2 2]]
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

Next, let's write write a function to figure out if a sudoku is completely
filled.

<exercise>
Write the function `(filled? board)` which returns `true` if there are no
empty squares in `board`, and otherwise `false`.

It might help to write a helper function that returns all numbersof the board
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
