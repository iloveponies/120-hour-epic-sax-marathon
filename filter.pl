#!/usr/bin/env perl -n

BEGIN {
    use v5.14;
    use warnings;

    our %tags = (
        exercise => 'success',
        alert    => 'error',
        info     => 'info'
    );
}

my $x = $_;

for my $tag (keys %tags) {
    my $class = $tags{$tag};

    $x =~ s#<$tag>#<section class="alert alert-$class">#;
    $x =~ s#</$tag>#\n</section>#;
}

print $x;
