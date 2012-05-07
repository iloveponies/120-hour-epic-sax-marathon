#!/usr/bin/env perl

use v5.14;
use strict;
use warnings;
use utf8::all;
use autodie;

# Main

parse();

# Subroutines

sub parse {
    my @blocks;
    my $current_block = "";
    my $state = "out";

    while (my $line = <>) {
        if ($state eq "out") {
            if ($line eq "~~~ {.clojure}\n") {
                $state = "in";
                push @blocks, $current_block . $line;
                $current_block = "";
            }
            else {
                $current_block .= $line;
            }
        }
        elsif ($state eq "in") {
            if ($line eq "~~~\n") {
                $state = "out";
                push @blocks, evaluate($current_block);
                $current_block = $line;
            }
            elsif ($line eq "~~~ {.clojure}\n") {
                die "syntax error;"
            }
            else {
                $current_block .= $line;
            }
        }
    }

    push @blocks, $current_block;

    say join "", @blocks;
}

sub evaluate {
    my ($block) = @_;

    return "EVALUATED LOL\n";
}
