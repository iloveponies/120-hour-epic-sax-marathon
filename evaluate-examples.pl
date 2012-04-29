#!/usr/bin/env perl

use strict;
use warnings;
use utf8::all;
use v5.14;

sub evaluate {
    my ($block) = @_;

    return "EVALUATED LOL";
}

my @blocks;
my $current_block = "";
my $state = "out";

while (chomp (my $line = <>)) {
    if ($state eq "out") {
        if ($line eq '~~~ {.clojure}') {
            $state = "in";
            push @blocks, $current_block . "\n" . $line;
            $current_block = "";
        }
        else {
            $current_block .= "\n" . $line;
        }
    }
    elsif ($state eq "in") {
        if ($line eq '~~~') {
            $state = "out";
            push @blocks, evaluate($current_block);
            $current_block = $line;
        }
        elsif ($line eq '~~~ {.clojure}') {
            die "syntax error;"
        }
        else {
            $current_block .= "\n" . $line;
        }
    }
}

push @blocks, $current_block;

say join "\n", @blocks;
