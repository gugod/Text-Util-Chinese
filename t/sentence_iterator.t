use strict;
use utf8;
use FindBin '$Bin';

use Text::Util::Chinese qw(sentence_iterator);
use Test2::V0;

open my $fh, '<:utf8', "$Bin/data/rand0m.txt";

my $iter = sentence_iterator(sub { <$fh> });

my $sentences = 0;
my $s = 0;
while (defined(my $s = $iter->())) {
    ok $s =~ /\p{Han}/, $s;
    $sentences++;
}

ok $sentences >= 685, 'the number of sentences muts be more than the number of lines in t/data/rand0m.txt';

done_testing;
