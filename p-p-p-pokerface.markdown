% P-P-P-Pokerface
% 120 hour epic
% sax marathon

## Synopsis

Here we'll implement a poker hand evaluator in Clojure.

## Get the project

Clone the project for this chapter:

~~~
git clone https://github.com/iloveponies/p-p-p-pokerface.git
~~~

## Data representation

A traditional playing card has a rank and a suit. The rank is a number
from 2 to 10, J, Q, K or A and the suit is Clubs, Diamonds, Hearts or Spades.

We want a simple way to represent poker hands and cards. A card is simply
going to be a string of the form `"5C"` where the first character represents
the rank and the second character represents the suit. To keep the
representation as 2 characters, we'll use the following coding for values
between 10 and 14:

Rank    Character
----    ---------
10      T
11      J
12      Q
13      K
14      A

So, for example, the Queen of Hearts is `"QH"` and the Ace of Spades is "AS".

## Rank and suit

We'll want a couple of helper functions to read the rank and suit of a card.

A useful thing to note is that Strings are sequencable, so you can use
sequence destructuring on them:

~~~ {.clojure}
(let [[fst snd] "5H"]
  [fst snd]) ;=> [\5 \H]
~~~

If you are only interested in some destructured values, it is idiomatic to use
the name `_` for ignored values:

~~~ {.clojure}
(let [[_ snd] "AH"]
  snd) ;=> \H
~~~

And finally, remember that you can use `(str value)` to turn anything into its
string representation, including characters.

~~~ {.clojure}
(str \C) ;=> "C"
~~~

You should now be able to write the `(suit card)` function that returns the
suit of a card.

<exercise>
Write the function `(suit card)` which takes a singe card and returns the suit
of the card as a one character string.

~~~ {.clojure}
(suit "2H") ;=> "H"
(suit "2D") ;=> "D"
(suit "2C") ;=> "C"
(suit "3S") ;=> "S"
~~~
</exercise>

To get the rank, you'll need to convert a character into an integer. To see if
a character is a digit, like `\5` or `\2`, you can use `(Character/isDigit
char)`:

~~~ {.clojure}
(Character/isDigit \5) ;=> true
(Character/isDigit \A) ;=> false
~~~

If a character is a digit, you can use `(Integer/valueOf string)` to convert
it to an integer. You will first have to convert the character into a string.

~~~ {.clojure}
(Integer/valueOf "12")     ;=> 12
(Integer/valueOf (str \5)) ;=> 5
~~~

Finally, to turn the characters `T`, `J`, `Q`, `K` and `A` into integers,
using a map to store the values is very useful:

~~~ {.clojure}
(get {\A 100, \B 20} \B) ;=> 20
({\A 100, \B 20} \B) ;=> 20

(def replacements {\A 100, \B 20})

(replacements \B) ;=> 20
~~~

You can now write the `(rank card)` function.

<exercise>
Write the function `(rank card)` which takes a single card and returns the
rank as a number between 2 and 14.

~~~ {.clojure}
(rank "2H") ;=> 2
(rank "4S") ;=> 4
(rank "TS") ;=> 10
(rank "JS") ;=> 11
(rank "QS") ;=> 12
(rank "KS") ;=> 13
(rank "AS") ;=> 14
~~~
</exercise>

## Some additional functions

Here's a couple of functions that should prove useful.

`(frequencies sequence)` is used to see how many times an element appears in a
sequence. It returns a map where elements are mapped to their appearance
counts:

~~~ {.clojure}
(frequencies [4 7 7 4 7]) ;=> {4 2, 7 3}
~~~

In this case, we had three sevens and two fours.

If you are only interested in the keys or values of a map, you can get them
with `(keys a-map)` and `(vals a-map)`:

~~~ {.clojure}
(vals (frequencies [4 7 7 4 7]))
;=> (2 3)
;   ^-- now that looks a lot like a full house
~~~

`(max num1 num2 num3 ...)` returns its largest parameter and `(min num1 num2
num3 ...)` returns its smallest paremeter.

~~~ {.clojure}
(max 1 5 4 2) ;=> 5
(min 1 5 4 2) ;=> 1
~~~

But what should you do if you have a sequence of numbers, like the vector `[1
-4 2 3 5]`, and you want its smallest or largest value? There is a very useful
special form called `apply` for this: `(apply function parameter-sequence)`
calls `function` with the parameters from `parameter-sequence`.

~~~ {.clojure}
(apply str ["Over " 9000 "!"])
;=> (str "Over " 9000 "!")
;=> "Over 9000!"
~~~

~~~ {.clojure}
(apply max [5 3 2])
;=> (max 5 3 2)
;=> 5
~~~

That's quite a lot to remember, but these should provide useful when detecting
different hands. If you get stuck, the functions introduced above might help.

## Hands

If you don't remember a hand, the [Poker hands article][PokerHand] at
Wikipedia has them listed and explained.

Our representation for a poker hand is simply a vector of cards:

~~~ {.clojure}
(def high-seven ["2H" "3S" "4C" "5C" "7D"])
~~~

Here's a bunch of hands to use for testing:

~~~ {.clojure}
(def high-seven                   ["2H" "3S" "4C" "5C" "7D"])
(def pair-hand                    ["2H" "2S" "4C" "5C" "7D"])
(def two-pairs-hand               ["2H" "2S" "4C" "4D" "7D"])
(def three-of-a-kind-hand         ["2H" "2S" "2C" "4D" "7D"])
(def four-of-a-kind-hand          ["2H" "2S" "2C" "2D" "7D"])
(def straight-hand                ["2H" "3S" "6C" "5D" "4D"])
(def low-ace-straight-hand        ["2H" "3S" "4C" "5D" "AD"])
(def high-ace-straight-hand       ["TH" "AS" "QC" "KD" "JD"])
(def flush-hand                   ["2H" "4H" "5H" "9H" "7H"])
(def full-house-hand              ["2H" "5D" "2D" "2C" "5S"])
(def straight-flush-hand          ["2H" "3H" "6H" "5H" "4H"])
(def low-ace-straight-flush-hand  ["2D" "3D" "4D" "5D" "AD"])
(def high-ace-straight-flush-hand ["TS" "AS" "QS" "KS" "JS"])
~~~

<exercise>
Write the function `(pair? hand)` that returns `true` if there is a pair in
`hand` and `false` if there is no pair in `hand`.

~~~
(pair? pair-hand)  ;=> true
(pair? high-seven) ;=> false
~~~
</exercise>

<exercise>
Write the function `(three-of-a-kind? hand)` that returns `true` if the hand
contains a three of a kind.

~~~ {.clojure}
(three-of-a-kind? two-pairs-hand)       ;=> false
(three-of-a-kind? three-of-a-kind-hand) ;=> true
~~~
</exercise>

<exercise>
Write the function `(four-of-a-kind? hand)` that returns `true` if the hand
contains a four of a kind.

~~~ {.clojure}
(four-of-a-kind? two-pairs-hand)      ;=> false
(four-of-a-kind? four-of-a-kind-hand) ;=> true
~~~
</exercise>

<exercise>
Write the function `(flush hand)` that returns `true` if the hand is a flush.

~~~ {.clojure}
(flush? pair-hand)  ;=> false
(flush? flush-hand) ;=> true)
~~~
</exercise>

`(sort a-seq)` returns a sequence with the elements of `a-seq` in a sorted
order.

~~~ {.clojure}
(sort [5 -1 3 17 -10]) ;=> (-10 -1 3 5 17)
(sort [6 4 5 7 3])     ;=> (3 4 5 6 7)
;                               ^
;                               |
;kind of looks like a straight---
~~~

`(range lower-bound upper-bound)` takes two integers and returns a sequence
with all integers from `lower-bound` to `upper-bound`, but does not include
`upper-bound`.

~~~ {.clojure}
(range 1 5) ;=> (1 2 3 4)
(range 5)   ;=> (0 1 2 3 4)
~~~

You can test for equality between sequences with `=`.

~~~ {.clojure}
(= [3 4 5 6 7] (range 3 (+ 3 5)))
;=> (=  [3       4       5       6       7]
;       (3       4       5       6       7))
;=> (and (= 3 3) (= 4 4) (= 5 5) (= 6 6) (= 7 7))
;=> true

(= [1 2 3] (seq [1 2])) ;=> false
~~~

Two sequences are equal if their elements are equal and in the same order.

<exercise>
Write the function `(full-house? hand)` that returns `true` if `hand` is a
full house, and otherwise `false`.

~~~ {.clojure}
(full-house? three-of-a-kind-hand) ;=> false
(full-house? full-house-hand)      ;=> true
~~~
</exercise>

<exercise>
Write the function `(two-pairs? hand)` that return `true` if `hand` has two
pairs, and otherwise `false`.

Note that a four of a kind is also two pairs.

~~~ {.clojure}
(two-pairs? two-pairs-hand)      ;=> true
(two-pairs? pair-hand)           ;=> false
(two-pairs? four-of-a-kind-hand) ;=> true
~~~
</exercise>

In a straight, an ace is accepted as either 1 or 14, so both of the following
hands have a straight:

~~~ {.clojure}
["2H" "3S" "4C" "5D" "AD"]
["TH" "AS" "QC" "KD" "JD"]
~~~

A useful function here is `(replace replace-map a-seq)`. It takes a map of
replacements and a sequence and replaces the keys of `replace-map` in `a-seq`
with their associated values.

~~~ {.clojure}
(replace {1 "a", 2 "b"} [1 2 3 4]) ;=> ["a" "b" 3 4]
~~~

Finally we can implement `straight?`.

<exercise>
Write the function `(straight? hand)` that returns `true` if `hand` is a
straight, and otherwise `false`.

Note that an ace is accepted both as a rank 1 and rank 14 card in straights.

~~~ {.clojure}
(straight? two-pairs-hand)             ;=> false
(straight? straight-hand)              ;=> true
(straight? low-ace-straight-hand)      ;=> true
(straight? ["2H" "2D" "3H" "4H" "5H"]) ;=> false
(straight? high-ace-straight-hand)     ;=> true
~~~
</exercise>

And finally, there's straight flush. This shouldn't be very difficult after
having already defined flush and straight.

<exercise>
Write the function `(straight-flush? hand)` which returns `true` if the hand
is a straight flush, that is both a straight and a flush, and otherwise
`false`.


~~~ {.clojure}
(straight-flush? straight-hand)                ;=> false
(straight-flush? flush-hand)                   ;=> false
(straight-flush? straight-flush-hand)          ;=> true
(straight-flush? low-ace-straight-flush-hand)  ;=> true
(straight-flush? high-ace-straight-flush-hand) ;=> true
~~~
</exercise>

Now that we have functions that check for each hand type, it would be nice to
be able to assign a value to each hand. We're going to use the following
values:

Hand                  Value
----                  -----
High card (nothing)   0
Pair                  1
Two pairs             2
Three of a kind       3
Straight              4
Flush                 5
Full house            6
Four of a kind        7
Straight flush        8

<exercise>
Write the function `(value hand)`, which returns the value of a hand according
to the table above.

It might be helpful to add a checker `(high-card? hand)`:

~~~ {.clojure}
(defn high-card? [hand]
  true)
~~~

(All hands have a high card.)

And put all checkers into a vector:

~~~ {.clojure}
(def checkers
  [high-card? pair? two-pairs? three-of-a-kind? straight?
   flush? full-house? four-of-a-kind? straight-flush?])
~~~

First, write the function `(hand-has-value? hand value)` that returns `true`
if `hand` has value `value`.

~~~ {.clojure}
(hand-has-value? high-seven 0)           => true
(hand-has-value? pair-hand 1)            => true
(hand-has-value? two-pairs-hand 2)       => true
(hand-has-value? three-of-a-kind-hand 3) => true
(hand-has-value? straight-hand 4)        => true
(hand-has-value? flush-hand 5)           => true
(hand-has-value? full-house-hand 6)      => true
(hand-has-value? four-of-a-kind-hand 7)  => true
(hand-has-value? straight-flush-hand 8)  => true
(hand-has-value? straight-hand 3)        => false
(hand-has-value? straight-hand 1)        => false
(hand-has-value? flush-hand 1)           => false
(hand-has-value? three-of-a-kind-hand 7) => false
~~~

Now the value of a hand is the highest value for which
`(hand-has-value hand value)` returns `true`.

`filter` and `range` might be useful here.

To get all indexes of a vector, or some other sequence, you can use this:

~~~ {.clojure}
(def some-vector [1 2 3])
(range (count some-vector)) ;=> (0 1 2)
~~~

~~~ {.clojure}
(value high-seven)           ;=> 0
(value pair-hand)            ;=> 1
(value two-pairs-hand)       ;=> 2
(value three-of-a-kind-hand) ;=> 3
(value straight-hand)        ;=> 4
(value flush-hand)           ;=> 5
(value full-house-hand)      ;=> 6
(value four-of-a-kind-hand)  ;=> 7
(value straight-flush-hand)  ;=> 8
~~~
</exercise>

## Data representation

Our representation for poker hands is rather simple, but it allows us to use
existing sequence and other functions to work with them. However, the current
API is bound to the representation. This has the unfortunate consequence that
we can not change the internal representation of cards or hands without
changing the external API. There can be good reasons to change the internal
representation, including efficiency.

No worries, this is fixable. Let's create two functions for creating a card
and creating a hand from the representation we already use:

~~~ {.clojure}
(defn hand [a-hand]
  a-hand)

(defn card [a-card]
  a-card)
~~~

Which you would use like this:

~~~ {.clojure}
(card "2H")
(hand ["AH" "AC" "AD" "AS" "4H"])
~~~

While these functions in their current form don't do anything, it allows us to
change the internal representation if we want to. You would use the existing
functions like this:

~~~ {.clojure}
(rank (card "2H")) ;=> 2
(value (hand ["2H" "3H" "4H" "5H" "6H"])) ;=> 4
~~~

And we would now be able to change the internal representation to something
like this, if we wanted to:

~~~ {.clojure}
(card "2H") ;=> {:rank 2, :suit :hearts}
~~~

[PokerHand]: http://en.wikipedia.org/wiki/Poker_hands
