% Basic Tools
% 120 hour epic
% sax marathon

## Synopis

- Shell
    - Unix: sh
    - Windows: ps
- Leiningen
- Clojure REPL
- Git

## The shell game

While there is nothing that forces you to use the shell for Clojure
programming, it is extremely useful to know your way around as shell, no
matter what kind of programming you do. We will use the shell as our primary
mechanism of working with project builds, REPL interaction and other things.

<section class="alert alert-error">
TODO: What do we need to talk about here?
</section>

### sh

Foo barb ar.

### PowerShell

Foo barb ar.

## Your very own butler

[Leiningen] is a project management tool for Clojure projects. It handles
building the project, declaring and fetching dependencies, opening an
interactive session inside the project, and other things.

We use Leiningen version 2 on this course. It should be already installed on
your computer.

You can run Leiningen with the `lein` command. Leiningen will print a succinct
help listing about the commands it understands.

Command         Description
-------         -----------
compile         Compile the project and report any compilation errors.
midje           Run all [Midje] tests.
repl            Open an interactive Clojure session.
new             Create a new Clojure project.

## The <abbr title="Read-Eval-Print-Loop">REPL</abbr> or read-eval-print-loop

One of the great features of Clojure (and other languages such as Ruby,
Haskell or Python) is the REPL, or read-eval-print-loop. The REPL is an
interactive session -- very similar to the system shell -- 

*Aside:* We use Leiningen to launch the interactive session for convenience
only. We could just as well have run `java -cp ".:/path/to/clojure.jar"
clojure.main` for the same effect. (On Windows, replace the `:` with `;`.)
Typing `lein repl` is just a bit nicer.  Additionally, Leiningen provides
commandline editing functions that running Clojure directly wouldn't. Try
typing <i class="icon-arrow-up"></i> in the interactive session launched by
Leiningen, then try it in the session launched with `java` directly.

## Version control with Linus Torvalds

> When in doubt, do exactly the opposite of CVS. <small>Linus Torvalds</small>

[Git]: http://git-scm.com
[Leiningen]: https://github.com/technomancy/leiningen
[Midje]: https://github.com/marick/Midje
