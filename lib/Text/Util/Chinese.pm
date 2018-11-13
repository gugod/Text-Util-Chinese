package Text::Util::Chinese;
use strict;
use warnings;
use List::Util qw(uniq);

use Exporter 'import';

our @EXPORT_OK = qw(extract_words);

sub extract_words {
    my ($input_iter) = @_;

    my (%lcontext, %rcontext);

    while( my $txt = $input_iter->() ) {
        my @phrase = split /\P{Letter}/, $txt;
        for (@phrase) {
            next unless /\A\p{Han}+\z/;

            my @c = split("", $_);

            for my $i (0..$#c) {
                if ($i > 0) {
                    $lcontext{$c[$i]}{$c[$i-1]}++;
                    for my $n (2,3) {
                        if ($i >= $n) {
                            $lcontext{ join('', @c[ ($i-$n+1) .. $i] ) }{$c[$i - $n]}++;
                        }
                    }
                }
                if ($i < $#c) {
                    $rcontext{$c[$i]}{$c[$i+1]}++;
                    for my $n (2,3) {
                        if ($i + $n <= $#c) {
                            $rcontext{ join('', @c[$i .. ($i+$n-1)]) }{ $c[$i+$n] }++;
                        }
                    }
                }
            }
        }
    }

    my @words;
    my $threshold = 5;
    for my $x (uniq((keys %lcontext), (keys %rcontext))) {
        next unless length($x) > 1;
        next unless ($threshold <= (keys %{$lcontext{$x}}) && $threshold <= (keys %{$rcontext{$x}}));
        push @words, $x;
    }

    return \@words;
}

1;

__END__
