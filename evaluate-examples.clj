(defn evaluate [input]
  "\nLOL EVALUATED\n")

(defn parse [content]
  (let [lines (clojure.string/split content #"\n")
        lines# (count lines)]
    (clojure.string/join
      ""
      (loop [blocks []
             current-block ""
             state :out
             line# 0]
        (if (= line# lines#)
          (conj blocks (str current-block "\n"))
          (let [current-line (get lines line#)
                next-line (inc line#)
                result-block (str current-block "\n" current-line)]
            (case state
              :out (if (= current-line "~~~ {.clojure}")
                     (recur (conj blocks result-block)
                            ""
                            :in
                            (inc line#))
                     (recur blocks
                            result-block
                            state
                            (inc line#)))
              :in (if (= current-line "~~~")
                    (recur (conj blocks (evaluate result-block))
                           current-line
                           :out
                           (inc line#))
                    (recur blocks
                           result-block
                           state
                           (inc line#))))))))))

(let [file-name (first *command-line-args*)]
  (println "Parsing " file-name)
  (println (parse (slurp file-name))))
