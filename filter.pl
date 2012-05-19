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

for my $tag (keys %tags) {
    my $class = $tags{$tag};

    s#<$tag>#<section class="alert alert-$class">#;
    s#</$tag>#\n</section>#;
}

print;
