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

## You can have a butler

[Leiningen] is a project management tool for Clojure projects. It handles
building the project, declaring and fetching dependencies, opening an
interactive session inside the project, and other things.

We use Leiningen version 2 on this course. Your computer has it installed.

You can run Leiningen with the `lein` command. Leiningen will print a succinct
help listing about the commands it understands.

<section class="alert alert-error">
TODO: Leiningenin komennot
</section>

## REPL or read-eval-print-loop

## Version control with Linus Torvalds

> When in doubt, do exactly the opposite of CVS. <small>Linus Torvalds</small>

<aside class="alert alert-info">
*Note:* We use Leiningen to launch the interactive session for convenience
only. We could just as well have run `java -cp ".:/path/to/clojure.jar"
clojure.main` for the same effect. (On Windows, replace the `:` with `;`.)
Typing `lein repl` is just a bit nicer.  Additionally, Leiningen provides
commandline editing functions that running Clojure directly wouldn't. Try
typing <i class="icon-arrow-up"></i> in the interactive session launched by
Leiningen, then try it in the session launched with `java` directly.
</aside>

lein-midje -plugarin asennuksen jälkeen pitää ajaa lein deps, että "lein
midje" toimii PAITSI lein2:ssa toimii.

[Git]: http://git-scm.com
[Leiningen]: https://github.com/technomancy/leiningen
