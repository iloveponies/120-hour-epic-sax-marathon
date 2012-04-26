% Basic Tools
% 120 hour epic
% sax marathon

## Synopis

- Shell
    - sh
    - ps
- Leiningen
- Clojure REPL


<aside class="alert alert-info">
*Note:* We use Leiningen to launch the interactive session for convenience
only. We could just as well have run `java -cp ".:/path/to/clojure.jar"
clojure.main` for the same effect. (On Windows, replace the `:` with `;`.)
Typing `lein repl` is just a bit nicer.  Additionally, Leiningen provides
commandline editing functions that running Clojure directly wouldn't. Try
typing <i class="icon-arrow-up"></i> in the interactive session launched by
Leiningen, then try it in the session launched with `java` directly.
</aside>

lein-midje -plugarin asennuksen jälkeen pitää ajaa lein deps, että "lein midje" toimii PAITSI lein2:ssa toimii.
