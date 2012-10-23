% Predicates
% 120 hour epic
% sax marathon

## Synopsis

Stuff about predicates and functions as values

## Fork this

[https://github.com/iloveponies/predicates](https://github.com/iloveponies/predicates)

[Here](basic-tools.html#how-to-submit-answers-to-exercises) are the
instructions if you need them. Be sure to fork the repository behind the link
above.

## Functions as Parameters

So how do you write a funtion that takes a function as a parameter? Well, for
starters, let's define a function called `(apply-1 f x)` that should return
`(f x)`:

~~~{.clojure}
(defn apply-1 [f x]
  (f x))
~~~

When you take a function as a parameter, you treat it like any other
parameter. In clojure functions are just normal values and you can pass them
around however you like. Calling a function parameter works like calling any
other function.

~~~{.clojure}
(apply-1 str 13) ;=> (str 13) ;=> "13"
~~~

<exercise>
Write the function `(sum-f f g x)` that returns `(+ (f x) (g x))`.

~~~{.clojure}
(sum-f inc dec 4) ;=> 8
(sum-f inc identity 5) ;=> 11
(sum-f identity - 10) ;=> 0
~~~
</exercise>

## Functions as Return Values

A function that returns a boolean value (`false` or `true`) is called a
predicate. Usually their name ends in a question mark `?`. We've already
defined a bunch of them and used them with `filter`.

Let's write a function that returns a predicate. Suppose that I want to get
all numbers greater than some limit from a sequence. I need a predicate for
this grater than testing. Here's a function that returns such predicates.

~~~{.clojure}
(defn greater-than [n]
  (fn [k] (> k n)))
~~~

We've already formed helper functions with `fn`. Since these functions are
just values, we can just return them.

Let's try it out:

~~~{.clojure}
(filter (greater-than 5) [4 6 5 0 9 2 12]) ;=> (6 9 12)
~~~

<exercise>
Write the functions `(less-than n)` and `(equal-to n)` that work like
`greater-than`. Use `==` as comparison in `equal-to`

~~~{.clojure}
(filter (less-than 3) [1 2 3 4 5])   ;=> (1 2)
(filter (less-than 4) [-2 12 3 4 0]) ;=> (-2 3 0)
(filter (equal-to 2) [2 1 3 2.0])    ;=> (2 2.0)
(filter (equal-to 2) [3 4 5 6])      ;=> ()
~~~
</exercise>

### Keywords and Sets as Predicates

When you have a bunch of maps, you often want to filter those that have a
certain `:keyword` as a key. Most of the time, you can just use the `:keyword`
itself as a predicate.

Here are some graphic novels, some of them belong to a series and some are stand
alones.

~~~{.clojure}
(def graphic-novels [{:name "Yotsuba 1" :series "Yotsuba"}
                     {:name "Yotsuba 5" :series "Yotsuba"}
                     {:name "Persepolis"}
                     {:name "That Yellow Bastard" :series "Sin City"}
                     {:name "The Hard Goodbye" :series "Sin City"}
                     {:name "Maus"}
                     {:name "Solanin"}
                     {:name "Monster 3" :series "Monster"}])
~~~

Now it's easy to filter those that belong to a series:

~~~{.clojure}
(filter :series graphic-novels)
;=> ({:name "Yotsuba 1", :series "Yotsuba"}
;    {:name "Yotsuba 5", :series "Yotsuba"}
;    {:name "That Yellow Bastard", :series "Sin City"}
;    {:name "The Hard Goodbye", :series "Sin City"}
;    {:name "Monster 3", :series "Monster"})
~~~

Trouble arises when the value for `:keyword` can be `nil` or `false`. No
worries though, we can write a function that turns any key into a predicate.

~~~{.clojure}
(defn key->predicate [a-key]
  (fn [a-map] (contains? a-map a-key)))
~~~

And these predicates can be used in the same way.

~~~{.clojure}
(filter (key->predicate "Name") [{"Name" "Joe"} {"Blargh" 3}])
;=> ({"Name" "Joe"})
~~~

A similar thing happens when you want to use a set as a predicate. Set's act
as functions and they work like this. `(a-set x)` evaluates to
- `x` if `x` is in `a-set`
- `nil` otherwise

Now you can use a set as a predicate as long as it doesn't contain `false` or
`nil`. You can, for example, use this with `filter` to get all element's in a
sequence that are also elements of a set:

~~~{.clojure}
(filter #{1 2 3} [0 2 4 6]) ;=> (2)
~~~

Trouble arises, as mentioned, if the set happens to have falsey values in it.

~~~{.clojure}
(filter #{1 2 3 nil} [0 2 4 6 nil]) ;=> (2)
~~~

Let's write a function that turns sets into predicates that works correctly
even in this case.

<exercise>
Write the function `(set->predicate a-set)` that takes a set as a parameter
and returns a predicate that takes a parameter `x` and
- returns `true` if `x` is in `a-seq`
- otherwise returns `false`

~~~{.clojure}
(filter (set->predicate #{1 2 3})     [0 2 4 6])       ;=> (2)
(filter (set->predicate #{1 2 3 nil}) [2 nil 4 nil 6]) ;=> (2 nil nil)
~~~
</exercise>

## Functions that both Take Functions as Parameters and Return Functions

Sometimes you have a predicate that almost does what you want. For an example,
suppose I want to filter all non-negative values from a sequence. There's
`neg?` and `pos?`, but neither allow `0`. I could do something like this:

~~~{.clojure}
(defn non-negatives [a-seq]
  (let [non-negative? (fn [n] (not (neg? n)))]
    (filter non-negative? a-seq)))

(non-negatives [1 -2 9 4 0 -100 2 0 2]) ;=> (1 0 3 0 7)
~~~

Wanting to get the opposite result of a predicate is actually common enough
that there's a function for this. It is called `complement`. `(complement
pred)` takes a predicate and returns a new predicate that returns `true`
when `pred` returns a falsey value and `false` when `pred` returns a truthy
value.

~~~{.clojure}
((complement neg?) -5)
;=> (not (neq? -5))
;=> (not true)
;=> false
((complement neg?) 0) ;=> true
((complement neg?) 12) ;=> true
~~~

Now we can write `non-negatives` using `complement`:

~~~{.clojure}
(defn non-negatives [a-seq]
  (filter (complement neg?) a-seq))
~~~

Okay, so `complement` both takes a function as a parameter and returns a new
function. Let's see the definition of `complement`:

~~~{.clojure}
(defn complement [predicate]
  (fn [x] (not (predicate x))))
~~~

Sometimes you have multiple predicates and you want to know whethet a value or
some values pass all of them. Let's create a helper function to do just that.

<exercise>
Write the function `(pred-and pred1 pred2)` that returns a new predicate that:
 - returns `true` if both `pred1` and `pred2` return `true`
 - otherwise returns `false`

Suppose I wanted all even positive numbers from a sequence. With `pred-and`,
this should be easy.

~~~{.clojure}
(filter (pred-and pos? even?) [1 2 -4 0 6 7 -3]) ;=> [2 6]
~~~

Here are some other test cases:

~~~{.clojure}
(filter (pred-and pos? odd?) [1 2 -4 0 6 7 -3]) ;=> [1 7]
(filter (pred-and (complement nil?) empty?) [[] '() nil {} #{}])
;=> [[] '() {} #{}]
~~~
</exercise>

<exercise>
Write the function `(pred-or pred1 pred2)` that takes two predicates and
returns a new predicate that:
- returns `true` if `pred1` or `pred2` returns true
- otherwise returns `false`

~~~{.clojure}
(filter (pred-or pos? odd?) [1 2 -4 0 6 7 -3])  ;=> [1 2 6 7 -3]
(filter (pred-or pos? even?) [1 2 -4 0 6 7 -3]) ;=> [1 2 -4 0 6 7]
~~~
</exercise>

## Every

Sometimes you want to know if every element in a sequence satisfies a
predicate. To do that, there's `(every? predicate a-seq)`. It returns `true`
if `predicate` returns a truthy value for every element in `a-seq`. Otherwise
it returns `false`.

~~~{.clojure}
(every? pos? [1 2 3])   ;=> true
(every? pos? [0 1 2 3]) ;=> false -- (pos? 0) ;=> false
~~~

It also always returns `true` with an empty collection.

~~~{.clojure}
(every? pos? [])  ;=> true
(every? pos? nil) ;=> true
~~~

Here's a function that you can use to check if a character is whitespace:

~~~{.clojure}
(defn whitespace? [character]
  (Character/isWhitespace character))
~~~

<exercise>
Write the function `(blank? string)` that takes a string as a parameter and
returns `true` if `string` is empty, nil, or only contains whitespace.

Remember that strings can be used as a sequence of characters with sequence
functions like `every?`.

~~~{.clojure}
(blank? " \t\n\t ") ;=> true
(blank? "  \t a")   ;=> false
(blank? "")         ;=> true
~~~

You have just implemented a function with the same semantics as `isWhitespace`
in Apache Commons. Here is the [Java implemention] [isWhitespace] from Apache Commons:

[isWhitespace]: http://svn.apache.org/viewvc/commons/proper/lang/trunk/src/main/java/org/apache/commons/lang3/StringUtils.java?view=markup

~~~{.java}
5370	    public static boolean isWhitespace(CharSequence cs) {
5371	        if (cs == null) {
5372	            return false;
5373	        }
5374	        int sz = cs.length();
5375	        for (int i = 0; i < sz; i++) {
5376	            if (Character.isWhitespace(cs.charAt(i)) == false) {
5377	                return false;
5378	            }
5379	        }
5380	        return true;
5381	    }
~~~

This is a good example about how the ability to easily pass around functions
as parameters can improve clarity.
</exercise>

Earlier we had some books, let's add some data to them. Let's keep track of
some awards.

~~~{.clojure}
(def awards #{:locus, :world-fantasy, :hugo})

(def china {:name "China Miéville", :birth-year 1972})
(def octavia {:name "Octavia E. Butler"
              :birth-year 1947
              :death-year 2006})
(def kay {:name "Guy Gavriel Kay" :birth-year 1954})
(def dick {:name "Philip K. Dick", :birth-year 1928, :death-year 1982})
(def zelazny {:name "Roger Zelazny", :birth-year 1937, :death-year 1995})

(def authors #{china, octavia, kay, dick, zelazny})

(def cities {:title "The City and the City" :authors #{china}
             :awards #{:locus, :world-fantasy, :hugo}})
(def wild-seed {:title "Wild Seed", :authors #{octavia}})
(def lord-of-light {:title "Lord of Light", :authors #{zelazny}
                    :awards #{:hugo}})
(def deus-irae {:title "Deus Irae", :authors #{dick, zelazny}})
(def ysabel {:title "Ysabel", :authors #{kay}, :awards #{:world-fantasy}})
(def scanner-darkly {:title "A Scanner Darkly" :authors #{dick}})

(def books #{cities, wild-seed, lord-of-light,
             deus-irae, ysabel, scanner-darkly}])
~~~


<exercise>
Write the function `(has-award? book award)` that returns `true` if `book` has
won `award`.

~~~{.clojure}
(has-award? ysabel :world-fantasy) ;=> true
(has-award? scanner-darkly :hugo)  ;=> false
~~~
</exercise>

<exercise>
Write the function `(HAS-ALL-THE-AWARDS? book awards)` that returns `true` if
`book` has won every award in `awards`.

~~~{.clojure}
(HAS-ALL-THE-AWARDS? cities awards)          ;=> true
(HAS-ALL-THE-AWARDS? lord-of-light awards)   ;=> false
(HAS-ALL-THE-AWARDS? lord-of-light #{:hugo}) ;=> true
(HAS-ALL-THE-AWARDS? scanner-darkly #{})     ;=> true
~~~
</exercise>

## And Then There Were Some

Finally, when you wan't to know if at least one element of a sequence passes a
predicate, there is `(some pred a-seq)` which returns a truthy value if `pred`
returns a truthy value for some element in `a-seq` and otherwise it returns
`nil`.

~~~{.clojure}
(some whitespace? "Kekkonen")          ;=> nil
(some whitespace? "Kekkonen Kekkonen") ;=> True
(some even? [1 2 3])                   ;=> true
(some even? [1 3])                     ;=> false
~~~

`some` is not actually a predicate. It returns the first truthy value returned
by `pred`.

<exercise>
Write you own implementation for `some` called `my-some`.

Hint: You might find `map`, `filter` and `first` useful (you won't necessarily
need them all).

~~~{.clojure}
(my-some even? [1 3 5 7])       ;=> falsey
(my-some even? [1 3 5 7 8])     ;=> true
(my-some neg? [1 3 5 7 8])      ;=> falsey
(my-some neg? [1 3 5 0 7 8])    ;=> falsey
(my-some neg? [1 3 5 0 7 -1 8]) ;=> true
(my-some neg? [])               ;=> falsey
~~~
</exercise>

<exercise>
Write your own implementation for `every?` called `my-every?`.

Hint: the previous hint applies. `empty?` and `complement` might come in handy
as well.

~~~{.clojure}
(my-every? pos? [1 2 3 4])   ;=> true
(my-every? pos? [1 2 3 4 0]) ;=> false
(my-every? even? [2 4 6])    ;=> true
(my-every? even? [])         ;=> true
~~~
</exercise>

<exercise>
Write the function `(prime? n)` that returns `true` if `n` is a
[prime number] [prime] and otherwise `false`.

[prime]: http://en.wikipedia.org/wiki/Prime_number

The function `(range k n)` returns the sequence
~~~{.clojure}
(k (+ k 1) (+ k 2) ... (- n 1))
~~~

Here's a concrete example:

~~~{.clojure}
(range 2 10) ;=> (2 3 4 5 6 7 8 9)
~~~

A positive integer `p` is a prime number if the only positive numbers dividing
`p` are `p` and `1`.

Your solution should be of the form

~~~{.clojure}
(defn prime? [n]
  (let [pred ...]
    (not (some pred (range 2 n)))))
~~~

Here are some tests:

~~~{.clojure}
(prime? 4) ;=> false
(prime? 7) ;=> true
(prime? 10) ;=> false
(filter prime? (range 2 50)) ;=> (2 3 5 7 11 13 17 19 23 29 31 37 41 43 47)
~~~
</exercise>

[Recursion awaits! →](recursion.html)
