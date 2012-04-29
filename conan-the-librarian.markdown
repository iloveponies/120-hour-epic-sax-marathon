% Conan the Librarian
% 120 hour epic
% sax marathon

## Synopsis

> In which we befriend the REPL and create a library catalog.

- Using the REPL for prototyping.
- Building a set of functions that help each other.

## Your mission, if you should choose to accept it, is…

In the secret dossier called Project Gutenberg data you will find a catalog of
a subset of the Finnish books on Project Gutenberg. The data is in a Clojure
vector and can be read into a program easily:

~~~ {.clojure}
(def books (load-file "books.clj"))
~~~

<section class="alert alert-error">TODO: This doesn't work?!</section>

The elements in `books` are maps that each represents a book, like this:

~~~ {.clojure}
{:title "Nuoren Robertin matka Grönlantiin isäänsä hakemaan"
 :author {:name "Hoffmann, Franz", :birth-year 1814, :death-year 1882}}
~~~

A book is a Clojure map with two keys: `:title` and `:author`.

An author is also a Clojure map. However, while the data contains the birth
and death years for *most* authors, there are books whose authors that do not
have either:

~~~ {.clojure}
{:title "Contigo Pan y Cebolla",
 :author {:name "Gorostiza, Manuel Eduardo  de"}}
~~~

In other words, an author is a map with at least the key `:name`, and
optionally also `:birth-year` and `:death-year`. All authors who have either
`:birth-year` *or* `:death-year` have both. (We checked.)

This is a feature of the original data. The data has another peculiarity: some
authors' names contain a birth year in the form "Name of Author, 1234-", where
1234 is the birth year. This is an artifact of the data extraction script we
used to transform the data into a Clojure map.

However, there is a lot we can do – even with this imperfect data. Imperfect
data is also a good example of the kind of data you often encounter in real
world situations, such as scraping websites or, in general, communicating with
third party systems you have no control over.

## Wants and needs

Our goal is to write a *catalog*, a data structure that we can query to find
all the titles by a certain author.

<section class="alert alert-error">TODO: Some REPL prototyping here.</section>

Now that we have prototyped in the REPL and hopefully have some idea of what
we want to implement, we can start writing code in a file. We're going to
cheat and not tell you what the final function is like. Instead, we will build
up to it, bottom-up, with successive helper methods.

First, this is how the function we will eventually implement will work:

~~~ {.clojure}
(author-catalog books {:name "Gorostiza, Manuel Eduardo  de"})
;=> (TODO)
~~~

## Practice makes perfect

Let's start building the helper functions we need to implement
`author-catalog`.

First, though, let's write a few practice functions to make sure we understand
how the data is structured. An interesting feature in the data is the missing
birth and death years for some authors. Let's see how we could detect these
authors.

<section class="exercise alert alert-success">

Implement the function `(author-has-years? author)`, which returns `true` or
`false` depending on whether the given `author` has the `:birth-year` and
`:death-year` entries.

~~~ {.clojure}
(author-has-years? {:title "Nuoren Robertin matka Grönlantiin isäänsä hakemaan"
                    :author {:name "Hoffmann, Franz", :birth-year 1814, :death-year 1882}})
;=> true

(author-has-years? {:title "Contigo Pan y Cebolla", :author {:name "Gorostiza, Manuel Eduardo  de"}})
;=> false
~~~

</section>

Now that we have a function to detect if an author map contains the year
information, we can, for an example, write a function that will return all the
books whose authors do have the year information. We do not need this for our
catalog, but it is a good practice function.

<section class="exercise alert alert-success">

Write the function `(books-with-author-years books)`, which returns those
books from `books` whose `:author` has `:death-year` and `:birth-year`.

~~~ {.clojure}
(books-with-author-years
    [{:title "Nuoren Robertin matka Grönlantiin isäänsä hakemaan"
      :author {:name "Hoffmann, Franz", :birth-year 1814, :death-year 1882}}
     {:title "Contigo Pan y Cebolla", :author {:name "Gorostiza, Manuel Eduardo  de"}}])
;=> ({:title "Nuoren Robertin matka Grönlantiin isäänsä hakemaan"
;     :author {:name "Hoffmann, Franz", :birth-year 1814, :death-year 1882}})
~~~

</section>

## It's dangerous to go alone! Take this.

Now we start to write the actual helper functions we know we will need to
implement `author-catalog`.

<section class="exercise alert alert-success">

`(authors books)` returns a collection of authors. The returned collection
should not contain the same author multiple times even if the author has
multiple books in `books`.

You can use `distinct` to remove duplicates from a sequence.

~~~ {.clojure}
(authors [{:title "Nuoren Robertin matka Grönlantiin isäänsä hakemaan"
           :author {:name "Hoffmann, Franz", :birth-year 1814, :death-year 1882}}
          {:title "Ihmiskohtaloja"
           :author {:name "Järnefelt, Arvid", :birth-year 1861, :death-year 1932}}
          {:title "Elämän meri"
           :author {:name "Järnefelt, Arvid", :birth-year 1861, :death-year 1932}}])
;=> ({:name "Järnefelt, Arvid", :birth-year 1861, :death-year 1932}
;    {:name "Hoffmann, Franz", :birth-year 1814, :death-year 1882})
~~~

</section>

<section class="exercise alert alert-success">

`(author-names books)` returns a collection of author names, without
duplicates.

~~~ {.clojure}
(author-names [{:title "Nuoren Robertin matka Grönlantiin isäänsä hakemaan"
                :author {:name "Hoffmann, Franz", :birth-year 1814, :death-year 1882}}
               {:title "Ihmiskohtaloja"
                :author {:name "Järnefelt, Arvid", :birth-year 1861, :death-year 1932}}])
;=> ("Hoffmann, Franz", "Järnefelt, Arvid")
~~~

</section>

## The boss fight

<section class="exercise alert alert-success">

Write the function `(author-catalog books)` that returns a new map of the
catalog data with authors as keys and the respective book titles as values.
For an example:

~~~ {.clojure}
(author-catalog [{:title "Nuoren Robertin matka Grönlantiin isäänsä hakemaan"
                  :author {:name "Hoffmann, Franz", :birth-year 1814, :death-year 1882}} 
                 {:title "Ihmiskohtaloja"
                  :author {:name "Järnefelt, Arvid", :birth-year 1861, :death-year 1932}}
                 {:title "Elämän meri"
                  :author {:name "Järnefelt, Arvid", :birth-year 1861, :death-year 1932}}])
;=> {{:name "Hoffmann, Franz",  :birth-year 1814, :death-year 1882} ("Nuoren Robertin matka Grönlantiin isäänsä hakemaan")
;    {:name "Järnefelt, Arvid", :birth-year 1861, :death-year 1932} ("Elämän meri", "Ihmiskohtaloja")}
~~~

</section>
