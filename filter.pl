#!/usr/bin/perl -p

BEGIN {
    use v5.12;
    use warnings;

    our %tags = (
        exercise => 'success',
        alert    => 'warning',
        info     => 'info'
    );

    our %titles = (
        exercise => "Exercise %n",
        alert    => "Watch out!",
        info     => "Hint"
    );

    my %counts;
}

for my $tag (keys %tags) {
    my $class = $tags{$tag};
    my $title = $titles{$tag};

    while (/<$tag>/) {
        my $count = ($counts{$tag} ||= 1)++;

        $title =~ s/%n/$count/;

        my $replacement = qq[<section class="alert alert-$class"><h3>$title</h3>];

        s#<$tag>#$replacement#;
    }

    s#</$tag>#</section>#g;
}
