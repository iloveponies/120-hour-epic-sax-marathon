% P-P-P-Pokerface
% 120 hour epic
% sax marathon

## Synopsis

Here we'll implement a poker hand evaluator in Clojure.

- frequencies
- range
- min/max, apply max
- sort
- Character/isDigit, character->int
- sequence equality
- first

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
string representation, including character.

~~~ {.clojure}
(str \C) ;=> "C"
~~~

You should now be able to write the `(suit card)` function that returns the
suit of a card.

<exercise>
Write the function `(suit card)` which takes a singe card and return the suit
of the card as a one character string.

~~~ {.clojure}
(suit "2H") ;=> "H"
(suit "2D") ;=> "D"
(suit "2C") ;=> "C"
(suit "3S") ;=> "S"
~~~
</exercise>

To get rank, you'll need to convert a character into an integer. To see if a
character is a digit, like `\5` or `\2`, you can use
`(Character/isDigit char)`:

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

Finally, to turn the other characters into integers, using a map to store the
values is very useful:

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

So here we had three sevens and two fours.

If you are only interested in the keys or values of a map, you can get them
with `(keys a-map)` and `(vals a-map)`:

~~~ {.clojure}
(vals (frequencies [4 7 7 4 7]))
;=> (2 3)
;^-- now that looks a lot like a full house
~~~

`(max num1 num2 num3 ...)` returns its largest parameter and `(min num1 num2
nun3 ...)` returns its smallest paremeter.

~~~ {.clojure}
(max 1 5 4 2) ;=> 5
(min 1 5 4 2) ;=> 1
~~~

But what should you do if you have a sequence of numbers, like say a vector
`[1 -4 2 3 5]` and you want its smallest or largest value? There is a very
useful spesial form called `apply` for this
`(apply function parameter-sequence)` which calls `function` with the
parameters from `parameter-sequence`.

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

Okay, so that's quite a lot to remember, but these should provide useful when
detecting different hands. If you get stuck, the functions introduced above
might help.

## Hands

If you don't remember a hand, the [Poker hands article][PokerHand] at
Wikipedia has them listed and explained.

Our representation for a poker hand is simply going to be a vector of cards:

~~~ {.clojure}
(def high-seven ["2H" "3S" "4C" "5C" "7D"])
~~~

Here's a bunch of hands to use for testing:

~~~
(def high-seven ["2H" "3S" "4C" "5C" "7D"])
(def pair-hand ["2H" "2S" "4C" "5C" "7D"])
(def two-pairs-hand ["2H" "2S" "4C" "4D" "7D"])
(def three-of-a-kind-hand ["2H" "2S" "2C" "4D" "7D"])
(def four-of-a-kind-hand ["2H" "2S" "2C" "2D" "7D"])
(def straight-hand ["2H" "3S" "6C" "5D" "4D"])
(def low-ace-straight-hand ["2H" "3S" "4C" "5D" "AD"])
(def high-ace-straight-hand ["TH" "AS" "QC" "KD" "JD"])
(def flush-hand ["2H" "4H" "5H" "9H" "7H"])
(def full-house-hand ["2H" "5D" "2D" "2C" "5S"])
(def straight-flush-hand ["2H" "3H" "6H" "5H" "4H"])
(def low-ace-straight-flush-hand ["2D" "3D" "4D" "5D" "AD"])
(def high-ace-straight-flush-hand ["TS" "AS" "QS" "KS" "JS"])
~~~

<exercise>
Write the function `(pair? hand)` that return true if there is a pair in
`hand` and false if there is no pair in `hand`.

~~~
(pair? pair-hand)  ;=> true
(pair? high-seven) ;=> false
~~~
</exercise>

[PokerHand]: http://en.wikipedia.org/wiki/Poker_hands
