% Basic Tools
% 120 hour epic
% sax marathon

## Synopis

- the development environment
- how to submit exercise answers

## First things first

To successfully work through this course, you need to do the following things:

- install a sane editor: Ligh Table, Vim or Emacs
- install Git
- install Leiningen
- make sure to have a github account
- inform the teachers about your github account name TODO weblomake
- read very carefully the submission instructions
- profit

## Editor

As a lisp, Clojure requires some support from the text editor to be
pleasant to write. Luckily a guy named Chris Granger has started an
project to create The editor called Light Table. It's still quite
alfa, but works nicely for your purposes during this course.
[Check it out][LightTable]. When in doubt, use this.

Not suprisingly, both Vim and Emacs have plug-ins to work with
Clojure. For the basics, one should install the clojure-mode from the
Emacs package manager. For a more complete set of tools we can
recommend [Emacs Starter Kit][EST]. In Vim, [VimClojure] provides you
with the necessary goodies.

## Git

## Your very own butler

[Leiningen] is a project management tool for Clojure projects. It
handles various tasks related to projects, including building the
project, declaring and fetching dependencies, opening an interactive
session inside the project, and other such things.

We use Leiningen version 2 preview on this course. It is the
recommended version and it is what get when you follow the these
instructions in Linux:

- In your home directory, create a directory called `bin` if it does
  not exist all ready.
  
~~~ {.sh}
cd ~
mkdir bin
~~~

- Add this directory to your $PATH. If you are using Bash, but this
  inside the file `~/.bashrc`. If you are using some other shell, do
  this where you would normally do these kind of things. If you don't
  know what shell you are using, you are using Bash. If you are in
  Windows, God help you. We won't.

~~~ {.sh}
export PATH=$PATH:~/bin
~~~

You can run Leiningen with the `lein` command. Leiningen will print a succinct
help listing about the commands it understands.

The table below contains some important Leiningen commands.

Command         Description
-------         -----------
compile         Compile the project and report any compilation errors.
midje           Run all [Midje] tests.
repl            Open an interactive Clojure session.
new             Create a new Clojure project.

Now that we have introduced the most basic tools, we can start programming.

## Github

## How to submit answers to exercises

[Proceed, young padawan. →][next]

[LightTable]: http://app.kodowa.com/playground
[EST]: https://github.com/technomancy/emacs-starter-kit
[VimClojure]: https://github.com/vim-scripts/VimClojure
[Git]: http://git-scm.com
[Leiningen]: https://github.com/technomancy/leiningen
[Midje]: https://github.com/marick/Midje
[Ubuntu]: http://ubuntu.com
[Vim]: http://vim.org
[next]: training-day.html
[vm]: http://cs.helsinki.fi/ilmari.vacklin/ClojureBox.zip
[VirtualBox]: http://virtualbox.org
