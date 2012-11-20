#!/bin/sh

lein midje | grep -E 'ex [[:digit:]]{1,2} .' | cut -d" " -f 2,3 | uniq
