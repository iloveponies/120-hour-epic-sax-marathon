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

We use Leiningen version 2 on this course. Your computer has it installed.

You can run Leiningen with the `lein` command. Leiningen will print a succinct
help listing about the commands it understands.

<section class="alert alert-error">
TODO: Leiningenin komennot
</section>

## The <abbr title="Read-Eval-Print-Loop">REPL</abbr> or read-eval-print-loop

One of the great features of Clojure (and other languages such as Ruby,
Haskell or Python) is the REPL, or read-eval-print-loop. The REPL is an
interactive session -- very similar to the system shell -- 

<aside class="alert alert-info">
*Note:* We use Leiningen to launch the interactive session for convenience
only. We could just as well have run `java -cp ".:/path/to/clojure.jar"
clojure.main` for the same effect. (On Windows, replace the `:` with `;`.)
Typing `lein repl` is just a bit nicer.  Additionally, Leiningen provides
commandline editing functions that running Clojure directly wouldn't. Try
typing <i class="icon-arrow-up"></i> in the interactive session launched by
Leiningen, then try it in the session launched with `java` directly.
</aside>

## Version control with Linus Torvalds

> When in doubt, do exactly the opposite of CVS. <small>Linus Torvalds</small>

[Git]: http://git-scm.com
[Leiningen]: https://github.com/technomancy/leiningen
