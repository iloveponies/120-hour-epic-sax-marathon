#!/usr/bin/perl -p

BEGIN {
    use v5.12;
    use warnings;

    our %tags = (
        exercise => 'success',
        alert    => 'error',
        info     => 'info'
    );

    our %titles = (
        exercise => "Exercise",
        alert    => "Watch out!",
        info     => "Hint"
    );
}

for my $tag (keys %tags) {
    my $class = $tags{$tag};

    my $replacement = qq[<section class="alert alert-$class"><h3>$titles{$tag}</h3>];

    s#<$tag>#$replacement#;
    s#</$tag>#\n</section>#;
}
