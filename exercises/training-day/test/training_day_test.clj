(ns training-day-test
  (:use training-day
        midje.sweet))

(facts
  (square 2) => 4
  (square 3) => 9)
